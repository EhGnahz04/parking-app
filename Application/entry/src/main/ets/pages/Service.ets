import { Header } from '../components/CommonComponent'
import router from '@ohos.router';
import Prompt from '@system.prompt'

@Entry
@Component
struct Service {
  @State value: string = "";

  build() {
    Column() {
      Header({ title: '客服中心' })

      Text('请输入您的问题或反馈').fontSize(20).fontWeight('bold').margin({ top: 20, bottom: 20 })

      Row() {
        Stack({ alignContent: Alignment.BottomEnd }) {
          TextArea({ placeholder: "请输入内容：" })
            .width("100%")
            .height(300)
            .onChange((value) => {
              this.value = value;
            })

          Text(this.value.length + "/200")
            .fontSize(14)
            .margin(10)
        }
        .layoutWeight(1)
        .width('100%')
        .height(300)
      }
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .height(300)
      .margin({ top: 10 })

      Flex({
        justifyContent: FlexAlign.SpaceAround
      }) {
        Button('取消')
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)
          .onClick(() => {
            router.back()
          })
        Button('确认')
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
          .onClick(() => {
            Prompt.showToast({ message: '已收到您的消息，客服会尽快回复！'})
            router.back()
          })
      }
      .margin({ top: 20, bottom: 20 })

    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}