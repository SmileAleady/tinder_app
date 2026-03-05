import 'package:event_bus/event_bus.dart';
import 'package:tinder_app/model/user_profile_model.dart';

// 全局单例
final EventBus eventBus = EventBus();

/// 发送给 ProfileEditPage 的文本事件
class PromptAnswerEvent {
  final UserPrompt model;
  PromptAnswerEvent(this.model);
}
