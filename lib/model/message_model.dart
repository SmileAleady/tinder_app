class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isSent; // true: 发送方，false: 接收方
  final String status; // 'sending', 'sent', 'delivered', 'read'

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isSent,
    this.status = 'sent',
  });

  factory Message.copyWith({
    required Message original,
    String? id,
    String? content,
    DateTime? timestamp,
    bool? isSent,
    String? status,
  }) {
    return Message(
      id: id ?? original.id,
      content: content ?? original.content,
      timestamp: timestamp ?? original.timestamp,
      isSent: isSent ?? original.isSent,
      status: status ?? original.status,
    );
  }
}

class ChatSession {
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime matchedDate;
  final List<Message> messages;

  ChatSession({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.matchedDate,
    required this.messages,
  });

  factory ChatSession.copyWith({
    required ChatSession original,
    String? userId,
    String? userName,
    String? userAvatar,
    DateTime? matchedDate,
    List<Message>? messages,
  }) {
    return ChatSession(
      userId: userId ?? original.userId,
      userName: userName ?? original.userName,
      userAvatar: userAvatar ?? original.userAvatar,
      matchedDate: matchedDate ?? original.matchedDate,
      messages: messages ?? original.messages,
    );
  }
}
