import router from '@ohos.router';

@Component
export struct Header {
  private title: ResourceStr

  build() {
    Row() {
      Image($r('app.media.back'))
        .width(30)
        .margin({ left: 20 })
        .onClick(() => {
          router.back()
        })


      Text(this.title)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10, left: '33%', top: 10 })
    }
    .width('100%')
  }
}