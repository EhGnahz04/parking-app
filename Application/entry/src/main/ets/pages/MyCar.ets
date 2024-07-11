// @ts-nocheck
import cloud, { Database } from '@hw-agconnect/cloud'
import { Header } from '../components/CommonComponent'
import schema from '../../resources/rawfile/schema_license.json'
import { t_license } from '../model/t_license'
import router from '@ohos.router'

@Styles function card() {
  .width('95%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({ radius: 6, color: '#1F000000', offsetX: 2, offsetY: 4 })
}

@Entry
@Component
struct MyCar {
  @State licenseList : t_license[] = []
  private database: Database = null
  private phone: string = ''

  async aboutToAppear() {
    const user = await cloud.auth().getCurrentUser()
    this.phone = user.getPhone()
    this.database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })
    this.licenseList = await this.database.collection(t_license).query().equalTo('u_phone', this.phone).get()
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.back'))
          .width(30)
          .margin({ left: 20 })
          .onClick(() => {
            router.replaceUrl({ url : 'pages/Index' })
          })

        Text('我的爱车')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10, left: '33%', top: 10 })
      }
      .width('100%')

      Button('新增车辆')
        .width(200)
        .margin({ top: 10 })
        .onClick(() => {
          router.replaceUrl({ url : 'pages/AddCar' })
        })

      List({ space: 10 }) {
        ForEach(
          this.licenseList,
          (item: t_license, index) => {
            ListItem() {
              Row() {
                Text(item.getLicense())
                  .fontSize(20)
              }
              .card()
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .swipeAction({ end: this.DeleteButton(index) })
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F2F3')
  }

  @Builder DeleteButton(index: number) {
    Button() {
      Image($r('app.media.delete'))
        .fillColor(Color.White)
        .width(20)
    }
    .width(40)
    .height(40)
    .type(ButtonType.Circle)
    .backgroundColor(Color.Red)
    .margin(5)
    .onClick(async() => {
      await this.database.collection(t_license).delete(this.licenseList[index])
      this.licenseList.splice(index, 1)
    })
  }
}
