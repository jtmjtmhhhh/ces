import { abilityAccessCtrl, AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { WeChatStore } from '../utils/chat_stotere';
import { WeChat_CurrentUserKey } from '../constant';
import { UserInfoModel } from '../models/user';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    const manager = abilityAccessCtrl.createAtManager() //得到管理者对象
                                                      //要获取的权限的名字是那个
    manager.requestPermissionsFromUser(this.context,["ohos.permission.MICROPHONE"])
    //第一道防线 ,让权限去申请 不论过还是每过 没有关系
    //下次请求我们就可以再第二道检查线的时候 就可以检查我们的权限 进行逻辑的处理
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    WeChatStore.context = this.context  //传入上下文
    const user = WeChatStore.getCurrentUser() //获取当前用户
    AppStorage.setOrCreate<UserInfoModel>(WeChat_CurrentUserKey,user)//创建或设置持久化，设置进入全局状态

    windowStage.loadContent('pages/Login', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      //设置键盘避让模式为压缩
      windowStage.getMainWindowSync()
        .getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
