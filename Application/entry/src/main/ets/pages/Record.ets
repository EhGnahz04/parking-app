import dayjs from 'dayjs'
import { Header } from '../components/CommonComponent'

class cord {
  date: Date
  license: string
  fee: number
  status: number

  constructor(date: Date, license: string, fee: number, status: number = 0) {
    this.date = date
    this.license = license
    this.fee = fee
    this.status = status
  }
}

@Builder function CordCard(cord: cord) {
  Column() {
    Row() {
      Column() {
         if (cord.status == 1) {
           Text(dayjs(cord.date).format('YYYY-MM-DD HH:mm:ss'))
             .fontColor('#CCC')
             .decoration({ type: TextDecorationType.LineThrough })
         } else {
           Text(dayjs(cord.date).format('YYYY-MM-DD HH:mm:ss'))
         }
      }
      .width(200)

      Column() {
        if (cord.status == 1) {
          Text(cord.license)
            .fontColor('#CCC')
            .decoration({ type: TextDecorationType.LineThrough })
        } else {
          Text(cord.license)
        }
      }
      .width(100)

      Column() {
        if (cord.status == 1) {
          Text(cord.fee.toString())
            .fontColor('#CCC')
            .decoration({ type: TextDecorationType.LineThrough })
        } else {
          Text(cord.fee.toString())
        }

      }
      .width(50)
    }
    .height(50)
    .width('100%')
  }
}


@Entry
@Component
struct record {
  private cords: cord[] = [
    new cord(new Date(2021, 1, 1), "京ABC123", 1),
    new cord(new Date(2021, 1, 2), "京ABC123", 2),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30, 1),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30),
    new cord(new Date(2021, 1, 3), "京ABC1234", 30)
  ]

  build() {
    Column({ space: 8 }) {
      Header({ title: '缴费记录' })
        .margin({ top: 10 })

      List({ space: 10 }) {
        ForEach(
          this.cords,
          (cord: cord) => {
            ListItem() {
              CordCard(cord)
            }
          })
      }
      .width('100%')
      .layoutWeight(1)

    }
    .width('100%')
    .backgroundColor('#EFEFEF')

  }
}