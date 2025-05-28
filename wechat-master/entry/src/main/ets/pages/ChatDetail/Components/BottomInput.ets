import { VoiceRecordEnum } from '../../../models/voice'
import VoiceInput from './Voiceinput'
import { display, promptAction } from '@kit.ArkUI'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { AudioCapturer } from '../../../utils/audio_recorder'
import { FileCommon } from '../../../utils/file_operate'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../../models/message'
import { WeChat_CurrentUserKey } from '../../../constant'
import { UserInfoModel } from '../../../models/user'
import { UserInfo } from '../../../models/user'

@Preview
@Component
struct BottomInput {
  @StorageProp(WeChat_CurrentUserKey)
  currentUser:UserInfoModel = new UserInfoModel({}as UserInfo)  //  "我"

  @Consume
  talkUser:UserInfoModel //  "和我聊天的对象"

  @State
  showVoice:boolean = false // 是否显示语音输入
  @State
  content:string = "" //输入内容


  //定义一个方法,发送文本的方法
  sendTextMessage:(content:string)=>void = ()=>{}
  //发送音频消息的方法
  sendAudioMessage:(mess:MessageInfoModel)=>void = ()=>{}
  //是否先生语音
  @State
  shouVoiceCon:boolean = false
  //当前的组件状态
  @Provide
  voiceState:VoiceRecordEnum = VoiceRecordEnum.RecordIng//默认是录制中
  //需要知道屏幕的整体的宽度
  screenWitch:number = 0 //记录整体的宽度
  screenHeight:number = 0 //记录整体的高度
  @State
  tempAudioPath:string = ""//记录一个临时变量 用来存储我的语音的临时路径

  // 计算计时器
  duration: number = 0 //音频的秒

  timer: number = -1 // 记录定时器标记

  @Builder
  getVoiceCom(){
    //Builder函数不能再跟组件直接使用自定义组件
    Column(){
      VoiceInput()
    }
  }
  aboutToAppear(): void {
    this.getScreenWitch()
    AudioCapturer.init()//初始化采集器
  }
  aboutToDisappear(): void {
    AudioCapturer.release()//释放采集器
  }
  async  getScreenWitch(){
    const result = await display.getAllDisplays()
    // AlertDialog.show({message:JSON.stringify(result)})
    if (result && result.length) {
     this.screenWitch = px2vp(result[0].width)//记录宽度
     this.screenHeight = px2vp(result[0].height)//记录高度
    }
  }







