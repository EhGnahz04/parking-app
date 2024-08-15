// @ts-nocheck
import { ParkingDialog } from './ParkingDialog'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_license.json'
import { t_license } from '../model/t_license'
import router from '@ohos.router'

@Component
export struct ParkingFee {
  @State license: string = ''
  @State licenseList: t_license[] = []
  private database: Database = null
  private phone: string = ''
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: ParkingDialog({ licenseList: $licenseList }),
    offset: { dx: 0, dy: -20 },
    alignment: DialogAlignment.Bottom,
  })

  async aboutToAppear() {
    const user = await cloud.auth().getCurrentUser()
    this.phone = user.getPhone()
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.licenseList = await this.database.collection(t_license)
      .query()
      .equalTo('u_phone', this.phone)
      .get()
  }

  build() {
    Column() {
      Text('我的车辆').fontSize(30).margin({ top: 10, bottom: 30 }).fontWeight(FontWeight.Bold)
      if (this.licenseList.length === 0) {
        Text('暂无车辆，请点此添加')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0aa671')
          .margin({ top: 60 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/AddCar' })
          })
      } else {
        List({ space: 10 }) {
          ForEach(
            this.licenseList,
            (item: t_license) => {
              ListItem() {
                Row() {
                  Text(item.getLicense()).fontSize(20)
                }
                .width('95%')
                .padding(20)
                .backgroundColor(Color.White)
                .borderRadius(15)
                .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
                .justifyContent(FlexAlign.SpaceBetween)
              }
            }
          )
        }
        .width('100%')
        .height(200)
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Auto)
      }
      Button('查询').onClick(() => {
        this.dialogController.open()
      }).size({ width: 200, height: 50 }).margin({ top: 30 })
    }
  }
}