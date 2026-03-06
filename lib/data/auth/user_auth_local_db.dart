import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:tinder_app/model/user_profile_model.dart';

class UserAuthLocalDb {
  UserAuthLocalDb._();

  static final UserAuthLocalDb instance = UserAuthLocalDb._();

  static const String _dbFileName = 'user_profiles_db.json';

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_dbFileName');
  }

  Future<List<UserProfileModel>> getAllUsers() async {
    final data = await _readRaw();
    final list = data['users'] as List<dynamic>? ?? <dynamic>[];
    return list
        .map((item) => UserProfileModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<UserProfileModel?> getActiveUser() async {
    final users = await getAllUsers();
    for (final user in users) {
      if (user.isActive == true) {
        return user;
      }
    }
    return null;
  }

  Future<bool> emailExists(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await getAllUsers();
    return users.any(
      (item) => item.email.trim().toLowerCase() == normalizedEmail,
    );
  }

  Future<UserProfileModel?> findByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await getAllUsers();
    for (final user in users) {
      if (user.email.trim().toLowerCase() == normalizedEmail) {
        return user;
      }
    }
    return null;
  }

  Future<String> generateUniqueUserId() async {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final users = await getAllUsers();
    final existingIds = users.map((e) => e.userId).toSet();

    while (true) {
      final suffix = List<String>.generate(
        10,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
      final userId = 'user_$suffix';
      if (!existingIds.contains(userId)) {
        return userId;
      }
    }
  }

  Future<UserProfileModel> register({
    required String email,
    required String password,
  }) async {
    if (await emailExists(email)) {
      throw Exception('邮箱已注册');
    }

    final users = await getAllUsers();
    final userId = await generateUniqueUserId();

    for (final item in users) {
      item.isActive = false;
    }

    final user = UserProfileModel(
      userId: userId,
      email: email.trim().toLowerCase(),
      phone: '',
      password: password,
      nikeName: _buildNicknameFromEmail(email),
      mediaUrls: const [],
      smartPhotosEnabled: true,
      aboutMe: '',
      chatPreference: null,
      prompts: const [],
      interests: const [],
      relationshipGoal: const UserRelationshipGoalItem(
        id: 0,
        title: '新用户',
        emoji: '✨',
      ),
      height: null,
      languages: const [],
      moreInfo: UserMoreInfo(),
      lifestyle: UserLifestyle(
        petPreference: '',
        drinking: '',
        smoking: '',
        fitness: '',
      ),
      jobTitle: null,
      company: null,
      school: null,
      city: null,
      favoriteSong: null,
      spotifyArtist: null,
      gender: const [],
      sexualOrientation: const [],
      privacySettings: UserPrivacySettings(hideAge: false, hideDistance: false),
      age: null,
      distance: null,
      isActive: true,
    );

    users.add(user);
    await _saveUsers(users);
    return user;
  }

  Future<UserProfileModel?> login({
    required String email,
    required String password,
  }) async {
    final users = await getAllUsers();
    final normalizedEmail = email.trim().toLowerCase();

    UserProfileModel? matched;
    for (final user in users) {
      if (user.email.trim().toLowerCase() == normalizedEmail) {
        matched = user;
      }
      user.isActive = false;
    }

    if (matched == null) {
      return null;
    }

    if (matched.password != password) {
      await _saveUsers(users);
      return null;
    }

    matched.isActive = true;
    await _saveUsers(users);
    return matched;
  }

  Future<void> logout() async {
    final users = await getAllUsers();
    for (final user in users) {
      user.isActive = false;
    }
    await _saveUsers(users);
  }

  Future<UserProfileModel?> findByUserId(String userId) async {
    final users = await getAllUsers();
    for (final user in users) {
      if (user.userId == userId) {
        return user;
      }
    }
    return null;
  }

  Future<void> upsertUser(
    UserProfileModel profile, {
    bool keepActive = false,
  }) async {
    final users = await getAllUsers();
    final index = users.indexWhere((u) => u.userId == profile.userId);
    if (index >= 0) {
      users[index] = profile;
    } else {
      users.add(profile);
    }

    if (keepActive) {
      for (final user in users) {
        user.isActive = user.userId == profile.userId;
      }
    }

    await _saveUsers(users);
  }

  Future<void> deleteUserById(String userId) async {
    final users = await getAllUsers();
    users.removeWhere((u) => u.userId == userId);
    await _saveUsers(users);
  }

  Future<Map<String, dynamic>> _readRaw() async {
    final file = await _dbFile();
    if (!await file.exists()) {
      return {'users': <Map<String, dynamic>>[]};
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return {'users': <Map<String, dynamic>>[]};
    }

    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return {'users': <Map<String, dynamic>>[]};
    }

    return decoded;
  }

  Future<void> _saveUsers(List<UserProfileModel> users) async {
    final file = await _dbFile();
    final payload = {
      'users': users.map((item) => item.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await file.writeAsString(jsonEncode(payload));
  }

  String _buildNicknameFromEmail(String email) {
    final normalized = email.trim();
    final index = normalized.indexOf('@');
    if (index <= 0) {
      return '新用户';
    }
    return normalized.substring(0, index);
  }
}
