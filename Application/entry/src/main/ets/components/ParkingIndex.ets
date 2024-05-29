import { ProvinceKeyboard } from './LicenseKeyboard'
import { Keyboard } from './LicenseKeyboard'
import cloud from '@hw-agconnect/cloud'

@Component
export struct ParkingFee {
  @State license: string = ''
  @State status: number = 1

  build() {
    Column() {

      if (this.status == 1) {
        Row() {
          Text('请输入车牌号缴费').fontSize(20).fontWeight('bold')
          Blank()
          Text('切换其他车牌').fontSize(20).fontColor('#007AFF').onClick(() => this.status = 0)
        }
        .width('90%')
        .height(30)
        .justifyContent(FlexAlign.Start)

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
          // .onClick(async() => {
          //   const result = await cloud.callFunction({
          //       name: 'hello',
          //       version: '$latest',
          //       params: {}
          //     })
          //   this.hello = result.getValue().desc
          // })
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