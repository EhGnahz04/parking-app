// @ts-nocheck
import dayjs from 'dayjs'
import { t_message } from '../model/t_message'

@CustomDialog
@Preview
export struct MessageDialog {
  controller: CustomDialogController
  @Link message: t_message

  build() {
    Column() {
      Column() {
        Text('消息详情')
          .fontSize(20)
          .fontWeight('bold')
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(`用户ID: ${this.message.getU_id()}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(`用户电话: ${this.message.getU_phone()}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(`时间: ${dayjs(this.message.getDate()).format('YYYY-MM-DD HH:mm:ss')}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(`标题: ${this.message.getTitle()}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(`内容: ${this.message.getContent()}`)
          .fontSize(16)
          .margin({ top: 10 })
          .textAlign(TextAlign.Start)
          .height(80)
          .width('100%')
          .textOverflow(TextOverflow.Ellipsis)
      }.padding(20).width('80%')

      Row() {
        Button('确认').onClick(() => {
          this.controller.close()
        })
      }.width('90%').justifyContent(FlexAlign.SpaceAround).margin({ bottom: 20 })
    }
  }
}