  //检查权限
  checkPermission(){
    //获取tokenID
    const result = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // AlertDialog.show({
    //   message:JSON.stringify(result)
    // })
    // result.appInfo.accessTokenId
    //创建manger
    const manger = abilityAccessCtrl.createAtManager()
      //拿到当前的状态,麦克风到底是否允许
    const status =  manger.checkAccessTokenSync(result.appInfo.accessTokenId,"ohos.permission.MICROPHONE")
    //只处理不允许的情况
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      //此时是拒绝的
      promptAction.showToast({message:"状态是拒绝"})
      //此时此刻无法录音  也无法再申请了
      //这个情况我们要打开鸿蒙系统的权限配置页面,让我们手动的打开权限
      //系统的设置页面其实就是一个ability,我们再里面需要进行传参数,打开设置页
      const context = getContext() as common.UIAbilityContext//将上下文断言成UIAbilityContext才可以启动ability
      context.startAbility({
        bundleName:'com.huawei.hmos.settings',//包名
        abilityName:'com.huawei.hmos.settings.MainAbility',//Ability名称，用于唯一标识应用中的一个Ability
        uri:'application_info_entry',//详细页面
        parameters:{
          pushParams:result.name//打开具体的应用名称
        }
      })
    }else {
      //此时是同意的
      // promptAction.showToast({message:"状态是同意"})
      this.shouVoiceCon = true//同意的逻辑显示语音组件
      //开始收集声音
      this.beginCollectVoice()
      this.startTime() //开始计时
    }
  }

  //写一个收集声音的方法
  beginCollectVoice(){
    //调用获取路径的方法，把它赋值给临时变量
    this.tempAudioPath = FileCommon.createAudioFile()//创建音频文件

    AudioCapturer.stare(this.tempAudioPath)//开始录音
  }
  //松手逻辑
  releaseFinger(){
    this.shouVoiceCon = false //关闭语音输入组件
    AudioCapturer.stop() //关闭语音输入
    this.endTime() //结束计时
    if (this.voiceState === VoiceRecordEnum.Cancel) { //当前状态为取消发送
      //取消发送，应该把巩固录制的存储声音的那个文件进行删除
      FileCommon.delFilePath(this.tempAudioPath)//调用删除文件的方法，然后把临时路径传进去
    }
    if (this.voiceState === VoiceRecordEnum.RecordIng) {//如果当前状态为发送语音
      if (this.duration < 1) {
        FileCommon.delFilePath(this.tempAudioPath)//删除文件
        promptAction.showToast({message:"录制时间过短"})
        return
      }
      //发送语音
      this.sendAudio()
    }
    if (this.voiceState === VoiceRecordEnum.Transfer) {//当前状态为转化语音文本
      //语音转文本
    }
    //不管什么状态都要回到正常的状态
    this.voiceState = VoiceRecordEnum.RecordIng
    promptAction.showToast({message:"计时"+this.duration})

  }
  //发送语音
  sendAudio(){
   let mess =  new MessageInfoModel({
      sourceDuration:this.duration, //时常
      messageContent:`[语音]${this.duration}'`,
      messageType:MessageTypeEnum.AUDIO,//消息类型是音频
      connectUser:this.talkUser,//归属者
      sendUser:this.currentUser,//发送者
      sourceFilePath:this.tempAudioPath
    }as MessageInfo )
    //调用发送音频的方法，然后把音频消息传进去
    this.sendAudioMessage(mess)
    this.duration = 0 //音频时长计时器清零
    this.tempAudioPath //临时路径清零
  }
  //开始计时
  startTime(){
    // 每一秒执行一次
    this.timer = setInterval(()=>{
      this.duration ++
    },1000)
  }
  //结束计时
  endTime(){
    clearInterval(this.timer)
  }
  build() {
    Row({space:10}){
      Image(this.showVoice ? $r('app.media.ic_public_keyboard') : $r('app.media.ic_public_sound') )
        .width(25)
        .height(25)
        .onClick(()=>{
          this.showVoice = !this.showVoice
        })
      if (this.showVoice){
       Button("按住说话")
         .type(ButtonType.Normal)
         .height(35)
         .borderRadius(2)
         .backgroundColor($r('app.color.white'))
         .layoutWeight(1)
         .fontColor($r('app.color.text_primary'))
         .gesture(
           GestureGroup(GestureMode.Parallel,
             //第一个手势
             LongPressGesture()
             .onAction(()=>{
               // this.shouVoiceCon = true
               this.checkPermission()//检查权限
             })
             .onActionEnd(()=>{ //松手
               // this.shouVoiceCon = false
               this.releaseFinger()
             }),
             //第二个手势拖动手势
             PanGesture()
               //当拖动手势进行时
               .onActionUpdate((event)=>{
                 // event.fingerList[0].globalX    //获取X坐标的方法
                 // event.fingerList[0].globalY    //获取Y坐标的方法
                 if (event.fingerList[0].globalY>this.screenHeight - 120) {
                   //说明没有出录音区
                   this.voiceState = VoiceRecordEnum.RecordIng
                 }else {
                   //说明出录音区域了
                   if (event.fingerList[0].globalX < this.screenWitch / 2) { //如果小于屏幕的一半说明再左侧
                     //说明出了录音区之后再左边
                     this.voiceState = VoiceRecordEnum.Cancel //把状态设置成X
                   }else {
                     //说明再右边
                     this.voiceState = VoiceRecordEnum.Transfer //把状态设置成文
                   }
                 }
               })
           )

         )
      }
      else {
        TextInput({text:$$this.content})
          .height(35)
          .borderRadius(2)
          .backgroundColor($r('app.color.white'))
          .layoutWeight(1)
          //提交事件，就是点击键盘上面的完成事件
          .onSubmit(()=>{
            if (this.content) {
              //有值的情况下就发送
              this.sendTextMessage(this.content)
              this.content = ""
            }
          })
      }

      Image($r('app.media.ic_public_add_norm'))
        .width(25)
        .height(25)
    }
    .height(60)
    .width('100%')
    .backgroundColor($r('app.color.second_back_color'))
    .padding({
      left:10,
      right:10
    })
    .bindContentCover(
      $$this.shouVoiceCon,
      this.getVoiceCom,{
        modalTransition:ModalTransition.NONE
    }
    )
  }
}
export default BottomInput