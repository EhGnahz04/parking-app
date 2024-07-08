// @ts-nocheck
import dayjs from 'dayjs'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_parking.json'
import schema_record from '../../resources/rawfile/schema_record.json'
import { t_parking } from '../model/t_parking'
import { t_record } from '../model/t_record'
import Prompt from '@system.prompt'
import {initDB} from '../functions/InitDB'

@CustomDialog
export struct ParkingDialog {
  controller: CustomDialogController
  private database: Database = null
  @Prop license: string
  @State fee: number = 0
  @State lot_id: number = 0
  @State parkingList: t_parking[] = []

  async aboutToAppear(){
    initDB()

    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.parkingList = await this.database.collection(t_parking).query().equalTo("license", this.license).isNotNull("parkTime").notEqualTo("state", 1).orderByAsc("id").get()
    this.fee = await this.parkingList.reduce((total, parking) => total + parking.getFee(), 0)
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
            this.lot_id = parking.getLot_id()
            await this.database.collection(t_parking).upsert(parking)
          }

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
            record.setLicense(this.license)
            record.setFee(this.fee)
            record.setTime(new Date())
            record.setLot_id(this.lot_id)
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
