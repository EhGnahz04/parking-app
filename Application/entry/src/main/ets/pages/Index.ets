import cloud from '@hw-agconnect/cloud'
import router from '@ohos.router'
import { ParkingFee } from '../components/ParkingIndex'
import { UserIndex } from '../components/UserIndex'
import { Login } from '../pages/Login'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  isLogin: boolean = false

  async aboutToAppear() {
    try {
      let user = AppStorage.Get('user')
      if (user) {
        this.isLogin = true
      }
    } catch (e) {
      console.error(e)
    }
  }

  @Builder TabBarBuilder(title: ResourceStr, image: ResourceStr, index: number) {
    Column({ space: 8 }) {
      Image(image)
        .width(22)
        .fillColor(this.selectColor(index))
      Text(title)
        .fontSize(14)
        .fontColor(this.selectColor(index))
    }
  }

  selectColor(index: number) {
    return this.currentIndex === index ? '#02BD79' : '#676c7f'
  }

  build() {
    Tabs() {
      TabContent() {
        ParkingFee()
      }
      .tabBar(this.TabBarBuilder('停车缴费', $r('app.media.parking'), 0))

      TabContent() {
        if (this.isLogin) {
          UserIndex()
        } else {
          Login()
        }
      }
      .tabBar(this.TabBarBuilder('用户中心', $r('app.media.user'), 1))
    }
    .width('100%')
    .height('100%')
    .onChange(index => this.currentIndex = index)
    .barPosition(BarPosition.End)
  }
}
