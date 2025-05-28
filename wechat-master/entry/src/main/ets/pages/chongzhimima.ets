import router from '@ohos.router';

@Entry
@Component
struct Chongzhimima {
  private emailOrPhone: string = '';
  private verificationCode: string = '';
  private newPassword: string = '';
  private confirmPassword: string = '';

  build() {
    Column() {
      // Header bar with back button
      Row() {
        Image($r("app.media.back_white")).flexBasis(30).onClick(() => {
          router.back()
        })
        Row() {
          Text("忘记密码").fontSize(20)
            .fontWeight(700).fontColor("#FFF")
        }.margin({right: 30}).flexGrow(1)
        .justifyContent(FlexAlign.Center)
      }.width("95%").margin({top: 10, bottom: 10})
      Divider().backgroundColor("#007DFF").margin({bottom: 10})
      Column() {
        Row() {
          Image($r("app.media.email")).width(30).height(30)
          TextInput({placeholder: "请输入邮箱或手机号"})
            .width("88%").backgroundColor("#FFF")
            .onChange((value) => this.emailOrPhone = value)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Button("获取验证码").width("95%").onClick(() => {
            // Logic to send verification code
          })
        }.justifyContent(FlexAlign.Center).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.send")).width(30).height(30)
          TextInput({placeholder: "请输入验证码"})
            .width("88%").backgroundColor("#FFF")
            .onChange((value) => this.verificationCode = value)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.pwd")).width(30).height(30)
          TextInput({placeholder: "请输入新密码"})
            .width("88%").backgroundColor("#FFF")
            .onChange((value) => this.newPassword = value)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Image($r("app.media.confirm")).width(30).height(30)
          TextInput({placeholder: "请再次输入新密码"})
            .width("88%").backgroundColor("#FFF")
            .onChange((value) => this.confirmPassword = value)
        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
        Divider().margin(5)
      }
      Column() {
        Row() {
          Button("重置密码").width("45%").onClick(() => {
            router.pushUrl({url:"pages/chenggong"})
          })
          Button("返回登录")
            .onClick(()=>{
              router.pushUrl({ url: "pages/Login" })
            })
            .width("45%")
        }.justifyContent(FlexAlign.Center).width("95%")
      }
    }.height(240).justifyContent(FlexAlign.SpaceBetween).backgroundColor("#F0F0F0").padding(10)
  }
}
