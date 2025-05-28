import { audio } from "@kit.AudioKit";
import { fileIo } from "@kit.CoreFileKit";

//录音单列类
export class AudioCapturer{
  //先声明一个彩音对象的单列对象，也就是audio.AudioCapturer类型的一个变量
  static audioCapturer:audio.AudioCapturer
  //采样配置
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率 就是1秒钟之内采集多少次
    channels: audio.AudioChannel.CHANNEL_2, // 通道 也就是声道，最多可以到16声道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  //录音配置
  static audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC,
    capturerFlags: 0
  };
  //总体的配置
  static audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: AudioCapturer.audioStreamInfo,
    capturerInfo: AudioCapturer.audioCapturerInfo
  };
  //初始化音频采集器的方法
  static async  init(){
    //如果它是非的情况下
    if (!AudioCapturer.audioCapturer) {
      //我们才去创建
      AudioCapturer.audioCapturer = //这里换一个行
        await audio.createAudioCapturer(AudioCapturer.audioCapturerOptions)
    }
  }

  static recordIng:boolean = false //是否正在录制
  //开始录音的方法
  static async stare(path:string){
    if (!AudioCapturer.audioCapturer) return
    try {
      AudioCapturer.recordIng = true  //开始录音的标注
      await AudioCapturer.audioCapturer.start() //开始录音

      //表示我们此时此刻已经可以录音了，但是你必须带把声音输出的一段buffer写人到一个固定文件中，或者直接播出这个buffer
      //用读写的方式打开文件如果文件不存在，那么就以创建方式打开文件
      const file = fileIo.openSync(path,fileIo.OpenMode.READ_WRITE || fileIo.OpenMode.CREATE)
      //先把原有的file文件的buffer的长度拿过来
      let fd = file.fd //给文件做一个标识，相当于给人标一个号
      const statFile = fileIo.statSync(file.fd)//解析这个文件
      let bufferSize =  statFile.size //原有buffer的长度 是一个写入文件的基准点

      while (AudioCapturer.recordIng){
        //只要这个标记开始那么我就一直读，一直采集一直写入文件
        //获取缓冲区的长度
        let size =AudioCapturer.audioCapturer.getBufferSizeSync()

        console.log('测试执行到了没有1')
        let buffer = await AudioCapturer.audioCapturer.read(size,true)  //读它里面的buffer
        //    然后这个buffer（变量）就算当前这一段的录音的内容

        fileIo.writeSync(fd,buffer,{
          offset:bufferSize,//偏移量
          length:buffer.byteLength
        })
        bufferSize += buffer.byteLength
        console.log('测试执行到了没有2',JSON.stringify(bufferSize))
      }
    }catch(error){
      console.log("录音出错了",JSON.stringify(error))
    }


  }
  //结束录音的放
  static async stop(){
    AudioCapturer.recordIng = false
    if (AudioCapturer.audioCapturer) {//创建好声音采集器了
      //如果它是再录制过程中
      if (AudioCapturer.audioCapturer.state === audio.AudioState.STATE_RUNNING
        || AudioCapturer.audioCapturer.state === audio.AudioState.STATE_PAUSED //或者是暂停状态
      ) {
        await AudioCapturer.audioCapturer.stop() //停止录音
      }
    }
  }
  //释放资源
  static async release(){
    //如果它存在的话
    if (AudioCapturer.audioCapturer) {
      //那么就释放资源
      AudioCapturer.audioCapturer.release()
      AudioCapturer.recordIng = false
    }
  }
}

//用来播放pcm音频
export class AudioRenderer{
  //实例化一个单列
  static renderModel:audio.AudioRenderer
  //采样配置
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率 就是1秒钟之内采集多少次
    channels: audio.AudioChannel.CHANNEL_2, // 通道 也就是声道，最多可以到16声道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  //创佳播放器的参数准备好了
  static audioRenderInfo:audio.AudioRendererInfo ={
    rendererFlags:0, //普通音频渲染器 0 ， 1为低时延
    //使用场景，我们这里用通话场景
    usage:audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION
  }
  static audioRendererOptions:audio.AudioRendererOptions ={
    streamInfo:AudioRenderer.audioStreamInfo,//第一个参数也就是我们的采样配置
    rendererInfo:AudioRenderer.audioRenderInfo
  }
  //初始化
  static async  init(){
    //如果再它没有值的情况下
    if (!AudioRenderer.renderModel) {
      //创建实例
      AudioRenderer.renderModel =await audio.createAudioRenderer(AudioRenderer.audioRendererOptions)
    }
  }
  //开始语音播放
  static async start(filePath:string){
    //如果这个路径存在的情况下，而且已经初始化
    if (AudioRenderer.renderModel && filePath) {
      //先关一下状态
      //如果你再播放的情况下还能播吗？
      //只有再暂停 停止 还有准备这些状态下才可以进行播放
      let stateList:audio.AudioState[] = [
        audio.AudioState.STATE_PREPARED, //准备状态
        audio.AudioState.STATE_PAUSED, //暂停状态
        audio.AudioState.STATE_STOPPED  //停止状态
      ]
      //includes是列表当中的包含的意思
      if (!stateList.includes(AudioRenderer.renderModel.state)) {
        //如果不包含的情况下 此时就不能进行播放
        return  //此时我们直接返回就可以
      }
      if (stateList.includes(AudioRenderer.renderModel.state)) {
        //如果过了这个判断那么此时是可以进行播放的
        await AudioRenderer.renderModel.start() //启动播放
        //读写文件filePath的文件  一段段的进行读取，读完拉到
        const file = fileIo.openSync(filePath,fileIo.OpenMode.READ_ONLY)//读这个文件的buff
        // AudioRenderer.renderModel.write() //写入文件的方法
        const state = fileIo.statSync(file.fd) //详细信息 如文件
        const bufferSize = await AudioRenderer.renderModel.getBufferSize() //获取缓冲区的长度
        let buf = new ArrayBuffer(bufferSize) //创建一个缓冲区的对象 长度是音频采集器的长度
        let totalSize = 0
        //当这个参数小于文件的长度的时候执行
        while (totalSize < state.size){
          //读取文件
          fileIo.readSync(file.fd,buf,{
            //第三个参数就是偏移量
            offset:totalSize, //之前的
            length:bufferSize //新的
          })
          await AudioRenderer.renderModel.write(buf)//往音频采集器中写入缓冲区内容
          //每次循环我们都加上我们缓冲区的长度
          totalSize += bufferSize
        }
        //关闭文件
        fileIo.closeSync(file.fd)
        AudioRenderer.stop() //关闭
      }
    }
  }


  //音频的释放和暂停
  static async stop(){  //暂停
    if (AudioRenderer.renderModel) {
      await AudioRenderer.renderModel.stop() //直接调用它里面的停止方法
    }
  }
  static async release(){  //释放
    if (AudioRenderer.renderModel) {
      await AudioRenderer.renderModel.stop() //释放方法
    }
  }
}
