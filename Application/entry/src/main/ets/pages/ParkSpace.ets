// @ts-nocheck
import { Header } from '../components/CommonComponent'
import cloud from '@hw-agconnect/cloud'
import schema_lot from '../../resources/rawfile/schema_lot.json'
import schema_in from '../../resources/rawfile/schema_in.json'
import schema_out from '../../resources/rawfile/schema_out.json'
import { t_lot } from '../model/t_lot'
import { t_in } from '../model/t_in'
import { t_out } from '../model/t_out'

@Entry
@Component
struct ParkSpace {
  @State lotList: t_lot[] = []
  @State dataLoaded: boolean = false

  async aboutToAppear() {
    const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_lot })
    this.lotList = await database.collection(t_lot).query().orderByAsc('id').get()
    const inList = await cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_in }).collection(t_in).query().get()
    const outList = await cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_out }).collection(t_out).query().get()
    this.lotList[0].setCapacity(this.lotList[0].getCapacity() - inList.length + outList.length)
    this.dataLoaded = true
  }

  build() {
    Column() {
      Header({ title: '车位查看' })
      if (this.dataLoaded) {
        Row() {
          Text('停车场').width('33%').fontSize(25).fontWeight(FontWeight.Bold)
          Text('费用').width('33%').fontSize(25).fontWeight(FontWeight.Bold)
          Text('剩余容量').width('33%').fontSize(25).fontWeight(FontWeight.Bold)
        }.margin({ bottom: 10, top: 30 })

        List({ space: 10 }) {
          ForEach(
            this.lotList,
            (item: t_lot) => {
              ListItem() {
                Row() {
                  Text(item.getName()).width('33%').fontSize(20)
                  Text(item.getFee().toString()).width('33%').fontSize(20)
                  Text(item.getCapacity().toString()).width('33%').fontSize(20)
                }.margin({ top: 10 })
              }
            }
          )
        }
        .layoutWeight(1)
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Auto)
      }
    }
    .width('100%')
  }
}