import { UserInfo,UserInfoModel } from "./user"
import { util } from "@kit.ArkTS"

export interface MessageInfo{
  id:string //标识
  sendUser: UserInfo  //这条信息的发送者
  connectUser:UserInfo  //这条相信的归属者
  messageContent:string //消息内容  可以是文本信息 [图片]  [语音’7]、
  sendTime:number //发送时间
  //消息类型
  messageType:MessageTypeEnum //消息类型
  sourceFilePath:string //音频 视频 图片 的地址
  sourceDuration:number //音频或者视频的长度 单位 s
}
//消息类型的枚举
export enum MessageTypeEnum{
  TEXT, //文本类型
  IMAGE, //图片类型
  AUDIO,//语音类型
  VIDEO,//视频类型
  LOCATION,//定位
  LINK//链接
}
export class MessageInfoModel implements MessageInfo {
  id: string = ''
  sendUser: UserInfo = new UserInfoModel({} as UserInfo)
  connectUser: UserInfo = new UserInfoModel({} as UserInfo)
  messageContent: string = ''
  sendTime: number = 0
  messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  sourceFilePath: string = ''
  sourceDuration: number = 0

  constructor(model: MessageInfo) {
    this.id = model.id  || util.generateRandomUUID()  //生成uuid
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    this.sendTime = model.sendTime || Date.now() //发送时间
    this.messageType = model.messageType || MessageTypeEnum.TEXT  //消息类型默认为文本类型
    this.sourceFilePath = model.sourceFilePath
    this.sourceDuration = model.sourceDuration
  }
}
