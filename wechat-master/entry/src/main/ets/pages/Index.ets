import { TabBarClass } from '../models/tab'
import { WeChatStore } from '../utils/chat_stotere'
import Connect from './Connect/Connect'
import WeChat from './WeChat/WeChat'
import My from './My/My'
import Dynamics from './Dynamics/Dynamics'
@Entry
@Component
struct Index {



  //需要一个循环的列表
  @State
  tabList: TabBarClass[] = [{
    icon: $r('app.media.ic_public_message'),
    name: 'wechat',
    title: '随信',
    selectIcon: $r('app.media.ic_public_message_filled')
  }, {
    icon: $r('app.media.ic_public_contacts_group'),
    name: 'connect',
    title: '朋友',
    selectIcon:  $r('app.media.ic_public_contacts_group_filled')
  }, {
    icon: $r('app.media.ic_gallery_discover'),
    name: 'dynamics',
    title: '动态',
    selectIcon: $r('app.media.ic_gallery_discover_filled')
  }, {
    icon: $r('app.media.ic_public_contacts'),
    name: 'my',
    title: '个人中心',
    selectIcon: $r('app.media.ic_public_contacts_filled')
  }]

  @State
  curretIndex:number = 0 //激活索引
  @Builder
  commonTabBar(item:TabBarClass){
    Column(){
      Image(item.name === this.tabList[this.curretIndex].name ? item.selectIcon:item.icon)
        .width(20)
        .height(20)
      Text(item.title)
        .fontSize(12)
        .fontColor(item.name === this.tabList[this.curretIndex].name ? $r('app.color.primary')
          :$r('app.color.text_second')
        )
        .margin({top:4})
    }
  }


  build() {
    Tabs({index:$$this.curretIndex}){
      ForEach(this.tabList,(item:TabBarClass)=>{
        TabContent(){
          if (item.name === 'connect') {
            Connect()
          }
          else if (item.name === 'wechat'){
            WeChat()
          }
          else if (item.name === 'dynamics') {
            Dynamics()
          }
          else if (item.name === 'my') {
            My()
          }
          else {
            Text(item.title)
          }
        }
        .tabBar(this.commonTabBar(item))
      })
    }
    .animationDuration(100)
    .barPosition(BarPosition.End)
  }
}




