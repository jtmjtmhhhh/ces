import { fileIo } from "@kit.CoreFileKit";
import { util } from "@kit.ArkTS";

//导出一个单列
export class FileCommon{

  //创建文件的方法
  static createAudioFile(){//创建一个音频文件
    //创建文件路径,我们这里就存到filesDir目录下了
    const path = getContext().filesDir + "/" +util.generateRandomUUID() + ".wav"
    const file = fileIo.openSync(path,fileIo.OpenMode.CREATE)
    fileIo.closeSync(file)//创建好之后吧缓冲区给关掉
    return path //最后进行返回
  }
  //删除文件方法
  static delFilePath(path:string){//传一个要删除文件的路径
    if (path) {//如果路径存在
      fileIo.unlinkSync(path)//那么就把这个文件进行删除
    }
  }
}
