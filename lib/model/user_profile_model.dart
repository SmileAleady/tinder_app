/// 欢迎跟我聊 - 聊天偏好模型（更新版）
class UserChatPreference {
  final String title; // 标题：欢迎跟我聊
  List<String>? goingOut; // 外出相关内容
  List<String>? myWeekend; // 我的周末相关内容
  List<String>? myPhone; // 我和我的手机相关内容

  UserChatPreference({
    required this.title,
    this.goingOut,
    this.myWeekend,
    this.myPhone,
  });

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'goingOut': goingOut,
      'myWeekend': myWeekend,
      'myPhone': myPhone,
    };
  }

  // 从JSON解析
  factory UserChatPreference.fromJson(Map<String, dynamic> json) {
    return UserChatPreference(
      title: json['title'] as String,
      goingOut: json['goingOut'] != null
          ? json['goingOut'].map((e) => e as String).toList()
          : [],
      myWeekend: json['myWeekend'] != null
          ? json['myWeekend'].map((e) => e as String).toList()
          : [],
      myPhone: json['myPhone'] != null
          ? json['myPhone'].map((e) => e as String).toList()
          : [],
    );
  }
}

/// 用户生活方式信息
class UserLifestyle {
  final String petPreference; // 宠物喜好
  final String drinking; // 饮酒情况
  final String smoking; // 吸烟频率
  final String fitness; // 健身情况
  final String? socialMediaActivity; // 社交媒体活跃度

  UserLifestyle({
    required this.petPreference,
    required this.drinking,
    required this.smoking,
    required this.fitness,
    this.socialMediaActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'petPreference': petPreference,
      'drinking': drinking,
      'smoking': smoking,
      'fitness': fitness,
      'socialMediaActivity': socialMediaActivity,
    };
  }

  factory UserLifestyle.fromJson(Map<String, dynamic> json) {
    return UserLifestyle(
      petPreference: json['petPreference'] as String,
      drinking: json['drinking'] as String,
      smoking: json['smoking'] as String,
      fitness: json['fitness'] as String,
      socialMediaActivity: json['socialMediaActivity'] as String?,
    );
  }
}

/// 用户问答信息
class UserPrompt {
  String title; // 问答类型（如外出、周末等）
  String? content; // 回答内容

  UserPrompt({required this.title, this.content});

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }

  factory UserPrompt.fromJson(Map<String, dynamic> json) {
    return UserPrompt(
      title: json['title'] as String,
      content: json['content'] as String?,
    );
  }
}

/// 交友目标

class UserRelationshipGoalItem {
  final int id;
  final String title;
  final String emoji;

  const UserRelationshipGoalItem({
    required this.id,
    required this.title,
    required this.emoji,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'emoji': emoji, 'id': id};
  }

  factory UserRelationshipGoalItem.fromJson(Map<String, dynamic> json) {
    return UserRelationshipGoalItem(
      id: json['id'] as int,
      title: json['title'] as String,
      emoji: json['emoji'] as String,
    );
  }
}

/// 用户更多信息
class UserMoreInfo {
  final String? zodiac; // 星座
  final String? education; // 教育情况
  final String? familyPlan; // 家庭计划
  final String? communicationStyle; // 沟通风格
  final String? loveLanguage; // 爱的方式

  UserMoreInfo({
    this.zodiac,
    this.education,
    this.familyPlan,
    this.communicationStyle,
    this.loveLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'zodiac': zodiac,
      'education': education,
      'familyPlan': familyPlan,
      'communicationStyle': communicationStyle,
      'loveLanguage': loveLanguage,
    };
  }

  factory UserMoreInfo.fromJson(Map<String, dynamic> json) {
    return UserMoreInfo(
      zodiac: json['zodiac'] as String?,
      education: json['education'] as String?,
      familyPlan: json['familyPlan'] as String?,
      communicationStyle: json['communicationStyle'] as String?,
      loveLanguage: json['loveLanguage'] as String?,
    );
  }
}

/// 用户隐私设置
class UserPrivacySettings {
  bool hideAge; // 是否隐藏年龄
  bool hideDistance; // 是否隐藏距离

  UserPrivacySettings({required this.hideAge, required this.hideDistance});

  Map<String, dynamic> toJson() {
    return {'hideAge': hideAge, 'hideDistance': hideDistance};
  }

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) {
    return UserPrivacySettings(
      hideAge: json['hideAge'] as bool,
      hideDistance: json['hideDistance'] as bool,
    );
  }
}

/// 身高单位枚举
enum HeightUnit {
  /// 英尺/英寸
  feetInch,

  /// 厘米
  cm,
}

class UserHeightModel {
  /// 初始选中的单位
  HeightUnit? unit;

  /// 初始厘米值（cm模式下）
  double? cm;

  /// 初始英尺值（英尺/英寸模式下）
  int? feet;

