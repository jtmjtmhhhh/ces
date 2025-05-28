import { VoiceRecordEnum } from '../../../models/voice'

@Component
struct VoiceInput {
  //接收组件状态
  @Consume
  voiceState:VoiceRecordEnum

  //用来展示不同的区域内容
  @Builder
  getDisplayContent(){
    if(this.voiceState === VoiceRecordEnum.Cancel){
      //正在取消
      Row(){

      }
      .width(100)
      .height(80)
      .borderRadius(20)
      .backgroundColor($r('app.color.danger'))
      .margin({
        left:30
      })
    }
    else if(this.voiceState === VoiceRecordEnum.RecordIng){
      //正在录音
      Row(){

      }
      .width(180)
      .height(80)
      .borderRadius(20)
      .backgroundColor($r('app.color.chat_primary'))
    }
    else if(this.voiceState === VoiceRecordEnum.Transfer){
      //正在转化文本
      Row(){

      }
      .width(280)
      .height(120)
      .borderRadius(20)
      .backgroundColor($r('app.color.chat_primary'))
    }

  }
  build() {
    Stack({alignContent:Alignment.Bottom}){
      Column(){
      //显示关闭和文本
        //取消红色的录制区域
        //录音  中间声音波峰- 计算buffer-暂时没有其它好的方案
        //语音转化-语音转文本  pcm封装音频转文本 speeach
        this.getDisplayContent()

        //显示关闭和文本
        Row(){
          Row(){
            Image($r("app.media.ic_public_cancel"))
              .width(30)
              .height(30)
              //如果选中那么就是激活色，如果没有那么就是普通色
              .fillColor(this.voiceState ===VoiceRecordEnum.Cancel?
              $r('app.color.text_primary'):
              $r('app.color.voice_round_font_color'))
          }
          //如果选中那么就是激活色，如果没有那么就是普通色
          .backgroundColor(this.voiceState ===VoiceRecordEnum.Cancel?
          $r('app.color.bottom_color'):
          $r('app.color.voice_round_color'))
          .width(70)
          .aspectRatio(1)//宽高比
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .rotate({
            angle:-10
          })
          .scale({  //如果选中那么把图标扩大1.2倍，如果没有那么就正常
            x:this.voiceState ===VoiceRecordEnum.Cancel ? 1.2 : 1,
            y:this.voiceState ===VoiceRecordEnum.Cancel ? 1.2 : 1
          })
          Row(){
            Row(){
              Text("文")
                .fontSize(24)
                .textAlign(TextAlign.Center)
                .fontColor(this.voiceState ===VoiceRecordEnum.Transfer?
                $r('app.color.text_primary'):
                $r('app.color.voice_round_font_color'))
            }
            .scale({  //如果选中那么把图标扩大1.2倍，如果没有那么就正常
              x:this.voiceState ===VoiceRecordEnum.Transfer ? 1.2 : 1,
              y:this.voiceState ===VoiceRecordEnum.Transfer ? 1.2 : 1
            })
            .rotate({
              angle:10
            })
          }
          //如果选中那么就是激活色，如果没有那么就是普通色
          .backgroundColor(this.voiceState ===VoiceRecordEnum.Transfer?
          $r('app.color.bottom_color'):
          $r('app.color.voice_round_color'))
          .width(70)
          .aspectRatio(1)//宽高比
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:40,right:40})
        .margin({
          top:120,
          bottom:30})


        Stack(){
          Image($r("app.media.ic_public_output"))
            .width("100%")
            .height(120)
            //如果是被选中那么就是选中的颜色
            .fillColor(this.voiceState ===VoiceRecordEnum.RecordIng ?
            $r('app.color.bottom_color'):
            $r('app.color.voice_round_color'))
            .scale({
              x:1.2
            })
          Image($r('app.media.ic_public_recorder'))
            .width(30)
            .height(30)
            .fillColor(this.voiceState ===VoiceRecordEnum.RecordIng ?
            $r('app.color.voice_round_color'):
            $r('app.color.bottom_color'))
        }
        .width('100%')
      }
      .alignItems(this.voiceState === VoiceRecordEnum.Cancel ? HorizontalAlign.Start:HorizontalAlign.Center)
    }
    .height("100%")
    .backgroundColor($r('app.color.voice_back_color'))
  }
}
export default VoiceInput