import router from '@ohos.router';
@Entry
@Component
struct Login {
  @State message: string = 'Hello World';

  build() {

    Column(){
      Column(){
        Image($r('app.media.foreground')).width(120).height(120)
        Text('随信').fontSize(18)
          .fontColor('#ff287c9f')
          .fontWeight(500)


      }.height(150).justifyContent(FlexAlign.SpaceBetween)


      Column(){
        Row(){
          Image($r("app.media.user_name")).width(30).height(30)
          TextInput({placeholder:'请输入用户名'}).width('88%')
        }.width('95%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row(){
          Image($r("app.media.pwd")).width(30).height(30)
          TextInput({placeholder:'请输入密码'}).width('88%')
            .type(InputType.Password)
        }.width('95%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row(){
          Text('忘记密码').fontSize(13)
            .onClick(()=>{
              router.pushUrl({url:"pages/chongzhimima"})
            })
          Text("立即注册").fontSize(13)
            .onClick(()=>{
              router.pushUrl({url:"pages/zhuce"})
            })
        }.width('95%')
        .justifyContent(FlexAlign.SpaceBetween)

        Button('登录')
          .onClick(()=>{
            router.pushUrl({url:"pages/Index"})
          }).width('95%')
          .height(40)

      }.height(190).justifyContent(FlexAlign.SpaceBetween)

    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(HorizontalAlign.Center)}

}
