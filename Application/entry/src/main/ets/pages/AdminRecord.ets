// @ts-nocheck
import dayjs from 'dayjs'
import { Header } from '../components/CommonComponent'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_record.json'
import { t_record } from '../model/t_record'
import { RecordDialog } from '../components/RecordDialog'
import Prompt from '@system.prompt'


@Entry
@Component
struct AdminRecord {
  @State recordList: t_record[] = []
  @State showRecordList: t_record[] = []
  private database: Database = null
  @State changeValue: string = ''
  @State submitValue: string = ''
  @State record: t_record = new t_record()
  controller: SearchController = new SearchController()

  private dialogController: CustomDialogController = new CustomDialogController({
    builder: RecordDialog({ record: $record, isAdmin: true }),
    offset: { dx: 0, dy: -20 },
    alignment: DialogAlignment.Center,
  })

  async aboutToAppear() {
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.recordList = await this.database.collection(t_record).query().orderByAsc("id").get()
    this.showRecordList = this.recordList
  }

  build() {
    Column() {
      Header({ title: '订单管理' })
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
              return cord.getU_phone().toString().includes(value)
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
                  Text(cord.getU_phone().toString()).width(160).fontColor('#008000')
                  Text(dayjs(cord.getTime()).format('YYYY-MM-DD HH:mm:ss')).fontColor('#008000').width(150)
                  Text(cord.getFee().toString()).fontColor('#008000').width(30)
                }
                .backgroundColor('#FFFFFF')
                .height(50)
                .width('95%')
                .justifyContent(FlexAlign.Center)
                .borderRadius(30)
                .onClick(async() => {
                  this.record = cord
                  this.dialogController.open()
                  await this.database.collection(t_record).upsert(this.record)
                })
              }
            }
          })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .height('100%')
    .backgroundColor('#EFEFEF')
  }
}