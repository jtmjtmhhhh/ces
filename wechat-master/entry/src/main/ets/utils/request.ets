import { http } from "@kit.NetworkKit";
import { ChatResponse } from "../models/chat";

//获取响应结果的函数
export async  function getRequestMessage(content:string){
  const req = http.createHttp() //创建一个请求
  try {
    const res = await req.request(`http://api.qingyunke.com/api.php?key=free&appid=0&msg=${encodeURIComponent(content)}`) //进行请求青云客平台提供的免费公共 API
    const result = JSON.parse(res.result as string) as ChatResponse
    return result
  } catch (error){
    return Promise.reject(error)
  }
}
