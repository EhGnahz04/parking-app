import router from '@ohos.router'
import cloud from '@hw-agconnect/cloud'

@Entry
@Component
struct AdminIndex {
  build() {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Image($r('app.media.order_manage')).width(60)
          Text('订单管理')
        }.width('50%').onClick(() => {
          router.pushUrl(
            {
              url: 'pages/AdminRecord',
            },
            err => {
              if (err) {
                console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
              }
            }
          )
        })

        Column({ space: 4 }) {
          Image($r('app.media.box')).width(60)
          Text('收件箱')
        }.width('50%').onClick(() => {
          router.pushUrl(
            {
              url: 'pages/MessageBox',
            },
            err => {
              if (err) {
                console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
              }
            }
          )
        })
      }

      Row() {
        Column({ space: 4 }) {
          Image($r('app.media.my_car')).width(60)
          Text('停车场管理')
        }.width('50%').onClick(() => {
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

        Column({ space: 4 }) {
          Image($r('app.media.screen')).width(60)
          Text('智慧大屏')
        }.width('50%').onClick(() => {
          router.pushUrl(
            {
              url: 'pages/SmartScreen',
            },
            err => {
              if (err) {
                console.log(`路由失败，errCode:${err.code},errMsg:${err.message}`)
              }
            }
          )
        })

      }.margin({ top: 20 })

      Row() {
        Text('退出登录').fontSize(20)
      }
      .height(60)
      .justifyContent(FlexAlign.Center)
      .width('95%')
      .margin({ top: 30 })
      .onClick(async () => {
        try {
          await cloud.auth().signOut()
          router.replaceUrl({
            url: 'pages/Login'
          })
        } catch (e) {
          console.error(e)
        }
      })
    }.height('100%').justifyContent(FlexAlign.Center)
  }
}