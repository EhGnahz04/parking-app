// @ts-nocheck
import dayjs from 'dayjs'
import { t_record } from '../model/t_record'
import Prompt from '@system.prompt'

@CustomDialog
@Preview
export struct RecordDialog {
  controller: CustomDialogController
  @Link record: t_record
  @Prop isAdmin: boolean

  build() {
    Column() {
      Column() {
        Text('订单详情').fontSize(20).fontWeight('bold').margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`ID: ${this.record.getId()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`用户ID: ${this.record.getU_id()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`车牌号: ${this.record.getLicense()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`费用: ${this.record.getFee()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`状态: ${this.record.getState()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`时间: ${dayjs(this.record.getTime()).format('YYYY-MM-DD HH:mm:ss')}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
        Text(`用户电话: ${this.record.getU_phone()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
        Text(`停车场ID: ${this.record.getLot_id()}`).fontSize(16).margin({ top: 10 }).textAlign(TextAlign.Start)
      }.padding(20).width('80%')

      Row() {
        if (this.isAdmin) {
          Button('取消').onClick(() => {
            this.controller.close()
          })
          Button('退款').onClick(async () => {
            this.record.setState(2)
            Prompt.showToast({ message: '退款成功' })
            this.controller.close()
          })
        } else {
          Button('确认').onClick(() => {
            this.controller.close()
          })
        }
      }.width('90%').justifyContent(FlexAlign.SpaceAround).margin({ bottom: 20 })
    }
  }
}