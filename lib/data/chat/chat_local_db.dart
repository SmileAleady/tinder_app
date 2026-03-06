import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';

class ChatLocalDb {
  ChatLocalDb._();

  static final ChatLocalDb instance = ChatLocalDb._();

  static const String _dbFileName = 'chat_local_db.json';

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_dbFileName');
  }

  Future<ChatUserProfile?> getActiveUser() async {
    final active = await UserAuthLocalDb.instance.getActiveUser();
    if (active == null) {
      return null;
    }
    return ChatUserProfile.fromUser(active);
  }

  Future<List<ChatUserProfile>> getAllUserProfiles() async {
    final localUsers = await UserAuthLocalDb.instance.getAllUsers();
    final seedUsers = OptionDataManager.getUserList();

    final byUserId = <String, ChatUserProfile>{};
    for (final user in [...seedUsers, ...localUsers]) {
      byUserId[user.userId] = ChatUserProfile.fromUser(user);
    }

    return byUserId.values.toList();
  }

  Future<UserProfileModel?> getUserProfileById(String userId) async {
    final localUsers = await UserAuthLocalDb.instance.getAllUsers();
    final seedUsers = OptionDataManager.getUserList();
    for (final user in [...localUsers, ...seedUsers]) {
      if (user.userId == userId) {
        return user;
      }
    }
    return null;
  }

  Future<void> ensureSeedForUser(String activeUserId) async {
    final allUsers = await getAllUserProfiles();
    final self = allUsers.where((u) => u.userId == activeUserId).toList();
    if (self.isEmpty) {
      return;
    }

    final raw = await _readRaw();
    final matches = _readMatches(raw);
    final messages = _readMessages(raw);

    final existed = matches.where((m) => m.includes(activeUserId)).toList();
    if (existed.isNotEmpty) {
      return;
    }

    final candidates = allUsers
        .where((u) => u.userId != activeUserId)
        .take(4)
        .toList();
    final now = DateTime.now();

    for (var i = 0; i < candidates.length; i++) {
      final other = candidates[i];
      final pairId = _pairId(activeUserId, other.userId);
      final match = ChatMatchRecord(
        pairId: pairId,
        userA: activeUserId,
        userB: other.userId,
        matchedAtIso: now.subtract(Duration(days: i + 1)).toIso8601String(),
        openedBy: i == 0 ? <String>[activeUserId] : <String>[],
      );
      matches.add(match);

      if (i == 0) {
        messages.add(
          ChatMessageRecord(
            id: '${pairId}_seed_1',
            pairId: pairId,
            senderId: other.userId,
            receiverId: activeUserId,
            content: '嗨，最近怎么样？',
            timestampIso: now
                .subtract(const Duration(hours: 2))
                .toIso8601String(),
            status: 'delivered',
          ),
        );
      }
      if (i == 1) {
        messages.add(
          ChatMessageRecord(
            id: '${pairId}_seed_2',
            pairId: pairId,
            senderId: activeUserId,
            receiverId: other.userId,
            content: '1111',
            timestampIso: now
                .subtract(const Duration(minutes: 20))
                .toIso8601String(),
            status: 'sent',
          ),
        );
      }
    }

    await _save(raw, matches, messages);
  }

  Future<ConversationListData> getConversationListData({
    required String activeUserId,
  }) async {
    await ensureSeedForUser(activeUserId);

    final users = await getAllUserProfiles();
    final userMap = {for (final u in users) u.userId: u};

    final raw = await _readRaw();
    final matches = _readMatches(
      raw,
    ).where((m) => m.includes(activeUserId)).toList();
    final messages = _readMessages(raw);

    final newMatches = <ConversationPeer>[];
    final chatted = <ConversationPeer>[];

    for (final match in matches) {
      final peerId = match.peerIdFor(activeUserId);
      if (peerId == null) {
        continue;
      }
      final peerProfile = userMap[peerId];
      if (peerProfile == null) {
        continue;
      }

      final pairMessages =
          messages.where((m) => m.pairId == match.pairId).toList()
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      final latest = pairMessages.isNotEmpty ? pairMessages.last : null;
      final unreadCount = pairMessages
          .where((m) => m.receiverId == activeUserId && m.status != 'read')
          .length;
      final hasOpened = match.openedBy.contains(activeUserId);
      final hasChat = hasOpened || pairMessages.isNotEmpty;

      final peer = ConversationPeer(
        pairId: match.pairId,
        peerId: peerProfile.userId,
        peerName: peerProfile.nickname,
        peerAvatar: peerProfile.avatar,
        isVerified: true,
        matchedAt: match.matchedAt,
        latestMessage: latest?.content,
        latestTimestamp: latest?.timestamp,
        unreadCount: unreadCount,
        hasChat: hasChat,
      );

      if (hasChat) {
        chatted.add(peer);
      } else {
        newMatches.add(peer);
      }
    }

    chatted.sort((a, b) {
      final at = a.latestTimestamp ?? a.matchedAt;
      final bt = b.latestTimestamp ?? b.matchedAt;
      return bt.compareTo(at);
    });

    newMatches.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));

    return ConversationListData(newMatches: newMatches, chatted: chatted);
  }

  Future<void> markConversationOpened({
    required String pairId,
    required String userId,
  }) async {
    final raw = await _readRaw();
    final matches = _readMatches(raw);
    final messages = _readMessages(raw);

    for (final match in matches) {
      if (match.pairId == pairId && !match.openedBy.contains(userId)) {
        match.openedBy.add(userId);
      }
    }

    await _save(raw, matches, messages);
  }

  Future<ConversationDetailData> getConversationDetail({
    required String pairId,
    required String activeUserId,
    required int page,
    int pageSize = 10,
  }) async {
    final users = await getAllUserProfiles();
    final userMap = {for (final u in users) u.userId: u};

    final raw = await _readRaw();
    final matches = _readMatches(raw);
    final messages = _readMessages(raw);

    final match = matches.firstWhere(
      (m) => m.pairId == pairId,
      orElse: () => ChatMatchRecord(
        pairId: pairId,
        userA: activeUserId,
        userB: '',
        matchedAtIso: DateTime.now().toIso8601String(),
        openedBy: <String>[activeUserId],
      ),
    );

    final peerId = match.peerIdFor(activeUserId) ?? '';
    final peer =
        userMap[peerId] ??
        ChatUserProfile(
          userId: peerId,
          nickname: '用户',
          avatar: '',
          age: null,
          email: '',
        );

    final all = messages.where((m) => m.pairId == pairId).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final endExclusive = (all.length - page * pageSize).clamp(0, all.length);
    final start = (endExclusive - pageSize).clamp(0, endExclusive);
    final slice = all.sublist(start, endExclusive);

    final rows = slice
        .map(
          (m) => ConversationMessage(
            id: m.id,
            content: m.content,
            timestamp: m.timestamp,
            isMine: m.senderId == activeUserId,
            status: m.status,
          ),
        )
        .toList();

    for (final msg in all.where(
      (m) => m.receiverId == activeUserId && m.status != 'read',
    )) {
      msg.status = 'read';
    }
    await _save(raw, matches, messages);

    return ConversationDetailData(
      pairId: pairId,
      peer: peer,
      matchedAt: match.matchedAt,
      messages: rows,
      hasMore: start > 0,
      isFirstConversation: all.isEmpty,
    );
  }

  Future<void> sendMessage({
    required String pairId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final raw = await _readRaw();
    final matches = _readMatches(raw);
    final messages = _readMessages(raw);

    messages.add(
      ChatMessageRecord(
        id: '${DateTime.now().microsecondsSinceEpoch}_$senderId',
        pairId: pairId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        timestampIso: DateTime.now().toIso8601String(),
        status: 'sent',
      ),
    );

    for (final match in matches) {
      if (match.pairId == pairId && !match.openedBy.contains(senderId)) {
        match.openedBy.add(senderId);
      }
    }

    await _save(raw, matches, messages);
  }

  Future<void> removePairAndMessages(String pairId) async {
    final raw = await _readRaw();
    final matches = _readMatches(raw)..removeWhere((m) => m.pairId == pairId);
    final messages = _readMessages(raw)..removeWhere((m) => m.pairId == pairId);
    await _save(raw, matches, messages);
  }

  Future<void> removeAllForUser(String userId) async {
    final raw = await _readRaw();
    final matches = _readMatches(raw);
    final removedPairIds = matches
        .where((m) => m.includes(userId))
        .map((m) => m.pairId)
        .toSet();
    matches.removeWhere((m) => removedPairIds.contains(m.pairId));

    final messages = _readMessages(raw)
      ..removeWhere(
        (m) =>
            m.senderId == userId ||
            m.receiverId == userId ||
            removedPairIds.contains(m.pairId),
      );
    await _save(raw, matches, messages);
  }

  Future<Map<String, dynamic>> _readRaw() async {
    final file = await _dbFile();
    if (!await file.exists()) {
      return {
        'matches': <Map<String, dynamic>>[],
        'messages': <Map<String, dynamic>>[],
      };
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return {
        'matches': <Map<String, dynamic>>[],
        'messages': <Map<String, dynamic>>[],
      };
    }

    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return {
        'matches': <Map<String, dynamic>>[],
        'messages': <Map<String, dynamic>>[],
      };
    }
    return decoded;
  }

  List<ChatMatchRecord> _readMatches(Map<String, dynamic> raw) {
    final list = raw['matches'] as List<dynamic>? ?? <dynamic>[];
    return list
        .map((e) => ChatMatchRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<ChatMessageRecord> _readMessages(Map<String, dynamic> raw) {
    final list = raw['messages'] as List<dynamic>? ?? <dynamic>[];
    return list
        .map((e) => ChatMessageRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save(
    Map<String, dynamic> raw,
    List<ChatMatchRecord> matches,
    List<ChatMessageRecord> messages,
  ) async {
    final file = await _dbFile();
    raw['matches'] = matches.map((m) => m.toJson()).toList();
    raw['messages'] = messages.map((m) => m.toJson()).toList();
    raw['updatedAt'] = DateTime.now().toIso8601String();
    await file.writeAsString(jsonEncode(raw));
  }

  String _pairId(String a, String b) {
    final arr = [a, b]..sort();
    return '${arr[0]}_${arr[1]}';
  }
}

class ChatUserProfile {
  final String userId;
  final String nickname;
  final String avatar;
  final int? age;
  final String email;

  ChatUserProfile({
    required this.userId,
    required this.nickname,
    required this.avatar,
    required this.age,
    required this.email,
  });

  factory ChatUserProfile.fromUser(UserProfileModel user) {
    return ChatUserProfile(
      userId: user.userId,
      nickname: user.nikeName.isEmpty ? '用户' : user.nikeName,
      avatar: user.mediaUrls.isNotEmpty ? user.mediaUrls.first : '',
      age: user.age,
      email: user.email,
    );
  }
}

class ChatMatchRecord {
  final String pairId;
  final String userA;
  final String userB;
  final String matchedAtIso;
  final List<String> openedBy;

  ChatMatchRecord({
    required this.pairId,
    required this.userA,
    required this.userB,
    required this.matchedAtIso,
    required this.openedBy,
  });

  DateTime get matchedAt => DateTime.tryParse(matchedAtIso) ?? DateTime.now();

  bool includes(String userId) => userA == userId || userB == userId;

  String? peerIdFor(String userId) {
    if (userA == userId) {
      return userB;
    }
    if (userB == userId) {
      return userA;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'pairId': pairId,
      'userA': userA,
      'userB': userB,
      'matchedAtIso': matchedAtIso,
      'openedBy': openedBy,
    };
  }

  factory ChatMatchRecord.fromJson(Map<String, dynamic> json) {
    return ChatMatchRecord(
      pairId: json['pairId'] as String,
      userA: json['userA'] as String,
      userB: json['userB'] as String,
      matchedAtIso: json['matchedAtIso'] as String,
      openedBy: List<String>.from(json['openedBy'] as List? ?? <String>[]),
    );
  }
}

class ChatMessageRecord {
  final String id;
  final String pairId;
  final String senderId;
  final String receiverId;
  final String content;
  final String timestampIso;
  String status;

  ChatMessageRecord({
    required this.id,
    required this.pairId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestampIso,
    required this.status,
  });

  DateTime get timestamp => DateTime.tryParse(timestampIso) ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pairId': pairId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestampIso': timestampIso,
      'status': status,
    };
  }

  factory ChatMessageRecord.fromJson(Map<String, dynamic> json) {
    return ChatMessageRecord(
      id: json['id'] as String,
      pairId: json['pairId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      timestampIso: json['timestampIso'] as String,
      status: json['status'] as String? ?? 'sent',
    );
  }
}

class ConversationListData {
  final List<ConversationPeer> newMatches;
  final List<ConversationPeer> chatted;

  ConversationListData({required this.newMatches, required this.chatted});
}

class ConversationPeer {
  final String pairId;
  final String peerId;
  final String peerName;
  final String peerAvatar;
  final bool isVerified;
  final DateTime matchedAt;
  final String? latestMessage;
  final DateTime? latestTimestamp;
  final int unreadCount;
  final bool hasChat;

  ConversationPeer({
    required this.pairId,
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
    required this.isVerified,
    required this.matchedAt,
    required this.latestMessage,
    required this.latestTimestamp,
    required this.unreadCount,
    required this.hasChat,
  });
}

class ConversationDetailData {
  final String pairId;
  final ChatUserProfile peer;
  final DateTime matchedAt;
  final List<ConversationMessage> messages;
  final bool hasMore;
  final bool isFirstConversation;

  ConversationDetailData({
    required this.pairId,
    required this.peer,
    required this.matchedAt,
    required this.messages,
    required this.hasMore,
    required this.isFirstConversation,
  });
}

class ConversationMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isMine;
  final String status;

  ConversationMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isMine,
    required this.status,
  });
}
