import router from '@ohos.router'

@Entry
@Component
struct Register {
  @State name: string = '' //企业名称
  @State domain: string = '' //网站
  @State adminUsername: string = '' //用户名
  @State adminPassword: string = '' //密码
  @State validCode: string = '' //验证码

  build() {
    Column({ space: 15 }) {
      Image($r('app.media.logo')).width('100vp').borderRadius(50).margin({ top: 120 })
      Text('欢迎注册智能停车平台').fontColor(Color.Gray).fontSize(20)
      TextInput({
        placeholder: '请输入用户名'
      }).width(300)
        .onChange((val: string) => {
          this.adminUsername = val
        })
      Row() {
        TextInput({ placeholder: '验证码:666666' }).width(150).onChange((val: string) => this.validCode = val)
        Button('获取验证码').backgroundColor('#0aa671')
      }.justifyContent(FlexAlign.SpaceBetween).width(300)

      TextInput({
        placeholder: '密码:长度至少5位'
      }).width(300).onChange((val: string) => this.adminPassword = val).type(InputType.Password)
      TextInput({
        placeholder: '公司名称'
      }).width(300)
        .onChange((val: string) => {
          this.name = val
        })
      TextInput({
        placeholder: '公司网站,如www.example.com'
      }).width(300)
        .onChange((val: string) => {
          this.domain = val
        })

      Button('立即注册').width("90%").backgroundColor('#0aa671')
        .onClick(() => {
          
        })
      Row() {
        Text('已有账户？')
        Text('去登录').fontWeight(FontWeight.Bold).fontColor('#0aa671')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login'
            })
          })
      }

      LoadingProgress()
        .color('#0aa671').width(50).height(50)
    }
    .width('100%')
    .height('100%')
  }
  //注册
  // async RegisterInfo() {
  //   let res: any = await UserModel.getRegister(this.name, this.domain, this.adminUsername, this.adminPassword, this.validCode)
  //   if (res.responseCode === 200) {
  //     let registerRes = JSON.parse(res.result.toString())
  //     if (registerRes.code == 0) {
  //       router.pushUrl({
  //         url: 'pages/Login'
  //       })
  //     }
  //   }
  // }
}