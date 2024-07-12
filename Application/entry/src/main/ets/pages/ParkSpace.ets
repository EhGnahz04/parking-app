// @ts-nocheck
import { Header } from '../components/CommonComponent'
import cloud from '@hw-agconnect/cloud'
import schema_lot from '../../resources/rawfile/schema_lot.json'
import { t_lot } from '../model/t_lot'

@Entry
@Component
struct ParkSpace {
  @State lotList: t_lot[] = []

  async aboutToAppear() {
    const database = cloud.database({ zoneName: 'Demo', objectTypeInfo: schema_lot })
    this.lotList = await database.collection(t_lot).query().get()
  }

  build() {
    Column() {
      Header({title: '车位查看'})

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
    .width('100%')
  }
}