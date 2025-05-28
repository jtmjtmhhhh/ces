import { promptAction, router } from '@kit.ArkUI'
import { UserInfoModel } from '../../models/user'
import { WeChatStore } from '../../utils/chat_stotere'

@Component
struct Connect {
  @State
  userList:UserInfoModel[] = [] //联系人数组

  @State
  filterList:UserInfoModel[] = [] //筛选之后的数组

  @State
  @Watch("updateFilterList")
  searchName:string = ''  //用来搜索字段的
  aboutToAppear(): void {
    this.getUserList()
  }
  getUserList(){
    this.userList = WeChatStore.getWeChatConnect()
    this.updateFilterList()
  }
  updateFilterList(){
    if (this.searchName) {
      //搜索
      this.filterList = this.userList.filter(item => item.username.includes(this.searchName))
      return
    } else {
      // this.filterList = this.userList //地址引用方式
      this.filterList = [...this.userList]//拷贝方法 ，用延展运算符
    }
  }
  build() {
    Column(){
      Row(){
        Search({placeholder:'搜索',value:$$this.searchName})
          .height(30)
          .borderRadius(4)
          .backgroundColor($r('app.color.white'))
      }
      .width('100%')
      .padding({
        left:10,
        right:10
      })
      List(){
        ForEach(this.filterList,(item:UserInfoModel)=>{
          ListItem(){
            Row({space:10}){
              Image(item.avatar)
                .width(30)
                .height(30)
                .borderRadius(4)
              Text(item.username)
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(60)
            .padding({
              left:10,
              right:10
            })
          }
          .onClick(()=>{
            router.pushUrl({
              url:"pages/ChatDetail/ChatDetail",
              params:item
            })
          })
          .stateStyles({
            pressed:{ //按压态
              .backgroundColor($r('app.color.back_color'))
            },normal:{  //正常态
              .backgroundColor($r('app.color.white'))
          }
          })
        })
      }

      .divider({
        strokeWidth:1,
        color:$r('app.color.back_color')
      })
      .backgroundColor($r('app.color.white'))
      .layoutWeight(1)
    }
    .backgroundColor($r('app.color.back_color'))
    .width('100%')
    .height('100%')
  }
}

export default Connect