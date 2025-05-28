@Entry
@Component
export struct dynamics {
  build() {
    List() {
      // 第一个模块
      ListItem() {
        Column() {
          Column() {
            Row() {
              Text('庸常生活里的喜悦，真令人困倦啊，如果你在就好了！')
                .fontSize(20)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Bold)
            }.width('100%')
            .justifyContent(FlexAlign.Start)

            // 图片行（示例使用1张图片）
            Row() {
              Text('突然醒来，我躺在一个没\n有窗户的房间，突然，有\n人敲门...')
                .fontSize(18)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Normal)

              Image($r("app.media.10"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
            }
            .margin({ bottom: 15 })

            // 作者和统计数据行
            Row() {
              Text('Mr.ling')
                .fontSize(16)
                .fontColor('#666666')

              Blank()

              Row() {
                Row() {
                  Image($r("app.media.3"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('2.1k')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
                .margin({ right: 20 })

                Row() {
                  Image($r("app.media.2"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('1.3w')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
              }
            }
            .width('100%')
            .margin({ bottom: 2 })
          }
          .width('100%')
          .padding(15)
          .backgroundColor('#FFF')
          .borderRadius(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 0, bottom: 6 })
      }

      // 分隔线
      ListItem() {
        Divider()
          .strokeWidth(0.5)
          .color('#f0f0f0')
          .margin({ left: 24, right: 24, top: 0, bottom: 0 })
      }

      // 第二段内容
      ListItem() {
        Column() {
          Column() {
            Row() {
              Text('朋友你这么棒怎么还是不开心')
                .fontSize(20)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Bold)
            }
            .width("100%")
            .justifyContent(FlexAlign.Start)

            Text('当今很多人在鼓吹，要你打破自己去救别人，我却想说，请各位都重视自己。要你打破自己去救别人，我却想说......')
              .fontSize(18)
              .margin({ bottom: 15 })
              .fontWeight(FontWeight.Normal)

            // 作者和统计数据行
            Row() {
              Text('♀ Anna')
                .fontSize(16)
                .fontColor('#666666')

              Blank()

              Row() {
                Row() {
                  Image($r("app.media.3"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('2.1k')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
                .margin({ right: 20 })

                Row() {
                  Image($r("app.media.2"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('1.3w')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
              }
            }
            .width('100%')
            .margin({ bottom: 2 })
          }
          .width('100%')
          .padding(15)
          .backgroundColor('#FFF')
          .borderRadius(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 3, bottom: 6 })
      }

      // 分隔线
      ListItem() {
        Divider()
          .strokeWidth(0.5)
          .color('#f0f0f0')
          .margin({ left: 24, right: 24, top: 0, bottom: 0 })
      }

      // 第三段内容
      ListItem() {
        Column() {
          Column() {
            Row() {
              Text('时间溜走，时间拼成梦想，无聊所以爱吃，发胖！')
                .fontSize(20)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Bold)
            }.width('100%')
            .justifyContent(FlexAlign.Start)

            // 多图片行（示例使用3张图片）
            Row() {
              Image($r("app.media.20"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
                .margin({ right: 10 })

              Image($r("app.media.30"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
                .margin({ right: 10 })

              Image($r("app.media.40"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
            }
            .margin({ bottom: 15 })

            // 作者和统计数据行
            Row() {
              Text('♀ Anna')
                .fontSize(16)
                .fontColor('#666666')

              Blank()

              Row() {
                Row() {
                  Image($r("app.media.3"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('2.1k')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
                .margin({ right: 20 })

                Row() {
                  Image($r("app.media.2"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('1.3w')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
              }
            }
            .width('100%')
            .margin({ bottom: 2 })
          }
          .width('100%')
          .padding(15)
          .backgroundColor('#FFF')
          .borderRadius(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 3, bottom: 6 })
      }

      // 分隔线
      ListItem() {
        Divider()
          .strokeWidth(0.5)
          .color('#f0f0f0')
          .margin({ left: 24, right: 24, top: 0, bottom: 0 })
      }

      // 第四段内容
      ListItem() {
        Column() {
          Column() {
            Row() {
              Text('朋友你这么棒怎么还是不开心')
                .fontSize(20)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Bold)
            }
            .width("100%")
            .justifyContent(FlexAlign.Start)

            Text('当今很多人在鼓吹，要你打破自己去救别人，我却想说，请各位都重视自己。要你打破自己去救别人，我却想说......')
              .fontSize(18)
              .margin({ bottom: 15 })
              .fontWeight(FontWeight.Normal)

            // 作者和统计数据行
            Row() {
              Text('♀ Anna')
                .fontSize(16)
                .fontColor('#666666')

              Blank()

              Row() {
                Row() {
                  Image($r("app.media.3"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('2.1k')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
                .margin({ right: 20 })

                Row() {
                  Image($r("app.media.2"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('1.3w')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
              }
            }
            .width('100%')
            .margin({ bottom: 2 })
          }
          .width('100%')
          .padding(15)
          .backgroundColor('#FFF')
          .borderRadius(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 3, bottom: 6 })
      }

      // 分隔线
      ListItem() {
        Divider()
          .strokeWidth(0.5)
          .color('#f0f0f0')
          .margin({ left: 24, right: 24, top: 0, bottom: 0 })
      }

      // 第五段内容
      ListItem() {
        Column() {
          Column() {
            Row() {
              Text('时间溜走，时间拼成梦想，无聊所以爱吃，发胖！')
                .fontSize(20)
                .margin({ bottom: 10 })
                .fontWeight(FontWeight.Bold)
            }.width('100%')
            .justifyContent(FlexAlign.Start)

            // 多图片行（示例使用3张图片）
            Row() {
              Image($r("app.media.20"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
                .margin({ right: 10 })

              Image($r("app.media.30"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
                .margin({ right: 10 })

              Image($r("app.media.40"))
                .width(90)
                .height(90)
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
            }
            .margin({ bottom: 15 })

            // 作者和统计数据行
            Row() {
              Text('♀ Anna')
                .fontSize(16)
                .fontColor('#666666')

              Blank()

              Row() {
                Row() {
                  Image($r("app.media.3"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('2.1k')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
                .margin({ right: 20 })

                Row() {
                  Image($r("app.media.2"))
                    .width(16)
                    .height(16)
                    .margin({ left: 5 })
                  Text('1.3w')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ right: 5 })
                }
              }
            }
            .width('100%')
            .margin({ bottom: 2 })
          }
          .width('100%')
          .padding(15)
          .backgroundColor('#FFF')
          .borderRadius(20)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 3, bottom: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff1f1f3')
    .padding({ top: 12, bottom: 12 })
  }
}
export default dynamics;