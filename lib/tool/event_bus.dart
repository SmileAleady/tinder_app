import 'package:event_bus/event_bus.dart';
import 'package:tinder_app/model/user_profile_model.dart';

// 全局单例
final EventBus eventBus = EventBus();

/// 发送给 ProfileEditPage 的文本事件
class PromptAnswerEvent {
  final UserPrompt model;
  PromptAnswerEvent(this.model);
}

/// Notify global UI that liked-users count may have changed.
class LikeUsersChangedEvent {
  const LikeUsersChangedEvent();
}

/// Notify global UI that best-users list may have changed.
class BestUsersChangedEvent {
  const BestUsersChangedEvent();
}
