// @ts-nocheck
import dayjs from 'dayjs'
import { Header } from '../components/CommonComponent'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_message.json'
import { t_message } from '../model/t_message'
import { MessageDialog } from '../components/MessageDialog'

@Entry
@Component
struct MessageBox {
  @State messageList: t_message[] = []
  private database: Database = null
  @State message: t_message = new t_message()

  private dialogController: CustomDialogController = new CustomDialogController({
  builder: MessageDialog({ message: $message }),
  offset: { dx: 0, dy: -20 },
  alignment: DialogAlignment.Center,
})

  async aboutToAppear() {
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.messageList = await this.database.collection(t_message).query().orderByDesc('id').get()
  }

  build() {
    Column() {
      Header({ title: '收件箱' })
      List({ space: 10 }) {
        ForEach(
          this.messageList,
          (cord: t_message) => {
            ListItem() {
              Column() {
                Row() {
                  if (cord.getState() == 1)
                  {
                    Text(cord.getTitle()).width(200).fontColor('#CCC')
                    Text(dayjs(cord.getDate()).format('YYYY-MM-DD')).fontColor('#CCC').width(80)
                  } else {
                    Text(cord.getTitle()).width(200).fontColor('#008000')
                    Text(dayjs(cord.getDate()).format('YYYY-MM-DD')).fontColor('#008000').width(80)
                  }
                }
                .backgroundColor('#FFFFFF')
                .height(50)
                .width('95%')
                .justifyContent(FlexAlign.Center)
                .borderRadius(30)
                .onClick(async() => {
                  this.message = cord
                  this.dialogController.open()
                  cord.setState(1)
                  await this.database.collection(t_message).upsert(cord)
                  this.messageList = await this.database.collection(t_message).query().orderByDesc('id').get()
                })
              }
            }
          })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .backgroundColor('#EFEFEF')
  }
}
