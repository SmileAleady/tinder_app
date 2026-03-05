import 'package:flutter/material.dart';

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
