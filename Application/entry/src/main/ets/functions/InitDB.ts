// @ts-nocheck
import cloud from '@hw-agconnect/cloud'
import schema_in from '../../resources/rawfile/schema_in.json'
import schema_out from '../../resources/rawfile/schema_out.json'
import schema_parking from '../../resources/rawfile/schema_parking.json'
import { t_in } from '../model/t_in'
import { t_out } from '../model/t_out'
import { t_parking } from '../model/t_parking'
import http from '@ohos.net.http'
import Prompt from '@system.prompt'

export async function initDB() {
  let httpRequest = http.createHttp()
  let url_in = 'https://bbbb-ab5c.obs.cn-north-4.myhuaweicloud.com/in.txt'
  let url_out = 'https://bbbb-ab5c.obs.cn-north-4.myhuaweicloud.com/out.txt'
  let id = 0
  const database_in = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_in })
  httpRequest.request(url_in, {
    method: http.RequestMethod.GET,
  }, (err, data) => {
    if (!err) {
      const lines = data.result.toString().split('\n').slice(1)
      for (const line of lines) {
        const [license, date, time] = line.split(' ')
        id += 1
        const inRecord = new t_in()
        inRecord.setId(id)
        inRecord.setLicense(license)
        const dateTime = `${date}T${time}`
        inRecord.setTime(new Date(dateTime))
        inRecord.setLot_id(1)
        database_in.collection(t_in).upsert(inRecord)
      }
    } else {
      Prompt.showToast({
        message: "Error fetching file: " + err,
      })
    }
  })

  let id2 = 0
  const database_out = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_out })
  httpRequest.request(url_out, {
    method: http.RequestMethod.GET,
  }, (err, data) => {
    if (!err) {
      const lines = data.result.toString().split('\n')
      for (const line of lines) {
        const [license, date, time] = line.split(' ')
        id2 += 1
        const outRecord = new t_out()
        outRecord.setId(id2)
        outRecord.setLicense(license)
        const dateTime = `${date}T${time}`
        outRecord.setTime(new Date(dateTime))
        outRecord.setLot_id(1)
        database_out.collection(t_out).upsert(outRecord)
      }
    } else {
      Prompt.showToast({
        message: "Error fetching file: " + err,
      })
    }
  })

  const inRecords = await database_in.collection(t_in).query().get()
  const outRecords = await database_out.collection(t_out).query().get()
  const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_parking })
  for (const inRecord of inRecords) {
    const parkingRecord = new t_parking()
    parkingRecord.setId(inRecord.getId().toString())
    parkingRecord.setLicense(inRecord.getLicense())
    parkingRecord.setBeginTime(inRecord.getTime())
    parkingRecord.setLot_id(inRecord.getLot_id())

    // Find the corresponding outRecord
    const correspondingOutRecords = outRecords.filter(outRecord =>
    outRecord.getLot_id() === inRecord.getLot_id() &&
    outRecord.getTime() > inRecord.getTime()
    )

    correspondingOutRecords.sort((a, b) => a.getTime() - b.getTime())
    const endTime = correspondingOutRecords.length > 0 ? correspondingOutRecords[0].getTime() : null
    parkingRecord.setEndTime(endTime)

    if (endTime) {
      const parkTime = (parkingRecord.getEndTime() - parkingRecord.getBeginTime()) / 1000 / 60 / 60
      parkingRecord.setParkTime(Math.ceil(parkTime))
      parkingRecord.setFee(Math.ceil(parkTime) * 2)
    }

    const currentRecord = await database.collection(t_parking).query().equalTo('beginTime', inRecord.getTime()).get()
    if (currentRecord.length === 0) {
      parkingRecord.setState(0)
      database.collection(t_parking).upsert(parkingRecord)
    }
  }
}