import { WeChat_CurrentUserKey } from '../../../constant'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../../models/message'
import { PopupItem } from '../../../models/popup'
import { UserInfoModel,UserInfo } from '../../../models/user'

@Preview
@Component
struct Message {
  //我是谁
  @StorageProp(WeChat_CurrentUserKey)
  currentUser:UserInfoModel = new UserInfoModel({}as UserInfo)  //  "我"
  //当前消息的对象的内容
  // @Require
  @Prop
  currentMessage:MessageInfoModel = new MessageInfoModel({} as MessageInfo)

  //判断是不是我发的消息
  @State
  isOwnMessage:boolean = this.currentUser.user_id === this.currentMessage?.sendUser?.user_id

  //控制弹层的显示
  @State
  showPopup:boolean = false


  //定义一个删除信息的方法
  delMessage:(messId:string)=>void = ()=>{}

  @State
  popupList: PopupItem[] = [{
    title: '听筒播放',
    icon: $r("app.media.ic_public_ears"),
    itemClick:()=>{
    }
  },
    {
      title: '收藏',
      icon: $r("app.media.ic_public_cube")
    }, {
      title: '转文字',
      icon: $r("app.media.ic_public_trans_text")
    }, {
      title: '删除',
      icon: $r("app.media.ic_public_cancel"),
      itemClick:()=>{
        this.delMessage(this.currentMessage.id)
      }
    }, {
      title: '多选',
      icon: $r("app.media.ic_public_multi_select")
    }, {
      title: '引用',
      icon: $r("app.media.ic_public_link")
    }, {
      title: '提醒',
      icon: $r("app.media.ic_public_warin")
    }]
  //用来显示弹层
  @Builder
  getContent(){
    GridRow({columns:5}){
      ForEach(this.popupList,(item:PopupItem)=>{
        GridCol(){
          Column({space:6}){
            Image(item.icon)
              .fillColor($r('app.color.white'))
              .width(18)
              .height(18)
            Text(item.title)
              .fontColor($r('app.color.white'))
              .fontSize(14)
          }
          .height(60)
        }
        .onClick(()=>{
          item.itemClick && item.itemClick() //如果点击事件存在就触发
        })
      })
    }
    .padding({
      top:15,
      left:10
    })
    .width(300)
  }
  //获取语音条的宽度
  getAudioWitch(){
    //最短时常
    //最长
    let minWidth:number = 20
    let maxWidth:number = 90
    let calcWidth = minWidth + 100 * this.currentMessage.sourceDuration / 60
    if (calcWidth > maxWidth) {return maxWidth+"%"}
    return calcWidth+"%"
  }
  //实现多个builder
  @Builder  //文本消息的Builder
  getTextContent(){
    Text(this.currentMessage.messageContent)
      .backgroundColor(this.isOwnMessage ? $r('app.color.second_primary') : $r('app.color.white'))
      .fontColor($r('app.color.text_primary'))
      .padding(10)
      .margin({
        left:10,
        right:10
      })
      .borderRadius(4)
  }
  //语音消息的Builder
  @Builder
  getAudioContent(){
    Row({space:5}){
      Text(`${this.currentMessage.sourceDuration}’`)
      Image($r('app.media.ic_public_recorder'))
        .width(20)
        .height(20)
        //喇叭应该是要朝向对面的，所以我们这里如果是我发的那么就旋转180度如果是它发的那么就不用动
        .rotate({
          angle:this.isOwnMessage ? 180:0
        })
    }
    .width(this.getAudioWitch())
      .backgroundColor(this.isOwnMessage ? $r('app.color.chat_primary') : $r('app.color.white'))
      .padding(10)
      .margin({
        left:10,
        right:10
      })
    //判断对齐方式
    .justifyContent(this.isOwnMessage ? FlexAlign.End : FlexAlign.Start)
    //排列方向根据是谁发的决定朝向
    .direction(this.isOwnMessage ? Direction.Ltr : Direction.Rtl)
      .borderRadius(4)
  }
  build() {
    Row(){
      Image(this.currentMessage.sendUser.avatar)
        .width(40)
        .aspectRatio(1)
        .borderRadius(4)
      Row(){
        Column(){
          if (this.currentMessage.messageType === MessageTypeEnum.TEXT){
            //当它为文本消息的时候那么我们就渲染文本消息
            this.getTextContent()
          }
          if (this.currentMessage.messageType === MessageTypeEnum.AUDIO){
            //渲染语音消息
            this.getAudioContent()
          }
        }
        .bindPopup(this.showPopup,{
          builder:this.getContent,
          popupColor:$r('app.color.popup_back'),
          backgroundBlurStyle:BlurStyle.NONE,//把失去焦点的模式去掉，否则颜色不保持
          onStateChange:(event)=>{
            //当鼠标移动到其它位置 关闭状态
            this.showPopup = event.isVisible
          }
        })

      }
      .gesture(
        LongPressGesture()//长按事件
          .onAction(()=>{//触发的时候
            this.showPopup = true
          })
      )//进行手势的监听

      .justifyContent(this.isOwnMessage ? FlexAlign.End :FlexAlign.Start)
      .layoutWeight(6)
      Text()
        .layoutWeight(1)
    }
    .direction(this.isOwnMessage ? Direction.Rtl : Direction.Ltr)
    .padding({
      left:20,
      right:20
    })
  }
}

export default Message