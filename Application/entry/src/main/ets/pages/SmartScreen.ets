@Entry
@Component
struct SmartScreen {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Image($r('app.media.smartScreen')) // 替换为您的图片文件路径
          .width('100%')
          .height('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}