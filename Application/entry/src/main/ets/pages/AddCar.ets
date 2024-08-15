// @ts-nocheck
import { ProvinceKeyboard } from '../components/LicenseKeyboard'
import { Keyboard } from '../components/LicenseKeyboard'
import { Header } from '../components/CommonComponent'
import router from '@ohos.router'
import cloud, { Database } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/schema_license.json'
import { t_license } from '../model/t_license'
import Prompt from '@system.prompt'

@Entry
@Component
struct AddCar {
  @State license: string = ''
  @State status: number = 1

  build() {
    Column() {
      Header({ title: '添加车辆' })
      if (this.status == 1) {
        Row() {
          Text('请输入车牌号缴费').fontSize(20).fontWeight('bold')
          Blank()
          Text('切换其他车牌').fontSize(20).fontColor('#007AFF').onClick(() => this.status = 0)
        }
        .width('90%')
        .height(30)
        .justifyContent(FlexAlign.Start)
        .margin({ top: 20 })

        this.showLicense()

        if (this.license.length == 0) {
          ProvinceKeyboard({ province: $license })
        } else {
          Keyboard({ license: $license })
        }
      } else {
        Row() {
          Text('请输入车牌号缴费').fontSize(20).fontWeight('bold')
          Blank()
          Text('切换内地车牌').fontSize(20).fontColor('#007AFF').onClick(() => this.status = 1)
        }
        .width('90%')
        .height(30)
        .justifyContent(FlexAlign.Start)
        .margin({ top: 20 })

        Blank().height(60)

        TextInput()
          .fontSize(20)
          .width('90%')
          .height(40)
          .margin({ top: 10 })
          .onChange((value) => this.license = value)

        Blank().height(270)
      }

      Row() {
        Button('清空').onClick(() => this.license = '')
        Button('确认')
          .onClick(async () => {
            const user = await cloud.auth().getCurrentUser()
            const phone = user.getPhone()
            const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema })

            if (this.license.length > 0) {
              let license = new t_license()
              license.setU_phone(phone)
              license.setLicense(this.license)
              await database.collection(t_license).upsert(license)
              Prompt.showToast({ message: '添加成功' })
            }
            router.replaceUrl({ url: 'pages/MyCar', params: { license: this.license } })
          })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: 20 })

    }
  }

  @Builder showLicense() {
    Grid() {
      ForEach(this.license.split(''), char => {
        GridItem() {
          Text(char).fontSize(30).height(50)
        }
      })
      ForEach(new Array(8 - this.license.length).fill(''), () => {
        GridItem() {
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .width('90%')
    .height(80)
    .columnsGap(8)
    .rowsGap(8)
    .padding(8)
    .margin({ top: 10 })
  }
}