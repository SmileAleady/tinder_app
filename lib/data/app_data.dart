import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// 选项类型枚举（对应11张图的分类）
enum SheetOptionType {
  constellation, // 星座
  education, // 教育情况
  petPreference, // 宠物喜好
  smoking, // 吸烟情况
  drinking, // 饮酒情况
  jobStatus, // 工作状态
  income, // 收入水平
  residence, // 居住情况
  car, // 车辆情况
  relationshipStatus, // 婚恋状态
  socialMediaActivity, // 社交媒体活跃度
  fitness, // 锻炼情况
  wantChildren, // 生育计划
  communicationStyle, // 沟通方式
  loveLanguage, // 爱的方式
  //
  goOut,
  weekend,
  phoneUsage,
}

/// 通用选项数据模型
class OptionItem {
  final String id;
  final String title;

  const OptionItem({required this.id, required this.title});
}

/// 选项配置模型
class OptionConfig {
  final String title;
  final String hintText;
  final String question;
  final List<OptionItem> options;

  const OptionConfig({
    required this.title,
    required this.hintText,
    required this.question,
    required this.options,
  });
}

/// 全局选项数据管理类
class OptionDataManager {
  static final List<SexualOrientationModel> sexualOrientations = [
    const SexualOrientationModel(
      id: 'heterosexual',
      name: '异性恋',
      desc: '仅会被相反性别吸引的人士',
    ),
    const SexualOrientationModel(
      id: 'gay',
      name: '男同性恋',
      desc: '这是一个统称术语，指会被同性吸引的人士',
    ),
    const SexualOrientationModel(
      id: 'lesbian',
      name: '女同性恋',
      desc: '对其他女性产生爱慕感、能建立浪漫关系或认为其他女性具有性吸引力的女士',
    ),
    const SexualOrientationModel(
      id: 'bisexual',
      name: '双性恋',
      desc: '对一种以上的性别者有可能产生爱慕感、建立浪漫关系或认为这些性别者具有性吸引力的人士',
    ),
    const SexualOrientationModel(
      id: 'asexual',
      name: '无性恋',
      desc: '感受不到性吸引力的人士',
    ),
    const SexualOrientationModel(
      id: 'demisexual',
      name: '半性恋',
      desc: '只有与他人建立深厚的情感联系才能感受到性吸引力的人士',
    ),
    const SexualOrientationModel(
      id: 'pansexual',
      name: '泛性恋',
      desc: '对任意性别者均有可能产生爱慕感、建立浪漫关系或认为任意性别者均具有性吸引力的人士',
    ),
    const SexualOrientationModel(
      id: 'queer',
      name: '酷儿',
      desc: '这是一个用于指代一系列性向和性别的统称，它往往涵盖不属于完全异性恋的性别或性向',
    ),
    const SexualOrientationModel(
      id: 'questioning',
      name: '疑性恋',
      desc: '正在探索自身性向和/或性别的人士',
    ),
    const SexualOrientationModel(
      id: 'other',
      name: '未列出',
      desc: '请告知我们还缺什么性别。',
    ),
  ];

  // 初始化性别选项（与参考图一致）
  static final List<GenderModel> genders = [
    const GenderModel(id: 'male', name: '男性'),
    const GenderModel(id: 'female', name: '女性'),
    const GenderModel(id: 'non_binary', name: '二元性别以外', desc: '包含跨性别、非二元性别等'),
  ];

  static final List<MusicModel> songs = [
    MusicModel(
      title: "Risk It All",
      artist: "Bruno Mars",
      coverImageUrl: "https://example.com/cover1.jpg",
    ),
    MusicModel(
      title: "Stateside + Zara Larsson",
      artist: "PinkPantheress",
      coverImageUrl: "https://example.com/cover2.jpg",
    ),
    MusicModel(
      title: "Choosin' Texas",
      artist: "Ella Langley",
      coverImageUrl: "https://example.com/cover3.jpg",
    ),
    MusicModel(
      title: "I Just Might",
      artist: "Bruno Mars",
      coverImageUrl: "https://example.com/cover4.jpg",
    ),
    MusicModel(
      title: "DtMF",
      artist: "Bad Bunny",
      coverImageUrl: "https://example.com/cover5.jpg",
    ),
    MusicModel(
      title: "Man I Need",
      artist: "Olivia Dean",
      coverImageUrl: "https://example.com/cover6.jpg",
    ),
    MusicModel(
      title: "Babydoll",
      artist: "Dominic Fike",
      coverImageUrl: "https://example.com/cover7.jpg",
    ),
    MusicModel(
      title: "E85",
      artist: "Don Toliver",
      coverImageUrl: "https://example.com/cover8.jpg",
    ),
    MusicModel(
      title: "So Easy (To Fall In Love)",
      artist: "Olivia Dean",
      coverImageUrl: "https://example.com/cover9.jpg",
    ),
  ];

