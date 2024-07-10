// @ts-nocheck
import { Header } from '../components/CommonComponent'
import router from '@ohos.router'
import Prompt from '@system.prompt'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_message.json'
import { t_message } from '../model/t_message'

@Entry
@Component
struct Service {
  @State content: string = ""
  @State title: string = ""
  @State id: number = ""
  private database: Database = null

  async aboutToAppear(){
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    const messageList = await this.database.collection(t_message).query().get()
    this.id = messageList.length + 1
  }

  build() {
    Column() {
      Header({ title: '客服中心' })

      Text('请输入您的问题或反馈').fontSize(20).fontWeight('bold').margin({ top: 20, bottom: 20 })

      TextArea({ placeholder: "请输入标题：" })
        .width('100%')
        .height(37)
        .onChange((value) => {
          this.title = value;
        })

      Row() {
        Stack({ alignContent: Alignment.BottomEnd}) {
          TextArea({ placeholder: "请输入内容：" })
            .width("100%")
            .height(300)
            .onChange((value) => {
              this.content = value;
            })

          Text(this.content.length + "/200")
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
          .onClick(async() => {
            const message = new t_message()
            const user = await cloud.auth().getCurrentUser()
            message.setId(this.id)
            message.setTitle(this.title)
            message.setContent(this.content)
            if (user) {
              message.setU_id(user.getUid())
              message.setU_phone(user.getPhone())
            }
            message.setDate(new Date())
            await this.database.collection(t_message).upsert(message)
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