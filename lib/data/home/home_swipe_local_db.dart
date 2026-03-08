import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:tinder_app/model/user_profile_model.dart';

class HomeSwipeLocalDb {
  HomeSwipeLocalDb._();

  static final HomeSwipeLocalDb instance = HomeSwipeLocalDb._();

  static const String _dbFileName = 'home_swipe_db.json';

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_dbFileName');
  }

  Future<List<UserProfileModel>> getFeedUsers(
    String activeUserId,
    List<UserProfileModel> fallbackUsers,
  ) async {
    final raw = await _readRaw();
    final feedMap = _readUserMap(raw['feedByUserId']);
    final likedMap = _readUserMap(raw['likedByUserId']);

    final feed = feedMap[activeUserId] ?? <UserProfileModel>[];
    if (feed.isNotEmpty) {
      return feed;
    }

    final likedIds = (likedMap[activeUserId] ?? <UserProfileModel>[])
        .map((item) => item.userId)
        .toSet();

    final seeded = fallbackUsers
        .where((item) => item.userId != activeUserId)
        .where((item) => !likedIds.contains(item.userId))
        .toList();

    feedMap[activeUserId] = seeded;
    await _save(feedMap, likedMap);
    return seeded;
  }

  Future<List<UserProfileModel>> getLikedUsers(String activeUserId) async {
    final raw = await _readRaw();
    final likedMap = _readUserMap(raw['likedByUserId']);
    return likedMap[activeUserId] ?? <UserProfileModel>[];
  }

  Future<void> consumeTopCard({
    required String activeUserId,
    required UserProfileModel user,
    required bool liked,
  }) async {
    final raw = await _readRaw();
    final feedMap = _readUserMap(raw['feedByUserId']);
    final likedMap = _readUserMap(raw['likedByUserId']);

    final feed = feedMap[activeUserId] ?? <UserProfileModel>[];
    feed.removeWhere((item) => item.userId == user.userId);
    feedMap[activeUserId] = feed;

    if (liked) {
      final likedUsers = likedMap[activeUserId] ?? <UserProfileModel>[];
      final exists = likedUsers.any((item) => item.userId == user.userId);
      if (!exists) {
        likedUsers.insert(0, user);
      }
      likedMap[activeUserId] = likedUsers;
    }

    await _save(feedMap, likedMap);
  }

  Future<void> replaceFeedUsers({
    required String activeUserId,
    required List<UserProfileModel> users,
  }) async {
    final raw = await _readRaw();
    final feedMap = _readUserMap(raw['feedByUserId']);
    final likedMap = _readUserMap(raw['likedByUserId']);
    feedMap[activeUserId] = List<UserProfileModel>.from(users);
    await _save(feedMap, likedMap);
  }

  Future<Map<String, dynamic>> _readRaw() async {
    final file = await _dbFile();
    if (!await file.exists()) {
      return {
        'feedByUserId': <String, dynamic>{},
        'likedByUserId': <String, dynamic>{},
      };
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return {
        'feedByUserId': <String, dynamic>{},
        'likedByUserId': <String, dynamic>{},
      };
    }

    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return {
        'feedByUserId': <String, dynamic>{},
        'likedByUserId': <String, dynamic>{},
      };
    }
    return decoded;
  }

  Map<String, List<UserProfileModel>> _readUserMap(dynamic data) {
    final result = <String, List<UserProfileModel>>{};
    if (data is! Map) {
      return result;
    }

    data.forEach((key, value) {
      if (key is! String || value is! List) {
        return;
      }
      final users = value
          .whereType<Map>()
          .map(
            (item) =>
                UserProfileModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
      result[key] = users;
    });

    return result;
  }

  Future<void> _save(
    Map<String, List<UserProfileModel>> feedMap,
    Map<String, List<UserProfileModel>> likedMap,
  ) async {
    final file = await _dbFile();
    final payload = {
      'feedByUserId': feedMap.map(
        (key, value) =>
            MapEntry(key, value.map((item) => item.toJson()).toList()),
      ),
      'likedByUserId': likedMap.map(
        (key, value) =>
            MapEntry(key, value.map((item) => item.toJson()).toList()),
      ),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await file.writeAsString(jsonEncode(payload));
  }
}
