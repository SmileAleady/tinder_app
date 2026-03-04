import 'package:tinder_app/model/chat_user_model.dart';

class ChatConversationModel {
  final ChatUserModel sender;
  final ChatUserModel? receiver;
  final String conversationId;

  ChatConversationModel({
    required this.sender,
    this.receiver,
    required this.conversationId,
  });
}
