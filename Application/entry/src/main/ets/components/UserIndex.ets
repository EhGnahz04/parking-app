import cloud, {AuthUser} from '@hw-agconnect/cloud'
import router from '@ohos.router'
import hilog from '@ohos.hilog'

@Preview
@Component
export struct UserIndex {
  @State account: string = AppStorage.Get('account')
  @StorageLink('user') user: AuthUser = null
  private items: Array<panelData> = [
    new panelData('用户协议', $r('app.media.logo')),
    new panelData('平台资质', $r('app.media.logo')),
    new panelData('我要合作', $r('app.media.logo')),
    new panelData('规则中心', $r('app.media.logo')),
  ]
  @State balance: number = 0
  @State photoUrl: string = ''

  //局部公共样式函数
  @Styles userPageSty(){
    .width('95%')
    .padding(10)
    .borderRadius(10)
    .backgroundColor('#FFF')
  }

  aboutToAppear(){
    this.photoUrl = this.user.getPhotoUrl()
  }

  build() {
    Column() {

      Column({ space: 15 }) {
        Text('我的')
          .fontColor(Color.White)
          .fontSize(20)
          .margin({ top: 40 })
        Image(this.photoUrl?this.photoUrl:$r('app.media.logo')).width(60).borderRadius(50).margin(20)
        Text(this.account).fontColor(Color.White)
      }
      .width('100%')
      .height('30%')
      .padding({ left: 20, right: 20 })
      .backgroundColor('#0aa671')

      Column({ space: 10 }) {

        Column({ space: 6 }) {
          Text(`${this.balance.toFixed(2)}元`)
          Row() {
            Text('账户余额')
            Text('>')
          }
        }
        .margin({ top: -20 })
        .height(60)
        .alignItems(HorizontalAlign.Start)
        .userPageSty()

        Row({ space: 10 }) {
          Column() {
            Image($r('app.media.order')).width(45)
            Text('缴费订单')
          }.onClick(() => {
            router.pushUrl(
              {
                url: 'pages/Record',
              },
              err => {
                if (err) {
                  console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
                }
              }
            )
          })

          Column() {
            Image($r('app.media.service')).width(45)
            Text('客服中心')
          }
          .onClick(() => {
            router.pushUrl(
              {
                url: 'pages/Service',
              },
              err => {
                if (err) {
                  console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
                }
              }
            )
          })
        }
        .height(100)
        .justifyContent(FlexAlign.SpaceAround)
        .userPageSty()

        Flex({ wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceAround }) {
          Column({space: 4}) {
            Image($r('app.media.logo')).width(30)
            Text('个人信息')
          }.width('25%').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/UserInfo',
              },
              err => {
                if (err) {
                  console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
                }
              }
            )
          })

          Column({space: 4}) {
            Image($r('app.media.logo')).width(30)
            Text('我的爱车')
          }.width('25%').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/MyCar',
              },
              err => {
                if (err) {
                  console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
                }
              }
            )
          })

          Column({space: 4}) {
            Image($r('app.media.logo')).width(30)
            Text('车位查看')
          }.width('25%').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/ParkSpace',
              },
              err => {
                if (err) {
                  console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
                }
              }
            )
          })

          ForEach(this.items, (item: panelData) => {
            Column({ space: 4 }) {
              Image(item.image).width(30)
              Text(item.name)
            }.width('25%')
          })

        }
        .height(150)
        .width('95%')
        .padding(10)
        .borderRadius(10)
        .backgroundColor('#FFF')

        Row() {
          Text('退出登录')
          Image($r('app.media.logo')).width(20).fillColor(Color.Black)
        }
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
        .userPageSty()
        .onClick(async () => {
          try {
            await cloud.auth().signOut()
            hilog.info(0, '退出登录成功', 'success')
            router.replaceUrl({
              url: 'pages/Login'
            })
          } catch (e) {
            hilog.error(0, '退出登录失败', JSON.stringify(e))
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EFEFEF')
  }
}

class panelData {
  name: string
  image: ResourceStr

  constructor(name: string, image: ResourceStr) {
    this.name = name
    this.image = image
  }
}