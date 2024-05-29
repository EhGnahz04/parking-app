@Component
export struct ProvinceKeyboard {
  provinces: string[] = ['京', '津', '冀', '晋', '蒙', '辽', '吉', '黑', '沪', '苏', '浙', '皖', '闽', '赣', '鲁', '豫', '鄂', '湘', '粤', '桂', '琼', '渝', '川', '贵', '云', '藏', '陕', '甘', '青', '宁', '新']
  @Link province: string

  @Styles keyBoxStyle(){
    .backgroundColor(Color.White)
    .borderRadius(8)
    .height(60)
  }

  build() {
    Grid() {
      ForEach(this.provinces, province => {
        GridItem() {
          Text(province).fontSize(20).fontWeight(900)
        }
        .keyBoxStyle()
        .onClick(() => this.clickProvince(province))
      })
      GridItem() {
        Image($r('app.media.delete')).width(25)
      }
      .keyBoxStyle()
      .onClick(() => this.clickDelete())
    }
    .width('100%')
    .height(280)
    .backgroundColor('#F6F7Fb')
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .padding(8)
    .margin({ top: 10 })
  }

  clickProvince(province: string) {
    this.province += province
  }

  clickDelete() {
    this.province = this.province.substring(0, this.province.length - 1)
  }
}

@Component
export struct Keyboard {
  keys: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '港', '澳', '学']
  @Link license: string

  @Styles keyBoxStyle(){
    .backgroundColor(Color.White)
    .borderRadius(8)
    .height(60)
  }

  build() {
    Grid() {
      ForEach(this.keys, key => {
        GridItem() {
          Text(key).fontSize(20).fontWeight(900)
        }
        .keyBoxStyle()
        .onClick(() => this.clickKey(key))
      })
      GridItem() {
        Image($r('app.media.delete')).width(25)
      }
      .keyBoxStyle()
      .onClick(() => this.clickDelete())
    }
    .width('100%')
    .height(280)
    .backgroundColor('#F6F7Fb')
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .padding(8)
    .margin({ top: 10 })
  }

  clickKey(key: string) {
    if (this.license.length > 7) {
      return
    }
    this.license += key
  }

  clickDelete() {
    this.license = this.license.substring(0, this.license.length - 1)
  }
}