  // 枚举 -> 配置映射表
  static const Map<SheetOptionType, OptionConfig> _optionConfigs = {
    // 1. 星座
    SheetOptionType.constellation: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你是什么星座?',
      options: [
        OptionItem(id: 'capricorn', title: '摩羯座'),
        OptionItem(id: 'aquarius', title: '水瓶座'),
        OptionItem(id: 'pisces', title: '双鱼座'),
        OptionItem(id: 'aries', title: '白羊座'),
        OptionItem(id: 'taurus', title: '金牛座'),
        OptionItem(id: 'gemini', title: '双子座'),
        OptionItem(id: 'cancer', title: '巨蟹座'),
        OptionItem(id: 'leo', title: '狮子座'),
        OptionItem(id: 'virgo', title: '处女座'),
        OptionItem(id: 'libra', title: '天秤座'),
        OptionItem(id: 'scorpio', title: '天蝎座'),
        OptionItem(id: 'sagittarius', title: '射手座'),
      ],
    ),

    // 2. 教育情况
    SheetOptionType.education: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你的教育情况是?',
      options: [
        OptionItem(id: 'high_school', title: '高中/中专及以下'),
        OptionItem(id: 'college', title: '大专'),
        OptionItem(id: 'bachelor', title: '本科'),
        OptionItem(id: 'master', title: '硕士'),
        OptionItem(id: 'doctor', title: '博士及以上'),
        OptionItem(id: 'prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 3. 宠物喜好
    SheetOptionType.petPreference: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你对宠物的喜好是?',
      options: [
        OptionItem(id: 'love_pets', title: '喜欢宠物，自己也养'),
        OptionItem(id: 'like_pets_no_keep', title: '喜欢宠物，但自己不养'),
        OptionItem(id: 'neutral_pets', title: '对宠物无感'),
        OptionItem(id: 'dislike_pets', title: '不喜欢宠物'),
        OptionItem(id: 'allergic_pets', title: '对宠物过敏'),
      ],
    ),

    // 4. 吸烟情况
    SheetOptionType.smoking: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你吸烟吗?',
      options: [
        OptionItem(id: 'smoke_often', title: '经常'),
        OptionItem(id: 'smoke_sometimes', title: '偶尔'),
        OptionItem(id: 'smoke_never', title: '从不'),
        OptionItem(id: 'smoke_quit', title: '已戒烟'),
        OptionItem(id: 'smoke_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 5. 饮酒情况
    SheetOptionType.drinking: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你饮酒吗?',
      options: [
        OptionItem(id: 'drink_often', title: '经常'),
        OptionItem(id: 'drink_sometimes', title: '社交场合偶尔'),
        OptionItem(id: 'drink_rarely', title: '很少'),
        OptionItem(id: 'drink_never', title: '从不'),
        OptionItem(id: 'drink_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 6. 工作状态
    SheetOptionType.jobStatus: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你的工作状态是?',
      options: [
        OptionItem(id: 'job_full_time', title: '全职'),
        OptionItem(id: 'job_part_time', title: '兼职'),
        OptionItem(id: 'job_self_employed', title: '自由职业'),
        OptionItem(id: 'job_student', title: '学生'),
        OptionItem(id: 'job_unemployed', title: '待业'),
        OptionItem(id: 'job_retired', title: '退休'),
        OptionItem(id: 'job_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 7. 收入水平
    SheetOptionType.income: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你的收入水平是?',
      options: [
        OptionItem(id: 'income_10k_below', title: '10k以下'),
        OptionItem(id: 'income_10k_20k', title: '10k-20k'),
        OptionItem(id: 'income_20k_30k', title: '20k-30k'),
        OptionItem(id: 'income_30k_50k', title: '30k-50k'),
        OptionItem(id: 'income_50k_100k', title: '50k-100k'),
        OptionItem(id: 'income_100k_above', title: '100k以上'),
        OptionItem(id: 'income_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 8. 居住情况
    SheetOptionType.residence: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你的居住情况是?',
      options: [
        OptionItem(id: 'residence_own', title: '自有住房'),
        OptionItem(id: 'residence_rent', title: '租房'),
        OptionItem(id: 'residence_with_parents', title: '与父母同住'),
        OptionItem(id: 'residence_other', title: '其他'),
        OptionItem(id: 'residence_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 9. 车辆情况
    SheetOptionType.car: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你有车吗?',
      options: [
        OptionItem(id: 'car_yes', title: '有'),
        OptionItem(id: 'car_no', title: '没有'),
        OptionItem(id: 'car_planning', title: '计划购买'),
        OptionItem(id: 'car_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 10. 婚恋状态
    SheetOptionType.relationshipStatus: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你的婚恋状态是?',
      options: [
        OptionItem(id: 'relationship_single', title: '单身'),
        OptionItem(id: 'relationship_casual', title: '暧昧中'),
        OptionItem(id: 'relationship_dating', title: '恋爱中'),
        OptionItem(id: 'relationship_engaged', title: '订婚'),
        OptionItem(id: 'relationship_married', title: '已婚'),
        OptionItem(id: 'relationship_divorced', title: '离异'),
        OptionItem(id: 'relationship_widowed', title: '丧偶'),
        OptionItem(id: 'relationship_prefer_not_say', title: '不愿透露'),
      ],
    ),

    // 11. 社交媒体活跃度
    SheetOptionType.socialMediaActivity: OptionConfig(
      title: '生活方式',
      hintText: '添加你的生活方式，展现出自己最好的一面。',
      question: '你在社交媒体上有多活跃?',
      options: [
        OptionItem(id: 'social_status', title: '社交状态'),
        OptionItem(id: 'social_active', title: '社交活跃'),
        OptionItem(id: 'not_online_often', title: '不常上网'),
        OptionItem(id: 'lurk', title: '潜水'),
      ],
    ),

    // 5. 锻炼情况 (你锻炼吗?)
    SheetOptionType.fitness: OptionConfig(
      title: '生活方式',
      hintText: '添加你的生活方式，展现出自己最好的一面。',
      question: '你锻炼吗?',
      options: [
        OptionItem(id: 'every_day', title: '每天'),
        OptionItem(id: 'often', title: '时常'),
        OptionItem(id: 'occasionally', title: '偶尔'),
        OptionItem(id: 'never', title: '从不'),
      ],
    ),

    // 6. 生育计划 (你想要孩子吗?)
    SheetOptionType.wantChildren: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你想要孩子吗?',
      options: [
        OptionItem(id: 'want', title: '我想要孩子'),
        OptionItem(id: 'dont_want', title: '我不想要孩子'),
        OptionItem(id: 'have_and_more', title: '我有孩子，我还想继续生'),
        OptionItem(id: 'have_and_stop', title: '我有孩子，我不想再生了'),
        OptionItem(id: 'unsure', title: '还不确定'),
      ],
    ),

    // 7. 沟通方式 (你喜欢的沟通方式是?)
    SheetOptionType.communicationStyle: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你喜欢的沟通方式是?',
      options: [
        OptionItem(id: 'active_msg', title: '热衷发消息'),
        OptionItem(id: 'call', title: '喜欢打电话'),
        OptionItem(id: 'video_call', title: '喜欢视频聊天'),
        OptionItem(id: 'not_active_msg', title: '不热衷发消息'),
        OptionItem(id: 'in_person', title: '最好当面'),
      ],
    ),

    // 8. 爱的方式 (你通过什么方式来感受爱?)
    SheetOptionType.loveLanguage: OptionConfig(
      title: '我的更多信息',
      hintText: '添加有关你的更多信息，展现出自己最好的一面。',
      question: '你通过什么方式来感受爱?',
      options: [
        OptionItem(id: 'caring', title: '体贴的表示'),
        OptionItem(id: 'gifts', title: '礼物'),
        OptionItem(id: 'touch', title: '身体碰触'),
        OptionItem(id: 'praise', title: '赞美'),
        OptionItem(id: 'time', title: '共度时光'),
      ],
    ),
  };

  /// 根据枚举值获取对应的配置
  static OptionConfig getConfig(SheetOptionType type) {
    return _optionConfigs[type]!;
  }

  //界面
  // 更多信息项
  static final List<ProfileItem> moreItems = [
    ProfileItem(
      icon: Icons.nights_stay,
      label: '星座',
      value: '空',
      optionType: SheetOptionType.constellation,
    ),
    ProfileItem(
      icon: Icons.school,
      label: '教育情况',
      value: '空',
      optionType: SheetOptionType.education,
    ),
    ProfileItem(
      icon: Icons.family_restroom,
      label: '家庭计划',
      value: '空',
      optionType: SheetOptionType.wantChildren,
    ),
    ProfileItem(
      icon: Icons.chat,
      label: '沟通风格',
      value: '空',
      optionType: SheetOptionType.communicationStyle,
    ),
    ProfileItem(
      icon: Icons.favorite,
      label: '爱的方式',
      value: '空',
      optionType: SheetOptionType.loveLanguage,
    ),
  ];

  // 生活方式项
  static final List<ProfileItem> lifestyleItems = [
    ProfileItem(
      icon: Icons.pets,
      label: '宠物喜好',
      value: '鱼类',
      optionType: SheetOptionType.petPreference,
    ),
    ProfileItem(
      icon: Icons.local_bar,
      label: '饮酒',
      value: '少喝或不喝',
      optionType: SheetOptionType.drinking,
    ),
    ProfileItem(
      icon: Icons.smoke_free,
      label: '你多久抽一次烟?',
      value: '不吸烟',
      optionType: SheetOptionType.smoking,
    ),
    ProfileItem(
      icon: Icons.fitness_center,
      label: '健身情况',
      value: '每天',
      optionType: SheetOptionType.fitness,
    ),
    ProfileItem(
      icon: Icons.alternate_email,
      label: '社交媒体活跃度',
      value: '空',
      optionType: SheetOptionType.socialMediaActivity,
    ),
  ];
  // 欢迎聊天项
  static final List<ProfileItem> welcomeChatItems = [
    ProfileItem(
      icon: Icons.nights_stay,
      label: '外出',
      value: '正在跳舞, 盛装打扮, ...',
      optionType: SheetOptionType.goOut,
    ),
    ProfileItem(
      icon: Icons.weekend,
      label: '我的周末',
      value: '添加问答',
      optionType: SheetOptionType.weekend,
    ),
    ProfileItem(
      icon: Icons.phone_iphone,
      label: '我和我的手机',
      value: '添加问答',
      optionType: SheetOptionType.phoneUsage,
    ),
  ];

  /// 用户
  static List<UserProfileModel> getUserList() {
    var json = [
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_001",
        "email": "alice@example.com",
        "phone": "13800138000",
        "password": "encrypted_123",
        "nikeName": "Alice的小世界",
        "mediaUrls": [
          "https://example.com/photo1.jpg",
          "https://example.com/photo2.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "热爱旅行和美食，喜欢探索未知的世界",
        "chatPreference": {
          "title": "欢迎跟我聊旅行",
          "goingOut": ["徒步", "露营", "自驾游"],
          "myWeekend": ["探店", "看展", "和朋友小聚"],
          "myPhone": ["刷旅行攻略", "拍照", "听播客"],
        },
        "prompts": [
          {"title": "外出", "content": "最喜欢去海边城市，吹海风吃海鲜"},
          {"title": "周末", "content": "周末喜欢去城市周边的小众景点"},
        ],
        "interests": [
          {"id": "interest_001", "name": "旅行"},
          {"id": "interest_002", "name": "美食"},
          {"id": "interest_003", "name": "摄影"},
        ],
        "relationshipGoal": {"id": 1, "title": "寻找灵魂伴侣", "emoji": "❤️"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 165.5,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
        ],
        "moreInfo": {
          "zodiac": "天秤座",
          "education": "本科",
          "familyPlan": "3年内考虑结婚",
          "communicationStyle": "直接坦率",
          "loveLanguage": "陪伴和礼物",
        },
        "lifestyle": {
          "petPreference": "喜欢猫",
          "drinking": "偶尔喝红酒",
          "smoking": "不吸烟",
          "fitness": "每周健身3次",
          "socialMediaActivity": "每天刷30分钟",
        },
        "jobTitle": "产品经理",
        "company": "互联网科技公司",
        "school": "北京邮电大学",
        "city": "北京市",
        "favoriteSong": {
          "title": "旅行的意义",
          "artist": "陈绮贞",
          "coverImageUrl": "https://example.com/song1.jpg",
        },
        "spotifyArtist": "Taylor Swift",
        "gender": [
          {"id": "gender_001", "name": "女", "desc": "女性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_002",
        "email": "bob@example.com",
        "phone": "13900139000",
        "password": "encrypted_456",
        "nikeName": "Bob的健身日常",
        "mediaUrls": ["https://example.com/photo3.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "健身教练，热爱运动，追求健康生活",
        "chatPreference": {
          "title": "欢迎跟我聊健身",
          "goingOut": ["健身房", "跑步", "打篮球"],
          "myWeekend": ["私教课", "户外训练", "看比赛"],
          "myPhone": ["看健身教程", "记录训练数据", "听健身播客"],
        },
        "prompts": [
          {"title": "健身", "content": "每周5次训练，专注增肌和核心"},
        ],
        "interests": [
          {"id": "interest_004", "name": "健身"},
          {"id": "interest_005", "name": "篮球"},
          {"id": "interest_006", "name": "营养"},
        ],
        "relationshipGoal": {"id": 2, "title": "结交运动伙伴", "emoji": "🏋️"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 1,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_003", "name": "西班牙语"},
        ],
        "moreInfo": {
          "zodiac": "白羊座",
          "education": "大专",
          "familyPlan": "暂无计划",
          "communicationStyle": "热情直接",
          "loveLanguage": "行动和鼓励",
        },
        "lifestyle": {
          "petPreference": "喜欢狗",
          "drinking": "从不喝酒",
          "smoking": "偶尔吸烟",
          "fitness": "每天健身",
          "socialMediaActivity": "每天刷1小时",
        },
        "jobTitle": "健身教练",
        "company": "金仕堡健身中心",
        "school": "上海体育学院",
        "city": "上海市",
        "favoriteSong": {
          "title": "Stronger",
          "artist": "Kanye West",
          "coverImageUrl": "https://example.com/song2.jpg",
        },
        "spotifyArtist": "Eminem",
        "gender": [
          {"id": "gender_002", "name": "男", "desc": "男性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_003",
        "email": "charlie@example.com",
        "phone": "13700137000",
        "password": "encrypted_789",
        "nikeName": "Charlie的书斋",
        "mediaUrls": [
          "https://example.com/photo4.jpg",
          "https://example.com/photo5.jpg",
          "https://example.com/photo6.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "文学爱好者，兼职作家，喜欢安静的时光",
        "chatPreference": {
          "title": "欢迎跟我聊书籍",
          "goingOut": ["图书馆", "书店", "文学沙龙"],
          "myWeekend": ["写作", "阅读", "喝茶"],
          "myPhone": ["看电子书", "写随笔", "听有声书"],
        },
        "prompts": [
          {"title": "周末", "content": "周末通常宅家阅读，每月参加一次文学沙龙"},
        ],
        "interests": [
          {"id": "interest_007", "name": "阅读"},
          {"id": "interest_008", "name": "写作"},
          {"id": "interest_009", "name": "茶道"},
        ],
        "relationshipGoal": {"id": 3, "title": "寻找聊得来的朋友", "emoji": "📚"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 178.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_004", "name": "日语"},
          {"id": "lang_005", "name": "法语"},
        ],
        "moreInfo": {
          "zodiac": "处女座",
          "education": "硕士",
          "familyPlan": "5年内考虑",
          "communicationStyle": "温和耐心",
          "loveLanguage": "倾听和理解",
        },
        "lifestyle": {
          "petPreference": "喜欢仓鼠",
          "drinking": "偶尔喝清茶",
          "smoking": "不吸烟",
          "fitness": "每周散步2次",
          "socialMediaActivity": "每天刷15分钟",
        },
        "jobTitle": "自由撰稿人",
        "company": null,
        "school": "南京大学",
        "city": "南京市",
        "favoriteSong": {
          "title": "平凡之路",
          "artist": "朴树",
          "coverImageUrl": "https://example.com/song3.jpg",
        },
        "spotifyArtist": "李健",
        "gender": [
          {"id": "gender_002", "name": "男", "desc": "男性", "isVisible": true},
        ],
        "sexualOrientation": [
          {"id": "so_002", "name": "双性恋", "desc": "对男女都感兴趣", "isVisible": true},
        ],
        "privacySettings": {"hideAge": false, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_004",
        "email": "diana@example.com",
        "phone": "13600136000",
        "password": "encrypted_000",
        "nikeName": "Diana的喵星球",
        "mediaUrls": ["https://example.com/photo7.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "宠物博主，家里有3只猫，热爱小动物",
        "chatPreference": {
          "title": "欢迎跟我聊宠物",
          "goingOut": ["宠物乐园", "宠物医院", "宠物用品店"],
          "myWeekend": ["陪猫咪玩", "给猫咪拍照", "做猫饭"],
          "myPhone": ["刷宠物视频", "记录猫咪日常", "和猫友交流"],
        },
        "prompts": [
          {"title": "宠物", "content": "养了美短、布偶、英短各一只，都是我的宝贝"},
        ],
        "interests": [
          {"id": "interest_010", "name": "养猫"},
          {"id": "interest_011", "name": "宠物美容"},
          {"id": "interest_012", "name": "手工猫窝"},
        ],
        "relationshipGoal": {"id": 4, "title": "寻找爱猫的伴侣", "emoji": "🐱"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 162.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
        ],
        "moreInfo": {
          "zodiac": "巨蟹座",
          "education": "本科",
          "familyPlan": "暂时不考虑",
          "communicationStyle": "温柔细心",
          "loveLanguage": "陪伴和照顾",
        },
        "lifestyle": {
          "petPreference": "只喜欢猫",
          "drinking": "从不喝酒",
          "smoking": "不吸烟",
          "fitness": "偶尔瑜伽",
          "socialMediaActivity": "每天刷2小时",
        },
        "jobTitle": "宠物博主",
        "company": "自媒体",
        "school": "浙江传媒学院",
        "city": "杭州市",
        "favoriteSong": {
          "title": "学不会",
          "artist": "林俊杰",
          "coverImageUrl": null,
        },
        "spotifyArtist": "邓紫棋",
        "gender": [
          {"id": "gender_001", "name": "女", "desc": "女性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_005",
        "email": "eric@example.com",
        "phone": "13500135000",
        "password": "encrypted_111",
        "nikeName": "Eric的咖啡时光",
        "mediaUrls": [
          "https://example.com/photo8.jpg",
          "https://example.com/photo9.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "咖啡师，喜欢研究咖啡豆和拉花技巧",
        "chatPreference": {
          "title": "欢迎跟我聊咖啡",
          "goingOut": ["咖啡馆探店", "咖啡豆市场", "咖啡展会"],
          "myWeekend": ["练习拉花", "烘焙咖啡豆", "和咖啡友交流"],
          "myPhone": ["看咖啡教程", "记录配方", "订咖啡豆"],
        },
        "prompts": [
          {"title": "爱好", "content": "最喜欢手冲咖啡，能品尝到咖啡豆的原味"},
        ],
        "interests": [
          {"id": "interest_013", "name": "咖啡"},
          {"id": "interest_014", "name": "烘焙"},
          {"id": "interest_015", "name": "拉花"},
        ],
        "relationshipGoal": {"id": 5, "title": "随缘交友", "emoji": "☕"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 5,
          "inch": 11,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
          {"id": "lang_006", "name": "意大利语"},
        ],
        "moreInfo": {
          "zodiac": "金牛座",
          "education": "大专",
          "familyPlan": "4年内考虑结婚",
          "communicationStyle": "沉稳务实",
          "loveLanguage": "美食和陪伴",
        },
        "lifestyle": {
          "petPreference": "喜欢狗",
          "drinking": "偶尔喝精酿啤酒",
          "smoking": "不吸烟",
          "fitness": "每周健身1次",
          "socialMediaActivity": "每天刷40分钟",
        },
        "jobTitle": "高级咖啡师",
        "company": "星巴克臻选店",
        "school": "上海旅游高等专科学校",
        "city": "广州市",
        "favoriteSong": {
          "title": "咖啡",
          "artist": "张学友",
          "coverImageUrl": "https://example.com/song4.jpg",
        },
        "spotifyArtist": "周杰伦",
        "gender": [
          {"id": "gender_002", "name": "男", "desc": "男性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_006",
        "email": "fiona@example.com",
        "phone": "13400134000",
        "password": "encrypted_222",
        "nikeName": "Fiona的艺术空间",
        "mediaUrls": [
          "https://example.com/photo10.jpg",
          "https://example.com/photo11.jpg",
          "https://example.com/photo12.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "油画师，专注风景创作，喜欢逛美术馆",
        "chatPreference": {
          "title": "欢迎跟我聊艺术",
          "goingOut": ["美术馆", "画廊", "艺术区"],
          "myWeekend": ["画画", "看艺术展", "写生"],
          "myPhone": ["看艺术作品", "找灵感", "和画友交流"],
        },
        "prompts": [
          {"title": "创作", "content": "擅长油画风景，最喜欢画日落和海边"},
        ],
        "interests": [
          {"id": "interest_016", "name": "油画"},
          {"id": "interest_017", "name": "写生"},
          {"id": "interest_018", "name": "艺术鉴赏"},
        ],
        "relationshipGoal": {"id": 6, "title": "寻找艺术同好", "emoji": "🎨"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 168.5,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
          {"id": "lang_007", "name": "意大利语"},
        ],
        "moreInfo": {
          "zodiac": "双鱼座",
          "education": "本科",
          "familyPlan": "暂时不考虑",
          "communicationStyle": "感性细腻",
          "loveLanguage": "理解和赞美",
        },
        "lifestyle": {
          "petPreference": "喜欢兔子",
          "drinking": "偶尔喝起泡酒",
          "smoking": "不吸烟",
          "fitness": "每周瑜伽2次",
          "socialMediaActivity": "每天刷50分钟",
        },
        "jobTitle": "自由油画师",
        "company": null,
        "school": "中央美术学院",
        "city": "成都市",
        "favoriteSong": {
          "title": "梵高先生",
          "artist": "李志",
          "coverImageUrl": "https://example.com/song5.jpg",
        },
        "spotifyArtist": "陈粒",
        "gender": [
          {"id": "gender_001", "name": "女", "desc": "女性", "isVisible": true},
        ],
        "sexualOrientation": [
          {"id": "so_003", "name": "同性恋", "desc": "只对同性感兴趣", "isVisible": true},
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_007",
        "email": "george@example.com",
        "phone": "13300133000",
        "password": "encrypted_333",
        "nikeName": "George的数码世界",
        "mediaUrls": ["https://example.com/photo13.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "数码博主，测评各类电子产品，喜欢折腾新科技",
        "chatPreference": {
          "title": "欢迎跟我聊数码",
          "goingOut": ["数码城", "科技展会", "体验店"],
          "myWeekend": ["测评产品", "修手机", "玩游戏机"],
          "myPhone": ["刷数码资讯", "测试新功能", "和机友交流"],
        },
        "prompts": [
          {"title": "数码", "content": "最喜欢折腾安卓手机，擅长刷机和优化"},
        ],
        "interests": [
          {"id": "interest_019", "name": "数码产品"},
          {"id": "interest_020", "name": "游戏机"},
          {"id": "interest_021", "name": "编程"},
        ],
        "relationshipGoal": {"id": 7, "title": "寻找科技爱好者", "emoji": "📱"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 2,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
          {"id": "lang_008", "name": "韩语"},
        ],
        "moreInfo": {
          "zodiac": "水瓶座",
          "education": "本科",
          "familyPlan": "6年内考虑",
          "communicationStyle": "理性客观",
          "loveLanguage": "共同探讨和分享",
        },
        "lifestyle": {
          "petPreference": "喜欢乌龟",
          "drinking": "偶尔喝啤酒",
          "smoking": "偶尔吸烟",
          "fitness": "每周打羽毛球1次",
          "socialMediaActivity": "每天刷1.5小时",
        },
        "jobTitle": "数码博主",
        "company": "自媒体",
        "school": "电子科技大学",
        "city": "深圳市",
        "favoriteSong": {
          "title": "数码宝贝主题曲",
          "artist": "和田光司",
          "coverImageUrl": "https://example.com/song6.jpg",
        },
        "spotifyArtist": "周杰伦",
        "gender": [
          {"id": "gender_002", "name": "男", "desc": "男性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_008",
        "email": "hannah@example.com",
        "phone": "13200132000",
        "password": "encrypted_444",
        "nikeName": "Hannah的烘焙日记",
        "mediaUrls": [
          "https://example.com/photo14.jpg",
          "https://example.com/photo15.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "烘焙师，擅长甜品制作，喜欢分享美食配方",
        "chatPreference": {
          "title": "欢迎跟我聊烘焙",
          "goingOut": ["烘焙原料店", "甜品店探店", "烘焙课程"],
          "myWeekend": ["做甜品", "研发新配方", "和朋友分享"],
          "myPhone": ["看烘焙教程", "记录配方", "和烘焙友交流"],
        },
        "prompts": [
          {"title": "烘焙", "content": "最擅长做马卡龙和芝士蛋糕，成功率90%以上"},
        ],
        "interests": [
          {"id": "interest_022", "name": "烘焙"},
          {"id": "interest_023", "name": "甜品"},
          {"id": "interest_024", "name": "美食摄影"},
        ],
        "relationshipGoal": {"id": 8, "title": "寻找爱吃甜品的伴侣", "emoji": "🍰"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 158.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_009", "name": "德语"},
        ],
        "moreInfo": {
          "zodiac": "摩羯座",
          "education": "本科",
          "familyPlan": "2年内考虑结婚",
          "communicationStyle": "踏实靠谱",
          "loveLanguage": "美食和陪伴",
        },
        "lifestyle": {
          "petPreference": "喜欢龙猫",
          "drinking": "偶尔喝果酒",
          "smoking": "不吸烟",
          "fitness": "每周跳操1次",
          "socialMediaActivity": "每天刷1小时",
        },
        "jobTitle": "甜品师",
        "company": "好利来",
        "school": "蓝带厨艺学院",
        "city": "重庆市",
        "favoriteSong": {
          "title": "甜甜的",
          "artist": "周杰伦",
          "coverImageUrl": "https://example.com/song7.jpg",
        },
        "spotifyArtist": "孙燕姿",
        "gender": [
          {"id": "gender_001", "name": "女", "desc": "女性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_009",
        "email": "ian@example.com",
        "phone": "13100131000",
        "password": "encrypted_555",
        "nikeName": "Ian的户外探险",
        "mediaUrls": [
          "https://example.com/photo16.jpg",
          "https://example.com/photo17.jpg",
          "https://example.com/photo18.jpg",
        ],
        "smartPhotosEnabled": false,
        "aboutMe": "户外探险家，喜欢登山、潜水，挑战极限运动",
        "chatPreference": {
          "title": "欢迎跟我聊户外",
          "goingOut": ["登山", "潜水", "攀岩"],
          "myWeekend": ["户外训练", "整理装备", "规划路线"],
          "myPhone": ["看户外攻略", "记录轨迹", "和驴友交流"],
        },
        "prompts": [
          {"title": "户外", "content": "登顶过5座5000米以上的山峰，潜水证到AOW级别"},
        ],
        "interests": [
          {"id": "interest_025", "name": "登山"},
          {"id": "interest_026", "name": "潜水"},
          {"id": "interest_027", "name": "攀岩"},
        ],
        "relationshipGoal": {"id": 9, "title": "寻找户外搭档", "emoji": "⛰️"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 3,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
          {"id": "lang_010", "name": "葡萄牙语"},
        ],
        "moreInfo": {
          "zodiac": "射手座",
          "education": "本科",
          "familyPlan": "暂无计划",
          "communicationStyle": "豪爽直接",
          "loveLanguage": "共同冒险和鼓励",
        },
        "lifestyle": {
          "petPreference": "喜欢牧羊犬",
          "drinking": "偶尔喝威士忌",
          "smoking": "偶尔吸烟",
          "fitness": "每天训练",
          "socialMediaActivity": "每天刷30分钟",
        },
        "jobTitle": "户外教练",
        "company": "户外探险俱乐部",
        "school": "北京体育大学",
        "city": "拉萨市",
        "favoriteSong": {
          "title": "蓝莲花",
          "artist": "许巍",
          "coverImageUrl": "https://example.com/song8.jpg",
        },
        "spotifyArtist": "许巍",
        "gender": [
          {"id": "gender_002", "name": "男", "desc": "男性", "isVisible": true},
        ],
        "sexualOrientation": [
          {"id": "so_002", "name": "双性恋", "desc": "对男女都感兴趣", "isVisible": true},
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_010",
        "email": "julia@example.com",
        "phone": "13000130000",
        "password": "encrypted_666",
        "nikeName": "Julia的瑜伽馆",
        "mediaUrls": ["https://example.com/photo19.jpg"],
        "smartPhotosEnabled": true,
        "aboutMe": "瑜伽教练，专注正念冥想，帮助他人缓解压力",
        "chatPreference": {
          "title": "欢迎跟我聊瑜伽",
          "goingOut": ["瑜伽馆", "户外瑜伽", "冥想中心"],
          "myWeekend": ["上瑜伽课", "冥想", "练习阿斯汤加"],
          "myPhone": ["看瑜伽教程", "听冥想音频", "和学员交流"],
        },
        "prompts": [
          {"title": "瑜伽", "content": "拥有RYT500认证，擅长流瑜伽和阴瑜伽"},
        ],
        "interests": [
          {"id": "interest_028", "name": "瑜伽"},
          {"id": "interest_029", "name": "冥想"},
          {"id": "interest_030", "name": "普拉提"},
        ],
        "relationshipGoal": {"id": 10, "title": "寻找热爱生活的伴侣", "emoji": "🧘"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 170.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "中文"},
          {"id": "lang_002", "name": "英语"},
          {"id": "lang_011", "name": "印地语"},
        ],
        "moreInfo": {
          "zodiac": "天蝎座",
          "education": "硕士",
          "familyPlan": "3年内考虑",
          "communicationStyle": "温柔有耐心",
          "loveLanguage": "陪伴和倾听",
        },
        "lifestyle": {
          "petPreference": "喜欢鹦鹉",
          "drinking": "从不喝酒",
          "smoking": "不吸烟",
          "fitness": "每天瑜伽",
          "socialMediaActivity": "每天刷20分钟",
        },
        "jobTitle": "资深瑜伽教练",
        "company": "lululemon瑜伽中心",
        "school": "印度瑜伽学院",
        "city": "西安市",
        "favoriteSong": {
          "title": "万物生",
          "artist": "萨顶顶",
          "coverImageUrl": "https://example.com/song9.jpg",
        },
        "spotifyArtist": "王菲",
        "gender": [
          {"id": "gender_001", "name": "女", "desc": "女性", "isVisible": true},
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "异性恋",
            "desc": "只对异性感兴趣",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
    ];

    List<UserProfileModel> userList = json.map((userData) {
      return UserProfileModel.fromJson(userData);
    }).toList();
    return userList;
  }
}

class ProfileItem {
  /// 图标
  final IconData icon;

  /// 标签文案
  final String label;

  /// 当前选中值
  final String value;

  /// 关联的选项类型枚举（可选，用于唤起对应弹窗）
  final SheetOptionType optionType;

  const ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.optionType,
  });
}
