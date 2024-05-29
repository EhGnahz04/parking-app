import cloud, {AuthUser} from '@hw-agconnect/cloud'
import {Header} from '../components/CommonComponent'
import hilog from '@ohos.hilog'
import picker from '@ohos.file.picker'
import router from '@ohos.router'
import Prompt from '@system.prompt'

@Entry
@Component
struct UserInfo {

  @State photoUrl: string = ''
  @State displayName: string = ''
  @StorageLink('user') user: AuthUser = null

  aboutToAppear(){
    this.photoUrl = this.user.getPhotoUrl()
    this.displayName = this.user.getDisplayName()
  }

  build() {
    Column() {
      Header({ title: '个人信息' })

      Image(this.photoUrl?this.photoUrl:$r('app.media.logo')).width(70).height(70)
        .onClick(async () => {
          try{
            const options = new picker.PhotoSelectOptions()
            options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
            options.maxSelectNumber = 1
            const result = await new picker.PhotoViewPicker().select(options)

            await cloud.storage().upload({
              localPath: result.photoUris[0],
              cloudPath: `user/Image/${this.user.getUid()}.jpg`
            })

            const url = await cloud.storage().getDownloadURL(`user/Image/${this.user.getUid()}.jpg`)
            this.photoUrl = `${url}&ts=${new Date().getTime()}`
            hilog.info(0, 'select photo', 'success')

          } catch (e) {
            hilog.error(0, 'select photo', JSON.stringify(e))
          }

        })

      TextInput({placeholder: '请输入昵称', text: this.displayName}).width('80%').onChange((text) => {
        this.displayName = text
      })

      Row() {
        Button('取消')
          .onClick(() => {
            router.back()
          })
        Button('保存')
          .onClick(async () => {
            try {
              await this.user.updateProfile({
                displayName: this.displayName,
                photoUrl: this.photoUrl
              })
              Prompt.showToast({ message: '保存成功' })
              hilog.info(0, 'updateProfile', 'success')
            } catch (e) {
              hilog.error(0, 'updateProfile', JSON.stringify(e))
            }
          })
        }.padding(10).width('90%').justifyContent(FlexAlign.SpaceEvenly)
      }
    }
}