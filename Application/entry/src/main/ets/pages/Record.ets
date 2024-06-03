// @ts-nocheck
import dayjs from 'dayjs'
import { Header } from '../components/CommonComponent'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_record.json'
import { t_record } from '../model/t_record'

@Builder function CordCard(cord: t_record) {
  Column() {
    Row() {
      if (cord.getState() == 1) {
        Text(dayjs(cord.getTime()).format('YYYY-MM-DD HH:mm:ss')).fontColor('#008000').width(170)
        Text(cord.getLicense()).fontColor('#008000').width(95)
        Text(cord.getFee().toString()).fontColor('#008000').width(30)
        Text('已缴费').fontColor('#008000')
      } else if (cord.getState() == 0) {
        Text(dayjs(cord.getTime()).format('YYYY-MM-DD HH:mm:ss')).fontColor('#FF0000').width(170)
        Text(cord.getLicense()).fontColor('#FF0000').width(95)
        Text(cord.getFee().toString()).fontColor('#FF0000').width(30)
        Text('未缴费').fontColor('#FF0000')
      } else if (cord.getState() == 2) {
        Text(dayjs(cord.getTime()).format('YYYY-MM-DD HH:mm:ss')).width(170).fontColor('#CCC').decoration({ type: TextDecorationType.LineThrough })
        Text(cord.getLicense()).width(95).fontColor('#CCC').decoration({ type: TextDecorationType.LineThrough })
        Text(cord.getFee().toString()).width(30).fontColor('#CCC').decoration({ type: TextDecorationType.LineThrough })
        Text('已取消').fontColor('#CCC').decoration({ type: TextDecorationType.LineThrough })
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}


@Entry
@Component
struct record {
  @State recordList: t_record[] = []
  private database: Database = null

  async aboutToAppear() {
    const user = await cloud.auth().getCurrentUser()
    const uid = user.getUid()
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.recordList = await this.database.collection(t_record).query().equalTo('u_id', uid).orderByAsc("id").get()
  }

  build() {
    Column() {
      Header({ title: '缴费记录' })
        .margin({ top: 10 })

      List({ space: 10 }) {
        ForEach(
          this.recordList,
          (cord: t_record) => {
            ListItem() {
              CordCard(cord)
            }
          })
      }
      .width('100%')
      .layoutWeight(1)

    }
    .width('100%')
    .backgroundColor('#EFEFEF')

  }
}