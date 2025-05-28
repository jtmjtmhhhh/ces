@Entry
@Component
struct ZuJia {
  aboutToAppear(): void {
  }
  build() {
    Column({space:100}){
      Text()
        .fontColor(Color.Pink)
      TextInput()

      Row(){
        Button()
          .type(ButtonType.Normal)
      }
      .borderRadius({})
      .border({})
      .alignItems(VerticalAlign.Top)
    }
    .padding({})
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
    .translate({})

  }
}
export default ZuJia