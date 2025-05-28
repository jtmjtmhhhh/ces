export interface PopupItem{
  icon:ResourceStr //图标
  title:string //文本
  itemClick?:()=>void //点击事件 可选
}