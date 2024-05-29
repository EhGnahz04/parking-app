import {Header} from '../components/CommonComponent'

@Entry
@Component
struct UserInfo {

  build() {
    Column() {
      Header({ title: '用户信息' })
      Text('用户信息')
    }

  }
}