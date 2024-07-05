// @ts-nocheck
import dayjs from 'dayjs'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_parking.json'
import schema_record from '../../resources/rawfile/schema_record.json'
import schema_in from '../../resources/rawfile/schema_in.json'
import { t_parking } from '../model/t_parking'
import { t_record } from '../model/t_record'
import { t_in } from '../model/t_in'
import Prompt from '@system.prompt'
import http from '@ohos.net.http'

@CustomDialog
@Preview
export struct ParkingDialog {
  controller: CustomDialogController
  private database: Database = null
  @Prop license: string
  @State fee: number = 0
  @State parkingList: t_parking[] = []
  @State id: number = 0

  async aboutToAppear(){
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.parkingList = await this.database.collection(t_parking).query().equalTo("license", this.license).isNotNull("parkTime").equalTo("state", 0).orderByAsc("id").get()
    this.fee = await this.parkingList.reduce((total, parking) => total + parking.getFee(), 0)

    let httpRequest = http.createHttp()
    let url = 'https://parking-85f1.obs.cn-southwest-2.myhuaweicloud.com/in.txt'
    httpRequest.request(url, {
      method: http.RequestMethod.GET,
    }, (err, data) => {
      if (!err) {
        const lines = data.result.toString().split('\n');
        const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_in });
        for (const line of lines) {
          const [license, time, lot_id] = line.split(' ')
          this.id +=1
          const inRecord = new t_in()
          inRecord.setId(this.id)
          inRecord.setLicense(license)
          inRecord.setTime(new Date(time))
          inRecord.setLot_id(parseInt(lot_id))
          database.collection(t_in).upsert(inRecord)
        }
      } else {
        this.message = "Failed to load file";
        prompt.showToast({
          message: "Error fetching file: " + err,
        });
      }
    });
  }

  build(){
    Column() {
      Text('待缴费用')
        .fontSize(20)
        .fontWeight('bold')
        .margin({ top: 10 })
      List({ space: 10 }) {
        ForEach(
          this.parkingList,
          (cord: t_parking) => {
            ListItem() {
              Row() {
                Text(dayjs(cord.getBeginTime()).format('YYYY-MM-DD HH:mm:ss')).width('45%')
                Text(dayjs(cord.getEndTime()).format('YYYY-MM-DD HH:mm:ss')).width('45%')
                Text(cord.getParkTime().toString()).width('20%')
              }.width('100%').justifyContent(FlexAlign.SpaceAround)
            }
          })
      }
      .width('100%')
      .height('15%')

      Text(`总金额: ${this.fee} 元`)
        .fontSize(20)
        .fontWeight('bold')
        .margin({top: 10})

      Row() {
        Button('取消').onClick(() => {
          this.controller.close()
        })
        Button('支付').onClick(async () => {
          for (const parking of this.parkingList) {
            parking.setState(1)
            await this.database.collection(t_parking).upsert(parking)
          }

          const user = await cloud.auth().getCurrentUser()
          if (user) {
            const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_record })
            const uid = user.getUid()
            const records = await database.collection(t_record).query().get()
            const record = new t_record()
            record.setId(records.length + 1)
            record.setU_id(uid)
            record.setLicense(this.license)
            record.setFee(this.fee)
            record.setTime(new Date())
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
