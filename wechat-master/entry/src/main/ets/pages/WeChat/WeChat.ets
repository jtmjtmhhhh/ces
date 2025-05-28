import { MessageInfoModel } from '../../models/message'
import { WeChatStore } from '../../utils/chat_stotere'
import { router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'
import { Record_Update_EventName } from '../../constant'

@Component
struct WeChat {
  @State
  list:MessageInfoModel[] = []
  aboutToAppear(): void {
    this.getAllRecord()
  }
  async  getAllRecord(){
    this.list =  await WeChatStore.getAllLastRecord()

    emitter.on(Record_Update_EventName, async ()=>{
      this.list =  await WeChatStore.getAllLastRecord()
    })
  }

  //将时间戳转化成具体时间 如果是当天的话,是要显示时分的,如果不是当天的话 显示日期
  transTime(timStamp:number){
    const sendTime =  new Date(timStamp)
    if (sendTime.getDate() === new Date().getDate()) {
      //等于今天  显示时和分
      return sendTime.getHours().toString().padStart(2,'0') + ':' + sendTime.getHours().toString().padStart(2,'0')
    }else {
      //显示月和日'
      return (sendTime.getMonth() + 1).toString().padStart(2,'0') + '月' + sendTime.getDate().toString().padStart(2,'0') + "日"
    }
  }
  @Builder
  getLstEnd(userId:string){
    Row(){
      Text("删除")
        .fontColor($r('app.color.white'))
        .width(100)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          //删除内存
          if (userId) {
            //通过所有的user_id和传进来的userId对比找出归属者
            let index = this.list.findIndex(item => item.connectUser.user_id === userId )
            //当索引大于-1就把它删除掉
            if (index >-1) {
              this.list.splice(index,1)
            }
            //缓存直接就再这里删除了
            WeChatStore.delWeChatMessage(userId)//删除缓存
          }
          //删除缓存
        })
    }
    .height(60)
    .padding({left:20,right:20})
    .backgroundColor($r('app.color.danger'))
  }

  build() {
    Column(){
      Row(){
        Text('随信')
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(50)
      List({space:10}){
        ForEach(this.list,(item:MessageInfoModel)=>{
          ListItem(){
            Row({space:10}){
              Image(item.connectUser.avatar)//头像
                .width(50)
                .height(50)
                .borderRadius(4)
              Column(){
                Text(item.connectUser.username)
                  .fontColor($r('app.color.text_primary'))
                //因为字体大小默认是16所以上面的就不用给了
                Text(item.messageContent)
                  .fontColor($r('app.color.text_second'))
                  .fontSize(14)//字体大小设置成14
              }

              .height(50)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top:4,
                bottom:4
              })
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              //时间
              Text(this.transTime(item.sendTime))
                .fontColor($r('app.color.text_second'))
                .fontSize(14)
                .width(60)

            }
            .padding({
              left:10,
              right:10
            })
            .width('100%')
          }

          .width('100%')
          .onClick(()=>{
            router.pushUrl({
              url:'pages/ChatDetail/ChatDetail',
              params:item.connectUser
            })
          })
          .swipeAction({
            end:{
              builder:this.getLstEnd(item.connectUser.user_id)
            }
          })
        })
      }
      .divider({
        strokeWidth:1,
        color:$r('app.color.back_color')
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}
export default WeChat