import 'package:event_bus/event_bus.dart';

/// 创建EventBus
EventBus eventBus = EventBus();

///关闭分享界面
class ShareBackEvent{
  bool isShow;
  ShareBackEvent(this.isShow);
}