import router from '@ohos.router'

@Entry
@Component
struct AdminIndex {
  build() {
    Row() {
      Column({space: 4}) {
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

      Column({space: 4}) {
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
    .height('100%')
  }
}