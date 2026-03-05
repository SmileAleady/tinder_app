/// 欢迎跟我聊 - 聊天偏好模型（更新版）
class UserChatPreference {
  final String title; // 标题：欢迎跟我聊
  final String? goingOut; // 外出相关内容
  final String? myWeekend; // 我的周末相关内容
  final String? myPhone; // 我和我的手机相关内容

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
      goingOut: json['goingOut'] as String?,
      myWeekend: json['myWeekend'] as String?,
      myPhone: json['myPhone'] as String?,
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
  final bool hideAge; // 是否隐藏年龄
  final bool hideDistance; // 是否隐藏距离

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

/// 用户主数据模型
class UserProfileModel {
  final String id;
  final List<String?> mediaUrls; // 媒体图片URL列表
  bool smartPhotosEnabled; // 是否启用智能照片
  String aboutMe; // 关于我
  final UserChatPreference? chatPreference; // 新增：欢迎跟我聊 聊天偏好
  final List<UserPrompt> prompts; // 问答列表
  final List<String> interests; // 兴趣列表
  String relationshipGoal; // 交往目标
  int? height; // 身高
  final List<String> languages; // 会的语言
  final UserMoreInfo moreInfo; // 更多信息
  final UserLifestyle lifestyle; // 生活方式
  String? jobTitle; // 职位
  String? company; // 公司
  String? school; // 学校
  String? city; // 居住地
  String? favoriteSong; // 最爱歌曲
  String? spotifyArtist; // Spotify艺术家
  String gender; // 性别
  String sexualOrientation; // 性取向
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
      interests: List<String>.from(json['interests'] as List),
      relationshipGoal: json['relationshipGoal'] as String,
      height: json['height'] as int?,
      languages: List<String>.from(json['languages'] as List),
      moreInfo: UserMoreInfo.fromJson(json['moreInfo'] as Map<String, dynamic>),
      lifestyle: UserLifestyle.fromJson(
        json['lifestyle'] as Map<String, dynamic>,
      ),
      jobTitle: json['jobTitle'] as String?,
      company: json['company'] as String?,
      school: json['school'] as String?,
      city: json['city'] as String?,
      favoriteSong: json['favoriteSong'] as String?,
      spotifyArtist: json['spotifyArtist'] as String?,
      gender: json['gender'] as String,
      sexualOrientation: json['sexualOrientation'] as String,
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
    goingOut: "喜欢去城市周边短途旅行，偶尔去看演唱会",
    myWeekend: "周末通常会健身、看电影，偶尔和朋友聚餐",
    myPhone: "手机里最多的是音乐APP和拍照软件，每天使用约6小时",
  );

  // 构建完整用户信息示例
  final userProfileModel = UserProfileModel(
    id: "user_123456",
    mediaUrls: ["https://example.com/photo1.jpg"],
    smartPhotosEnabled: true,
    aboutMe: "一个热爱生活的人",
    chatPreference: chatPref, // 关联更新后的聊天偏好
    prompts: [UserPrompt(title: "关于我", content: "我喜欢旅行，喜欢看电影，喜欢听音乐，喜欢和朋友聚餐。")],
    interests: ["旅行", "阅读"],
    relationshipGoal: "寻找灵魂伴侣",
    height: 165,
    languages: ["中文"],
    moreInfo: UserMoreInfo(zodiac: "天秤座"),
    lifestyle: UserLifestyle(
      petPreference: "喜欢猫",
      drinking: "偶尔",
      smoking: "不吸烟",
      fitness: "每周3次",
    ),
    gender: "女",
    sexualOrientation: "异性恋",
    privacySettings: UserPrivacySettings(hideAge: false, hideDistance: true),
  );
  return userProfileModel;
  // // 转换为JSON并打印聊天偏好信息
  // final json = UserProfileModel.toJson();
  // print("外出：${json['chatPreference']['goingOut']}");
  // print("我的周末：${json['chatPreference']['myWeekend']}");
  // print("我和我的手机：${json['chatPreference']['myPhone']}");
}
