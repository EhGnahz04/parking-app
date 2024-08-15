@Entry
@Component
struct WebComponent {
  controller: WebController = new WebController();

  build() {

    Column() {
      Web({
        src: 'https://1b679589e5f24baeb68cc1f324ea9011.canvas.cn-north-4.hwastro.cn/magno/render/share/190a6486469-56817ded-c844-489b-b542-7791c06adad4',
        controller: this.controller
      })
    }

  }
}