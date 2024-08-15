// @ts-nocheck
import dayjs from 'dayjs'
import { Header } from '../components/CommonComponent'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_record.json'
import { t_record } from '../model/t_record'
import { RecordDialog } from '../components/RecordDialog'


@Entry
@Component
struct record {
  @State recordList: t_record[] = []
  @State showRecordList: t_record[] = []
  private database: Database = null
  @State changeValue: string = ''
  @State submitValue: string = ''
  @State record: t_record = new t_record()
  controller: SearchController = new SearchController()
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: RecordDialog({ record: $record, isAdmin: false }),
    offset: { dx: 0, dy: -20 },
    alignment: DialogAlignment.Center,
  })

  async aboutToAppear() {
    const user = await cloud.auth().getCurrentUser()
    const uid = user.getUid()
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.recordList = await this.database.collection(t_record)
      .query()
      .equalTo('u_id', uid)
      .orderByAsc("id")
      .get()
    this.showRecordList = this.recordList
  }

  build() {
    Column() {
      Header({ title: '缴费记录' })
        .margin({ top: 10 })

      Search({ value: this.changeValue, placeholder: 'Type to search...', controller: this.controller })
        .searchButton('SEARCH')
        .width('90%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .textFont({ size: 14, weight: 400 })
        .onSubmit((value: string) => {
          this.submitValue = value
          if (value == '') {
            this.showRecordList = this.recordList
          } else {
            this.showRecordList = this.recordList.filter((cord: t_record) => {
              return cord.getLicense().includes(value)
            })
          }
        })
        .onChange((value: string) => {
          this.changeValue = value
        })
        .margin(20)


      List({ space: 10 }) {
        ForEach(
          this.showRecordList,
          (cord: t_record) => {
            ListItem() {
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
                    Text(dayjs(cord.getTime()).format('YYYY-MM-DD HH:mm:ss'))
                      .width(170)
                      .fontColor('#CCC')
                      .decoration({ type: TextDecorationType.LineThrough })
                    Text(cord.getLicense())
                      .width(95)
                      .fontColor('#CCC')
                      .decoration({ type: TextDecorationType.LineThrough })
                    Text(cord.getFee().toString())
                      .width(30)
                      .fontColor('#CCC')
                      .decoration({ type: TextDecorationType.LineThrough })
                    Text('已退款').fontColor('#CCC').decoration({ type: TextDecorationType.LineThrough })
                  }
                }
                .height(50)
                .width('100%')
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#FFFFFF')
                .borderRadius(30)
                .onClick(() => {
                  this.record = cord
                  this.dialogController.open()
                })
              }
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