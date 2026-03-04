class ChatUserModel {
  final String name;
  final String avatar;
  final String message;
  final String? badge;
  final bool isOnline;
  final bool isVerified;
  final bool isBadgeYellow;

  ChatUserModel({
    required this.name,
    required this.avatar,
    required this.message,
    this.badge,
    this.isOnline = false,
    this.isVerified = false,
    this.isBadgeYellow = false,
  });
}
