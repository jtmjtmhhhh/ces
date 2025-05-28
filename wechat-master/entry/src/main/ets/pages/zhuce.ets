import router from '@ohos.router';
@Entry
@Component
struct Zhece {
  build() {
    Column() {
      // Header bar
      Row() {
        Image($r("app.media.back_white")).flexBasis(30)
        Row() {
          Text("用户注册").fontSize(20)
            .fontWeight(700).fontColor("#FFF")
        }.margin({right:30}).flexGrow(1)
        .justifyContent(FlexAlign.Center)
      }.width("95%").margin({top:10,bottom:10})
      Divider()
      Column() {
        Row() {
          Image($r("app.media.add")).width(30).height(30)
          TextInput({placeholder:"请输入手机号"}).width("88%").backgroundColor("#FFF")
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }

      Column() {
        Row() {
          Image($r("app.media.email")).width(30).height(30)
          TextInput({placeholder:"请输入邮箱"}).width("88%").backgroundColor("#FFF")
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.pwd")).width(30).height(30)
          TextInput({placeholder:"请输入新密码"}).width("88%").backgroundColor("#FFF")
            .type(InputType.Password)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.confirm")).width(30).height(30)
          TextInput({placeholder:"请输入确认密码"}).width("88%").backgroundColor("#FFF")
            .type(InputType.Password)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.send")).width(30).height(30)
          Row() {
            TextInput({placeholder:"请输入验证码"}).width("70%").backgroundColor("#FFF")
            Text("获取验证码").flexBasis(80)
          }.justifyContent(FlexAlign.SpaceBetween).width("88%")
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Checkbox()
          Text("请勾选同意").fontColor("#7FC7E4")
          Text("《用户使用协议》")
        }
      }.flexGrow(1).justifyContent(FlexAlign.End).margin({bottom:10})
      Row() {
        Button("注册")
          .onClick(()=>{
          })
          .width("45%")
        Button("返回登录")
          .onClick(()=>{
            router.pushUrl({ url: "pages/Login" })
          })
          .width("45%")
      }.justifyContent(FlexAlign.SpaceBetween).width("95%")
      Image($r("app.media.back_white")).flexBasis(30).onClick(()=>{
        router.back()})
    }.height(240).justifyContent(FlexAlign.SpaceBetween)
  }
}