  /// 初始英寸值（英尺/英寸模式下）
  int? inch;
  UserHeightModel({this.unit = HeightUnit.cm, this.cm, this.feet, this.inch});
  Map<String, dynamic> toJson() {
    return {'unit': unit.toString(), 'cm': cm, 'feet': feet, 'inch': inch};
  }

  factory UserHeightModel.fromJson(Map<String, dynamic> json) {
    return UserHeightModel(
      unit: HeightUnit.values.firstWhere(
        (element) => element.toString() == json['unit'],
      ),
      cm: json['cm'] as double?,
      feet: json['feet'] as int?,
      inch: json['inch'] as int?,
    );
  }
}

/// 语言数据模型
class UserLanguage {
  final String id;
  final String name;

  const UserLanguage({required this.id, required this.name});
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory UserLanguage.fromJson(Map<String, dynamic> json) {
    return UserLanguage(id: json['id'] as String, name: json['name'] as String);
  }
}

/// 兴趣数据模型
class UserInterest {
  final String id;
  final String name;

  const UserInterest({required this.id, required this.name});
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory UserInterest.fromJson(Map<String, dynamic> json) {
    return UserInterest(id: json['id'] as String, name: json['name'] as String);
  }
}

// 音乐模型
class MusicModel {
  final String title;
  final String artist;
  final String? coverImageUrl;

  MusicModel({required this.title, required this.artist, this.coverImageUrl});
  Map<String, dynamic> toJson() {
    return {'title': title, 'artist': artist, 'coverImageUrl': coverImageUrl};
  }

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }
}

// 性别
class GenderModel {
  final String id; // 唯一标识（用于匹配和回显）
  final String name; // 性别名称
  final String? desc; // 可选描述信息
  final bool isVisible; // 是否在个人资料中可见

