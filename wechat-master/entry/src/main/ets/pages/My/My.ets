import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

/**
 * 设置项数据类
 */
class ItemData {
  title: string;
  img: Resource;
  others: string | null;

  constructor(title: string, img: Resource, others: string | null) {
    this.title = title;
    this.img = img;
    this.others = others;
  }
}

/**
 * 我的页面
 */
@Component
export default struct My {
  // 设置列表数据
  private settingListData: Array<ItemData> = [
    new ItemData('推送通知', $r('app.media.tuisong'), '开关'),
    new ItemData('数据管理', $r('app.media.guanli'), null),
    new ItemData('菜单设置', $r('app.media.shezhi'), null),
    new ItemData('关于', $r('app.media.guanyu'), null),
    new ItemData('清除缓存', $r('app.media.qingli'), null),
    new ItemData('隐私协议', $r('app.media.yinsi'), null)
  ];

  // 构建设置项单元格
  @Builder settingCell(item: ItemData) {
    Row() {
      Row({ space: 12 }) {
        Image(item.img)
          .width(22)
          .height(22);
        Text(item.title)
          .fontSize(16);
      }

      // 设置功能项最右侧的功能项
      if (item.others === null) {
        // 可以进入下一级页面
        Image($r('app.media.jiantou'))
          .width(12)
          .height(24);
      } else {
        // 开关
        Toggle({ type: ToggleType.Switch, isOn: false });
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left: 8, right: 22 });
  }

  // 构建个人信息区域
  @Builder userInfoSection() {
    Row() {
      Image($r('app.media.touxiang'))
        .width(48)
        .height(48);
      Column() {
        Text('李先生')
          .fontSize(20);
        Text('123123456@qq.com')
          .fontSize(12)
          .margin({ top: 4 });
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 24 });
    }
    .margin({ top: 24 })
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(96)
    .backgroundColor(Color.White)
    .padding({ left: 24 })
    .borderRadius(16);
  }

  // 构建设置列表
  @Builder settingsList() {
    List() {
      ForEach(this.settingListData, (item: ItemData) => {
        ListItem() {
          this.settingCell(item);
        }
        .height(48);
      }, (item: ItemData) => JSON.stringify(item));
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('42%')
    // 为列表增加分隔线
    .divider({
      strokeWidth: 1,
      color: Color.Grey,
      startMargin: 42,
      endMargin: 42
    })
    .borderRadius(16)
    .padding({ top: 4, bottom: 4 });
  }

  // 构建退出登录按钮
  @Builder logoutButton() {
    Button('退出登录', { type: ButtonType.Capsule })
      .width('90%')
      .height(40)
      .fontSize(16)
      .fontColor(Color.Red)
      .fontWeight(FontWeight.Medium)
      .backgroundColor(Color.White)
      .margin({ bottom: 55 })
      .onClick(() => {
        promptAction.showToast({ message: '退出登录' });
        router.replaceUrl({ url: 'pages/Login' });
      });
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Column() {
          Text('我的')
            .fontWeight(FontWeight.Medium)
            .fontSize(24)
            .margin({ top: 12 })
            .padding({ left: 12 });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start);

        // 个人信息
        this.userInfoSection();

        // 功能列表
        this.settingsList();

        Blank();

        // 退出登录按钮
        this.logoutButton();
      }
      .height('100%');
    }
  }
}
