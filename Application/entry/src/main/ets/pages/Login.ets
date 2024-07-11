import router from '@ohos.router'
import Prompt from '@system.prompt'
import cloud from '@hw-agconnect/cloud'
import { VerifyCodeAction } from '@hw-agconnect/auth-ohos'
import hilog from '@ohos.hilog'

@Component
export struct Login {
  @State countdown: number = 60
  @State phoneNumber: string = ''
  @State verifyCode: string = ''
  intervalId: number = 0
  @State verifyCodeButtonTest: string = '获取验证码'
  @State verifyCodeButtonEnable: boolean = true

  async aboutToAppear() {
    try {
      const user = await cloud.auth().getCurrentUser()
      if (user) {
        AppStorage.SetOrCreate('user', user)
        router.replaceUrl({
          url: 'pages/Index'
        })
      }
    } catch (e) {
      hilog.error(0, 'aboutToAppear', JSON.stringify(e))
    }
  }

  build() {
    Column({ space: 15 }) {
      Image($r('app.media.logo')).width('100vp').borderRadius(50).margin({ top: 120 })
      Text('欢迎登录智能停车平台').fontColor(Color.Gray).fontSize(20)

      Divider().margin({ top: 10, bottom: 30 })

      TextInput({
        placeholder: '请输入手机号'
      }).width('90%').type(InputType.Number).maxLength(11)
        .onChange((val: string) => {
          this.phoneNumber = val
        })

      Row({space: 10}) {
        TextInput({
          placeholder: '请输入验证码'
        }).width('65%').type(InputType.Number).maxLength(6)
          .onChange((val: string) => this.verifyCode = val)
        Button(this.verifyCodeButtonTest).width('32%').backgroundColor('#0aa671').enabled(this.verifyCodeButtonEnable)
          .onClick(async () => {
          if (this.phoneNumber.length !==  11) {
            Prompt.showToast({ message: '请输入正确的手机号' })
            return
          }
            //倒计时
          this.verifyCodeButtonEnable = false
          this.verifyCodeButtonTest = `${this.countdown} s`
          this.countdown--
          this.intervalId = setInterval(() => {
            this.verifyCodeButtonTest = `${this.countdown} s`
            if (this.countdown <= 0) {
              clearInterval(this.intervalId)
              this.countdown = 60
              this.intervalId = 0
              this.verifyCodeButtonTest = '获取验证码'
              this.verifyCodeButtonEnable = true
              return
            }
            this.countdown--
          }, 1000)

            try{
              await cloud.auth().requestVerifyCode({
                verifyCodeType:{kind: 'phone', phoneNumber: this.phoneNumber, countryCode: '86'},
                action: VerifyCodeAction.REGISTER_LOGIN,
                lang: 'zh-cn'})
              hilog.info(0, 'requestVerifyCode', 'success')
            } catch (e) {
              AlertDialog.show({title: '错误', message: '验证码发送失败'})
              hilog.error(0, 'requestVerifyCode', JSON.stringify(e))
            }

        })
      }.width('90%').margin({ top: 10 })

      Button('登录').width("90%").backgroundColor('#0aa671').margin({ top: 20 })
        .onClick(async () => {
          if (this.phoneNumber.length !==  11 || this.verifyCode.length !== 6) {
            Prompt.showToast({ message: '请输入正确的手机号和验证码' })
            return
          }
        try {
          const result = await cloud.auth().signIn({
            credentialInfo: {kind: 'phone', phoneNumber: this.phoneNumber, countryCode: '86', verifyCode: this.verifyCode}
          })
          const user = result.getUser()
          AppStorage.SetOrCreate('user', user)
          hilog.info(0, 'signIn', 'success')
          router.replaceUrl({
            url: 'pages/Index'
          })
        } catch (e) {
          AlertDialog.show({title: '错误', message: '登录失败'})
          hilog.error(0, 'signIn', JSON.stringify(e))
        }

      })

      LoadingProgress()
        .color('#0aa671').width(50).height(50).margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
  }
}