// @ts-nocheck
import dayjs from 'dayjs'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_parking.json'
import schema_record from '../../resources/rawfile/schema_record.json'
import { t_parking } from '../model/t_parking'
import { t_record } from '../model/t_record'
import { t_license } from '../model/t_license'
import Prompt from '@system.prompt'
import {initDB} from '../functions/InitDB'

@CustomDialog
export struct ParkingDialog {
  controller: CustomDialogController
  private database: Database = null
  @Link licenseList: t_license[]
  @State parking: t_parking = new t_parking()

  async aboutToAppear(){
    initDB()
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    for (let i = 0; i < this.licenseList.length; i++) {
      const license = this.licenseList[i]
      const parkingList = await this.database.collection(t_parking)
        .query()
        .equalTo("license", license.getLicense())
        .isNotNull("parkTime")
        .notEqualTo("state", 1)
        .orderByAsc("id")
        .get();

      if (parkingList.length > 0) {
        this.parking = parkingList[0]
        break
      }
    }
  }

  build(){
    Column() {
      Text('记录详情')
        .fontSize(20)
        .fontWeight('bold')
        .margin({ top: 10 })
      if (this.parking.getId() === undefined) {
        Text('未查询到停车记录').fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start).height(100)
      } else {
        Column() {
          Text(`车牌号: ${this.parking.getLicense()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
          Text(`进入时间: ${dayjs(this.parking.getBeginTime()).format('YYYY-MM-DD HH:mm:ss')}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
          Text(`离开时间: ${dayjs(this.parking.getEndTime()).format('YYYY-MM-DD HH:mm:ss')}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
          Text(`停车时长（小时）: ${this.parking.getParkTime()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
          Text(`费用: ${this.parking.getFee()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
          Text(`停车场号: ${this.parking.getLot_id()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        }.padding(20).width('80%')

        Text(`总金额: ${this.parking.getFee()} 元`)
          .fontSize(20)
          .fontWeight('bold')
          .margin({top: 10})
        Row() {
          Button('取消').onClick(() => {
            this.controller.close()
          })
          Button('支付').onClick(async () => {
            this.parking.setState(1)
            await this.database.collection(t_parking).upsert(this.parking)

            const user = await cloud.auth().getCurrentUser()
            if (user) {
              const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_record })
              const uid = user.getUid()
              const phone = user.getPhone()
              const records = await database.collection(t_record).query().get()
              const record = new t_record()
              record.setId(records.length + 1)
              record.setU_id(uid)
              record.setU_phone(phone)
              record.setLicense(this.parking.getLicense())
              record.setFee(this.parking.getFee())
              record.setTime(new Date())
              record.setLot_id(this.parking.getLot_id())
              record.setState(1)
              await database.collection(t_record).upsert(record)
            }

            Prompt.showToast({ message: '支付成功' })
            this.controller.close()
          })
        }.width('90%').justifyContent(FlexAlign.SpaceAround).margin({bottom: 10})
      }
    }
  }
}