  const GenderModel({
    required this.id,
    required this.name,
    this.desc,
    this.isVisible = false,
  });
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'desc': desc, 'isVisible': isVisible};
  }

  factory GenderModel.fromJson(Map<String, dynamic> json) {
    return GenderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String?,
      isVisible: json['isVisible'] as bool,
    );
  }

  // 复制方法（用于扩展/修改字段）
  GenderModel copyWith({
    String? id,
    String? name,
    String? desc,
    bool? isVisible,
  }) {
    return GenderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

// 性向模型
class SexualOrientationModel {
  final String id; // 唯一标识（用于匹配和回显）
  final String name; // 性向名称
  final String desc; // 性向描述
  final bool isVisible; // 是否在个人资料中可见

  const SexualOrientationModel({
    required this.id,
    required this.name,
    required this.desc,
    this.isVisible = false, // 默认隐藏，与截图一致
  });
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'desc': desc, 'isVisible': isVisible};
  }

  factory SexualOrientationModel.fromJson(Map<String, dynamic> json) {
    return SexualOrientationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      isVisible: json['isVisible'] as bool,
    );
  }

  // 复制方法（用于扩展/修改字段）
  SexualOrientationModel copyWith({
    String? id,
    String? name,
    String? desc,
    bool? isVisible,
  }) {
    return SexualOrientationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

/// 用户主数据模型
class UserProfileModel {
  final String id;
  final List<String?> mediaUrls; // 媒体图片URL列表
  bool smartPhotosEnabled; // 是否启用智能照片
  String aboutMe; // 关于我
  final UserChatPreference? chatPreference; // 新增：欢迎跟我聊 聊天偏好
  final List<UserPrompt> prompts; // 问答列表
  List<UserInterest> interests; // 兴趣列表
  UserRelationshipGoalItem? relationshipGoal; // 交往目标
  UserHeightModel? height; // 身高
  List<UserLanguage> languages; // 会的语言
  final UserMoreInfo moreInfo; // 更多信息
  final UserLifestyle lifestyle; // 生活方式
  String? jobTitle; // 职位
  String? company; // 公司
  String? school; // 学校
  String? city; // 居住地
  MusicModel? favoriteSong; // 最爱歌曲
  String? spotifyArtist; // Spotify艺术家
  List<GenderModel>? gender; // 性别
  List<SexualOrientationModel>? sexualOrientation; // 性取向
  final UserPrivacySettings privacySettings; // 隐私设置

  UserProfileModel({
    required this.id,
    required this.mediaUrls,
    required this.smartPhotosEnabled,
    required this.aboutMe,
    this.chatPreference, // 聊天偏好参数
    required this.prompts,
    required this.interests,
    required this.relationshipGoal,
    this.height,
    required this.languages,
    required this.moreInfo,
    required this.lifestyle,
    this.jobTitle,
    this.company,
    this.school,
    this.city,
    this.favoriteSong,
    this.spotifyArtist,
    required this.gender,
    required this.sexualOrientation,
    required this.privacySettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mediaUrls': mediaUrls,
      'smartPhotosEnabled': smartPhotosEnabled,
      'aboutMe': aboutMe,
      'chatPreference': chatPreference?.toJson(), // 聊天偏好JSON转换
      'prompts': prompts.map((p) => p.toJson()).toList(),
      'interests': interests,
      'relationshipGoal': relationshipGoal,
      'height': height,
      'languages': languages,
      'moreInfo': moreInfo.toJson(),
      'lifestyle': lifestyle.toJson(),
      'jobTitle': jobTitle,
      'company': company,
      'school': school,
      'city': city,
      'favoriteSong': favoriteSong,
      'spotifyArtist': spotifyArtist,
      'gender': gender,
      'sexualOrientation': sexualOrientation,
      'privacySettings': privacySettings.toJson(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      mediaUrls: List<String>.from(json['mediaUrls'] as List),
      smartPhotosEnabled: json['smartPhotosEnabled'] as bool,
      aboutMe: json['aboutMe'] as String,
      // 解析聊天偏好
      chatPreference: json['chatPreference'] != null
          ? UserChatPreference.fromJson(
              json['chatPreference'] as Map<String, dynamic>,
            )
          : null,
      prompts: (json['prompts'] as List)
          .map((i) => UserPrompt.fromJson(i as Map<String, dynamic>))
          .toList(),
      interests: (json['interests'] as List)
          .map((i) => UserInterest.fromJson(i as Map<String, dynamic>))
          .toList(),
      relationshipGoal: UserRelationshipGoalItem.fromJson(
        json['relationshipGoal'] as Map<String, dynamic>,
      ),
      height: json['height'] != null
          ? UserHeightModel.fromJson(json['height'] as Map<String, dynamic>)
          : null,
      languages: (json['languages'] as List)
          .map((i) => UserLanguage.fromJson(i as Map<String, dynamic>))
          .toList(),
      moreInfo: UserMoreInfo.fromJson(json['moreInfo'] as Map<String, dynamic>),
      lifestyle: UserLifestyle.fromJson(
        json['lifestyle'] as Map<String, dynamic>,
      ),
      jobTitle: json['jobTitle'] as String?,
      company: json['company'] as String?,
      school: json['school'] as String?,
      city: json['city'] as String?,
      favoriteSong: json['favoriteSong'] != null
          ? MusicModel.fromJson(json['favoriteSong'] as Map<String, dynamic>)
          : null,
      spotifyArtist: json['spotifyArtist'] as String?,
      gender: (json['gender'] as List)
          .map((i) => GenderModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      sexualOrientation: (json['sexualOrientation'] as List)
          .map(
            (i) => SexualOrientationModel.fromJson(i as Map<String, dynamic>),
          )
          .toList(),
      privacySettings: UserPrivacySettings.fromJson(
        json['privacySettings'] as Map<String, dynamic>,
      ),
    );
  }
}

// 示例使用
UserProfileModel getUserProfileModel() {
  // 构建聊天偏好示例（更新后的结构）
  final chatPref = UserChatPreference(
    title: "欢迎跟我聊",
    goingOut: [],
    myWeekend: [],
    myPhone: [],
  );

  // 构建完整用户信息示例
  final userProfileModel = UserProfileModel(
    id: "user_123456",
    mediaUrls: ["https://example.com/photo1.jpg"],
    smartPhotosEnabled: true,
    aboutMe: "一个热爱生活的人",
    chatPreference: chatPref, // 关联更新后的聊天偏好
    prompts: [UserPrompt(title: "关于我", content: "我喜欢旅行，喜欢看电影，喜欢听音乐，喜欢和朋友聚餐。")],
    interests: [
      UserInterest(id: "travel", name: "旅行"),
      UserInterest(id: "reading", name: "阅读"),
    ],
    relationshipGoal: UserRelationshipGoalItem(id: 1, title: "交友", emoji: "🤝"),
    height: UserHeightModel(unit: HeightUnit.cm, cm: 165.0),
    languages: [UserLanguage(id: "zh", name: "中文")],
    moreInfo: UserMoreInfo(zodiac: "天秤座"),
    lifestyle: UserLifestyle(
      petPreference: "喜欢猫",
      drinking: "偶尔",
      smoking: "不吸烟",
      fitness: "每周3次",
    ),
    gender: [GenderModel(id: 'male', name: '男性')],
    sexualOrientation: [
      SexualOrientationModel(id: 'heterosexual', name: '异性恋', desc: '对异性有吸引力'),
    ],
    privacySettings: UserPrivacySettings(hideAge: false, hideDistance: true),
  );
  return userProfileModel;
  // // 转换为JSON并打印聊天偏好信息
  // final json = UserProfileModel.toJson();
  // print("外出：${json['chatPreference']['goingOut']}");
  // print("我的周末：${json['chatPreference']['myWeekend']}");
  // print("我和我的手机：${json['chatPreference']['myPhone']}");
}
