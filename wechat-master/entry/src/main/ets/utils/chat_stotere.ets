import { preferences } from '@kit.ArkData'
import {
  Record_Update_EventName,
  Wechat_ConnectKey, WeChat_CurrentUserKey, WeChat_StoreKey, WeChat_UserRecordKey } from '../constant'
import { MessageInfoModel } from '../models/message'
import { CurrentUser, DefaultUserList, UserInfoModel } from '../models/user'
import { emitter } from '@kit.BasicServicesKit'

//首选项读取数据
export class WeChatStore{
  static context:Context  //声明一个单列变量它是上下文类型的，先不给初始值
  //获取首选项的仓库
  static getWeChatStore(){
    return preferences.getPreferencesSync(WeChatStore.context || getContext(),{
      name:WeChat_StoreKey
    })
  }

  //获取联系人
  static getWeChatConnect(){
    //获取联系人的话首先要获取仓库
    const store =  WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(Wechat_ConnectKey,JSON.stringify(DefaultUserList)) as string) as UserInfoModel[]
  }
  //获取当前用户
  static getCurrentUser(){
    const store =  WeChatStore.getWeChatStore()
    return JSON.parse(store.getSync(WeChat_CurrentUserKey,JSON.stringify(CurrentUser)) as string) as UserInfoModel
  }

  //获取我和某个人的聊天记录的仓库
  static getWeChatMessageStore(userId:string){
    return preferences.getPreferencesSync(getContext(),{
      name:`${WeChat_UserRecordKey}_${userId}`
    })
  }

  /**获取我和某个人的聊天记录
   * userId表示对话者的id
   * WeChat_UserRecordKey_对话者id =>所有聊天记录
   * **/
  static getWechatMessage(userId:string){
    const store = WeChatStore.getWeChatMessageStore(userId) //获取仓库
    const allRecord = store.getAllSync() as object//获取这个仓库里面的所有记录
    if (allRecord) {
      //需要的是列表的数组
      const list = Object.values(allRecord).map((item:string) => JSON.parse(item) as MessageInfoModel)//拿到所有的消息
      list.sort((a:MessageInfoModel,b:MessageInfoModel)=>a.sendTime - b.sendTime) //按照正序排列
      return list//将list进行返回正序
    }
    return []


    // list是我和某个人的所有聊天记录，但是是无序的
    // return JSON.parse(store.getSync(`${WeChat_UserRecordKey}_${userId}`,'[]') as string) as MessageInfoModel[]

  }
  //删除整个“我”和某个人的聊天记录
    static async delWeChatMessage(userId:string){
      preferences.deletePreferences(getContext(),{
        name:`${WeChat_UserRecordKey}_${userId}`
      })
    // const store = WeChatStore.getWeChatStore() //获取仓库
    // store.deleteSync(`${WeChat_UserRecordKey}_${userId}`)//根据对应的key删除对应的数据
    // await store.flush()//写入磁盘
  }
  //添加一条“我”和某个人的聊天记录
  static async addOneWechatMessage(userId:string,message:MessageInfoModel){
    const store = WeChatStore.getWeChatMessageStore(userId) //获取仓库
    store.putSync(message.id,JSON.stringify(message))//添加记录
    await store.flush()//加入磁盘
    //当这个函数执行后会执行emitter.on里面的回调函数
    emitter.emit(Record_Update_EventName)

    // const store = WeChatStore.getWeChatStore() //获取仓库
    // const list = WeChatStore.getWechatMessage(userId)//拿到所有的聊天记录
    // list.push(message) //追加一条记录
    // //写入list
    // store.putSync(`${WeChat_UserRecordKey}_${userId}`,JSON.stringify(list))
    // await store.flush() //写入磁盘
  }

  /**删除一条“我”和某个人的聊天记录
   * userId用户Id
   * messId:消息Id
   * **/
  static async delOneWechatMessage(userId:string,messId:string){
    const store = WeChatStore.getWeChatMessageStore(userId) //获取仓库
    store.deleteSync(messId)//删除这个仓库里面的某一条消息
    await store.flush()//同步到磁盘
    emitter.emit(Record_Update_EventName)//当这个函数执行后会执行emitter.on里面的回调函数
    // const store = WeChatStore.getWeChatStore() //获取仓库
    // const list = WeChatStore.getWechatMessage(userId)//拿到所有的聊天记录
    // //通过消息索引和列表中的索引对比拿到要删除的索引
    // const index = list.findIndex(item => item.id ===messId)
    // list.splice(index,1)//删除一条
    // //写入list
    // store.putSync(`${WeChat_UserRecordKey}_${userId}`,JSON.stringify(list))
    // await store.flush() //写入磁盘
  }

  //获取所有人的聊天记录的最后一条的集合
  static getAllLastRecord(){

    //先拿到所有的联系人
    const users =  WeChatStore.getWeChatConnect()
    const list:MessageInfoModel[] = [] //定义一个列表
    users.forEach(user=>{
      //拿到每一个用户
      //调用上面的那个方法可以获得每一个用户的聊天记录
      const weMessage = WeChatStore.getWechatMessage(user.user_id)

      if (weMessage && weMessage.length){
        //说明和这个人有聊天记录
        list.push(weMessage[weMessage.length - 1]) //将最后一条数据添加到列表中
      }
      //此时list就是所有人的最后一条聊天记录
      list.sort((a:MessageInfoModel,b:MessageInfoModel)=>b.sendTime - a.sendTime)//进行排序
      user.user_id
    })
    return list //最后将列表进行返回
  }
}


