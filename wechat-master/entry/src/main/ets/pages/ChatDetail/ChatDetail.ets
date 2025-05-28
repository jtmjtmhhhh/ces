import { router } from '@kit.ArkUI';
import { WeChat_CurrentUserKey } from '../../constant';
import { MessageInfo, MessageInfoModel } from '../../models/message';
import { UserInfo } from '../../models/user';
import { UserInfoModel } from '../../models/user';
import { AudioRenderer } from '../../utils/audio_recorder';
import { WeChatStore } from '../../utils/chat_stotere';
import { getRequestMessage } from '../../utils/request';
import BottomInput from './Components/BottomInput';
import Message from './Components/Message';

@Entry
@Component
struct ChatDetail {
  @State message: string = 'Hello World';

  @StorageProp(WeChat_CurrentUserKey)
  currentUser:UserInfoModel = new UserInfoModel({}as UserInfo)  //  "我"

  @Provide
  talkUser:UserInfoModel= new UserInfoModel({}as UserInfo)  //  "和我聊天的对象"

  @State
  messList:MessageInfoModel[] = []

  @State
  talkUserInputIng:boolean = false //对方正在输入

  //控制消息的滚动条
  scroller:Scroller = new Scroller()

  aboutToAppear(): void {
    //获取和我对话的用户的信息
    this.getTalkUser()
    AudioRenderer.init() //初始化音频渲染

  }
  aboutToDisappear(): void {
    this.releaseAudio()
  }
  async  releaseAudio(){
    await AudioRenderer.stop()  //先暂停
    AudioRenderer.release() //然后释放
  }
  getAllRecord(){
    //调用获取全部信息的方法，将全部信息赋值到消息列表
    this.messList = WeChatStore.getWechatMessage(this.talkUser.user_id)
    //将消息滚动到底部
    this.scroller.scrollEdge(Edge.End)
  }
  //获取和我对话的用户的信息
  getTalkUser(){
    this.talkUser = router.getParams() as UserInfoModel
    this.getAllRecord()
  }
  //发送文本消息
  sendTextMessage(content:string){
    //新建消息
    let mess = new MessageInfoModel({
      messageContent:content, //消息内容
      sendUser:this.currentUser,//我
      connectUser:this.talkUser //我给谁发消息的那个对象
    }as MessageInfo)

    this.messList.push(mess)//追加消息到列表
    //添加消息到和我聊天的对象的聊天记录中去
    WeChatStore.addOneWechatMessage(this.talkUser.user_id,mess)

    this.scroller.scrollEdge(Edge.End)//将滚动条滚动到底部

    //我们发送完消息之后1秒钟之后再向服务器进行发送
    setTimeout(()=>{
      //发送消息到服务器，得到响应内容
      this.getResponseMessage(content)
    },1000)
  }
  //获取响应的消息
  async  getResponseMessage(content:string){
    this.talkUserInputIng = true //设置为对方正在输入
    const result =  await getRequestMessage(content)
    const mess = new MessageInfoModel({
      messageContent:result.content, //消息内容
      sendUser:this.talkUser,//发送消息的那个人
      connectUser:this.talkUser //我给谁发消息的那个对象
    }as MessageInfo)
    this.messList.push(mess)
    //添加消息到和我聊天的对象的聊天记录中去
    WeChatStore.addOneWechatMessage(this.talkUser.user_id,mess)
    this.talkUserInputIng = false
    this.scroller.scrollEdge(Edge.End)//将滚动条滚动到底部
    //拿到消息的方法
    // result.content
  }
  //删除消息的方法
  delMessage(messId:string){
    //内存
    if (messId) {
      //如果这个id有值那么就找这个id的索引
      let index = this.messList.findIndex(item => item.id === messId)
      if (index > -1) {//如果能找到
        this.messList.splice(index,1)//删除索引，删除一个
      }

      //删除缓存
      WeChatStore.delOneWechatMessage(this.talkUser.user_id,messId)
    }
    //缓存
  }
  //自身发送语音消息的方法
  sendAudioMessage(mess:MessageInfoModel){
    this.messList.push(mess)//写入内存
    //滚动到底部
    this.scroller.scrollEdge(Edge.Bottom)
    //写入首选项
    WeChatStore.addOneWechatMessage(this.talkUser.user_id,mess) //添加聊天记录

  }
  build() {
    Column(){
      Stack({ alignContent:Alignment.Start }){

        Image($r('app.media.ic_public_arrow_left'))//返回键
          .width(30)
          .height(30)
          .zIndex(2)
          .onClick(()=>{
            router.back()
          })
        //对方的名字
        Text(this.talkUserInputIng ? "对方正在输入" : this.talkUser.username)
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.text_primary'))
      }
      .padding({
        left:10,
        right:20
      })
      .height(50)
      .width('100%')


      //中间内容
      List({space:20,scroller:this.scroller}){
        ForEach(this.messList,(item:MessageInfoModel)=>{
          ListItem(){
            Message({currentMessage:item,
              delMessage:()=>{
              this.delMessage(item.id)
              }
            })
          }
        })
      }
      .onAppear(()=>{
        //将消息滚动到底部
        this.scroller.scrollEdge(Edge.End)
      })
      .backgroundColor($r('app.color.back_color'))
      .padding({
        top:10,
        bottom:10
      })
      .layoutWeight(1)
      //底部内容
      BottomInput({
        sendTextMessage:(content:string)=>{
          this.sendTextMessage(content)
        },
        sendAudioMessage:(mess:MessageInfoModel)=>{
          this.sendAudioMessage(mess)//调用自身发送消息的方法
        }
      })
    }
    .height('100%')

    .justifyContent(FlexAlign.SpaceBetween)
  }
}