import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// 个人资料 - 我会的语言选择弹窗
class ProfileInterestSheet extends StatefulWidget {
  /// 初始已选中的用户语言列表（用于回显）
  final List<UserInterest>? selectedInterest;

  /// 完成按钮回调，返回选中的 UserInterest 模型数组
  final Function(List<UserInterest> selectedInterests) onCompleted;

  /// 弹窗关闭回调
  final VoidCallback? onClose;

  /// 可选的自定义语言列表（基础 UserInterest 类型）
  final List<UserInterest>? interests;

  ProfileInterestSheet({
    super.key,
    this.selectedInterest = const [],
    required this.onCompleted,
    this.onClose,
    this.interests,
  });

  /// 静态快捷方法：一键展示底部弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    List<UserInterest>? selectedInterest = const [],
    required Function(List<UserInterest> selectedInterests) onCompleted,
    VoidCallback? onClose,
    List<UserInterest>? interests,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileInterestSheet(
        selectedInterest: selectedInterest,
        onCompleted: onCompleted,
        onClose: onClose ?? () => Navigator.pop(context),
        interests: interests ?? [],
      ),
    );
  }

  @override
  State<ProfileInterestSheet> createState() => _ProfileInterestSheetState();
}

class _ProfileInterestSheetState extends State<ProfileInterestSheet> {
  late List<String> _selectedIds; // 存储选中的语言ID（用于判断选中状态）
  late List<UserInterest> _allInterests;
  late List<UserInterest> _filteredInterests;
  final TextEditingController _searchController = TextEditingController();
  bool isMax = false;
  getAllInterests() {
    if (widget.interests != null && widget.interests!.isNotEmpty) {
      return widget.interests!;
    }
    return [
      // 图1
      UserInterest(id: 'coffee', name: '咖啡'),
      UserInterest(id: 'brunch', name: '早午餐'),
      UserInterest(id: 'party', name: '派对'),
      UserInterest(id: 'sailing', name: '帆船运动'),
      UserInterest(id: 'surfing', name: '冲浪'),
      UserInterest(id: 'tattoo', name: '文身'),
      UserInterest(id: 'skiing', name: '滑雪'),
      UserInterest(id: 'skate_skiing', name: '滑板滑雪'),
      UserInterest(id: 'holiday', name: '节日'),
      UserInterest(id: 'escape_room', name: '密室逃脱'),
      UserInterest(id: 'shopping', name: '购物'),
      UserInterest(id: 'self_love', name: '自爱'),
      UserInterest(id: 'dog_walking', name: '遛狗'),
      UserInterest(id: 'exhibition', name: '展览'),
      UserInterest(id: 'food_trip', name: '美食之旅'),
      UserInterest(id: 'board_games', name: '棋类游戏'),
      UserInterest(id: 'trivia', name: 'Trivia'),
      UserInterest(id: 'craft_beer', name: '精酿啤酒'),
      UserInterest(id: 'tea', name: '茶'),
      UserInterest(id: 'alcohol', name: '酒'),
      UserInterest(id: 'video_podcast', name: '拍视频播客'),
      UserInterest(id: 'volunteering', name: '参加自愿活动'),
      UserInterest(id: 'environmentalism', name: '环保主义'),
      UserInterest(id: 'cooking', name: '烹饪'),
      UserInterest(id: 'astrology', name: '占星术'),
      UserInterest(id: 'gardening', name: '园艺'),
      UserInterest(id: 'art', name: '艺术'),
      UserInterest(id: 'football', name: '足球'),
      UserInterest(id: 'dancing', name: '跳舞'),
      UserInterest(id: 'museum', name: '博物馆'),
      UserInterest(id: 'activism', name: '行动主义'),
      UserInterest(id: 'politics', name: '政治'),
      UserInterest(id: 'j_pop', name: '日本流行音乐'),
      UserInterest(id: 'cricket', name: '板球'),
      UserInterest(id: 'bollywood', name: '宝莱坞'),
      UserInterest(id: 'poetry', name: '诗歌'),
      UserInterest(id: 'stand_up', name: '单口相声'),
      UserInterest(id: 'rap', name: '说唱'),
      UserInterest(id: 'house_party', name: '家庭派对'),
      UserInterest(id: '90s', name: '90后'),
      UserInterest(id: 'sushi', name: '寿司'),
      UserInterest(id: 'sneakers', name: '球鞋'),
      UserInterest(id: 'country_music', name: '乡村音乐'),
      UserInterest(id: 'football_2', name: '足球'),
      UserInterest(id: 'road_trip', name: '自驾游'),
      UserInterest(id: 'thrift_shopping', name: '淘二手货'),
      UserInterest(id: 'black_lives_matter', name: '黑人命也是命'),
      UserInterest(id: 'voting_rights', name: '选民权'),
      UserInterest(id: 'climate_change', name: '气候变化'),
      UserInterest(id: 'mental_health', name: '心理健康意识'),
      UserInterest(id: 'lgbtq_rights', name: 'LGBTQIA+ 权利'),
      UserInterest(id: 'feminism', name: '女权主义'),
      UserInterest(id: 'nba', name: 'NBA'),
      UserInterest(id: 'mlb', name: 'MLB'),
      UserInterest(id: 'bubble_tea', name: '珍珠奶茶'),
      UserInterest(id: 'badminton', name: '羽毛球'),
      UserInterest(id: 'cars', name: '汽车'),
      UserInterest(id: 'clubbing', name: '逛夜店'),
      UserInterest(id: 'street_food', name: '街边小吃'),
      UserInterest(id: 'horror_movies', name: '鬼片'),
      UserInterest(id: 'boxing', name: '拳击'),
      UserInterest(id: 'american_football', name: '橄榄球'),
      UserInterest(id: 'tarot', name: '塔罗牌'),
      UserInterest(id: 'asahi', name: '阿萨伊'),
      UserInterest(id: 'bar', name: '酒吧'),

      // 图2
      UserInterest(id: 'punk_music', name: '放克音乐'),
      UserInterest(id: 'beach_bar', name: '海滩酒吧'),
      UserInterest(id: 'garage_rap', name: '车库饶舌'),
      UserInterest(id: '90s_britpop', name: '90 年代英伦摇滚'),
      UserInterest(id: 'upcycling', name: '升级回收'),
      UserInterest(id: 'pub_quiz', name: '酒吧竞猜游戏'),
      UserInterest(id: 'esports', name: '电子竞技'),
      UserInterest(id: 'motorsport', name: '赛车运动'),
      UserInterest(id: 'podcast', name: '播客'),
      UserInterest(id: 'bar_2', name: '酒吧'),
      UserInterest(id: 'bbq', name: '烧烤'),
      UserInterest(id: 'pho', name: '越南河粉'),
      UserInterest(id: 'motorcycle', name: '摩托车'),
      UserInterest(id: 'self_care', name: '自我照顾'),
      UserInterest(id: 'basketball', name: '篮球'),
      UserInterest(id: 'theater', name: '戏剧'),
      UserInterest(id: 'meditation', name: '冥想'),
      UserInterest(id: 'tennis', name: '网球'),
      UserInterest(id: 'happy_hour', name: '特惠时段'),
      UserInterest(id: 'couch_surfing', name: '沙发冲浪'),
      UserInterest(id: 'vintage_fashion', name: '复古时尚'),
      UserInterest(id: 'edm', name: '雷击顿音乐'),
      UserInterest(id: 'plant_based', name: '植基饮食'),
      UserInterest(id: 'acapella', name: '阿卡贝拉'),
      UserInterest(id: 'among_us', name: '《太空狼人杀》'),
      UserInterest(id: 'archery', name: '射箭'),
      UserInterest(id: 'art_gallery', name: '艺术画廊'),
      UserInterest(id: 'yahtzee', name: '雅达利'),
      UserInterest(id: 'backpacking', name: '背包旅行'),
      UserInterest(id: 'live_music', name: '乐队表演'),
      UserInterest(id: 'bar_crawl', name: '酒吧串游'),
      UserInterest(id: 'baseball', name: '棒球'),
      UserInterest(id: 'binge_watching', name: '狂刷电视剧'),
      UserInterest(id: 'bowling', name: '打保龄球'),
      UserInterest(id: 'kayaking', name: '划艇'),
      UserInterest(id: 'racing', name: '赛车'),
      UserInterest(id: 'cheerleading', name: '啦啦队运动'),
      UserInterest(id: 'choir', name: '合唱团'),
      UserInterest(id: 'content_creation', name: '内容创作'),
      UserInterest(id: 'cosplay', name: '角色扮演'),
      UserInterest(id: 'disability_rights', name: '残障人士权利'),
      UserInterest(id: 'painting', name: '绘画'),
      UserInterest(id: 'drive_in', name: '汽车影院'),
      UserInterest(id: 'dnd', name: '《龙与地下城》'),
      UserInterest(id: 'electronic_music', name: '电子音乐'),
      UserInterest(id: 'entrepreneurship', name: '创业'),
      UserInterest(id: 'equality', name: '平等'),
      UserInterest(id: 'equestrian', name: '马术'),
      UserInterest(id: 'exchange_program', name: '交换项目'),
      UserInterest(id: 'film_festival', name: '电影节'),
      UserInterest(id: 'fortnite', name: '《堡垒之夜》'),
      UserInterest(id: 'freediving', name: '自由潜水'),
      UserInterest(id: 'freelance', name: '自由职业'),
      UserInterest(id: 'gospel_music', name: '福音音乐'),
      UserInterest(id: 'gym', name: '体育馆'),
      UserInterest(id: 'gymnastics', name: '体操'),
      UserInterest(id: 'harry_potter', name: '《哈利波特》'),
      UserInterest(id: 'heavy_metal', name: '重金属音乐'),
      UserInterest(id: 'hockey', name: '曲棍球'),
      UserInterest(id: 'home_workout', name: '家庭健身'),

      // 图3
      UserInterest(id: 'human_rights', name: '人权'),
      UserInterest(id: 'ice_cream', name: '冰淇淋'),
      UserInterest(id: 'inclusivity', name: '包容'),
      UserInterest(id: 'investing', name: '投资'),
      UserInterest(id: 'jet_ski', name: '水上摩托'),
      UserInterest(id: 'jogging', name: '慢跑'),
      UserInterest(id: 'sports', name: '运动'),
      UserInterest(id: 'korean_food', name: '韩式美食'),
      UserInterest(id: 'league_of_legends', name: '《英雄联盟》'),
      UserInterest(id: 'literature', name: '文学'),
      UserInterest(id: 'live_music_2', name: '现场音乐'),
      UserInterest(id: 'makeup', name: '化妆品'),
      UserInterest(id: 'manga', name: '漫画'),
      UserInterest(id: 'marathon', name: '马拉松'),
      UserInterest(id: 'martial_arts', name: '武术'),
      UserInterest(id: 'marvel', name: '漫威'),
      UserInterest(id: 'memes', name: '表情包'),
      UserInterest(id: 'metaverse', name: '元宇宙'),
      UserInterest(id: 'mindfulness', name: '正念'),
      UserInterest(id: 'mountains', name: '大山'),
      UserInterest(id: 'musical_instruments', name: '乐器'),
      UserInterest(id: 'musical_theater', name: '音乐剧创作'),
      UserInterest(id: 'nft', name: '非同质化代币'),
      UserInterest(id: 'nintendo', name: '任天堂'),
      UserInterest(id: 'online_gaming', name: '在线游戏'),
      UserInterest(id: 'online_shopping', name: '在线购物'),
      UserInterest(id: 'paddleboarding', name: '桨板冲浪'),
      UserInterest(id: 'padel', name: '笼式网球'),
      UserInterest(id: 'painting_2', name: '绘画'),
      UserInterest(id: 'paragliding', name: '滑翔伞'),
      UserInterest(id: 'pilates', name: '普拉提'),
      UserInterest(id: 'pinterest', name: 'Pinterest'),
      UserInterest(id: 'playstation', name: 'PlayStation'),
      UserInterest(id: 'pole_dancing', name: '钢管舞'),
      UserInterest(id: 'ramen', name: '拉面'),
      UserInterest(id: 'rave', name: '锐舞派对'),
      UserInterest(id: 'real_estate', name: '房地产'),
      UserInterest(id: 'roblox', name: '《罗布乐思》'),
      UserInterest(id: 'rock_music', name: '摇滚音乐'),
      UserInterest(id: 'rock_climbing', name: '攀岩'),
      UserInterest(id: 'roller_skating', name: '滑旱冰'),
      UserInterest(id: 'sauna', name: '桑拿'),
      UserInterest(id: 'sci_fi', name: '科幻'),
      UserInterest(id: 'self_development', name: '自我发展'),
      UserInterest(id: 'shisha', name: '水烟'),
      UserInterest(id: 'singing', name: '唱歌'),
      UserInterest(id: 'skateboarding', name: '滑板'),
      UserInterest(id: 'skincare', name: '护肤'),
      UserInterest(id: 'social_development', name: '社会性发展'),
      UserInterest(id: 'social_media', name: '社交媒体活跃度'),
      UserInterest(id: 'soundcloud', name: 'SoundCloud'),
      UserInterest(id: 'spa', name: '水疗'),
      UserInterest(id: 'spotify', name: 'Spotify'),
      UserInterest(id: 'table_tennis', name: '乒乓球'),
      UserInterest(id: 'tiktok', name: 'TikTok'),
      UserInterest(id: 'town_festival', name: '城镇节庆'),
      UserInterest(id: 'trap_music', name: '陷阱音乐'),
      UserInterest(id: 'twitch', name: 'Twitch'),
      UserInterest(id: 'vr', name: '虚拟现实'),
      UserInterest(id: 'volleyball', name: '排球'),
      UserInterest(id: 'hiking', name: '徒步旅行'),
      UserInterest(id: 'weightlifting', name: '举重'),
      UserInterest(id: 'world_peace', name: '世界和平'),
      UserInterest(id: 'wrestling', name: '摔跤'),
      UserInterest(id: 'writing', name: '写作'),

      // 图4
      UserInterest(id: 'xbox', name: 'Xbox'),
      UserInterest(id: 'youth_empowerment', name: '青年赋权'),
      UserInterest(id: 'youtube', name: 'YouTube'),
      UserInterest(id: 'pride', name: '同志骄傲'),
      UserInterest(id: 'trying_new_things', name: '尝试新事物'),
      UserInterest(id: 'k_pop', name: '韩流'),
      UserInterest(id: 'reading', name: '阅读'),
      UserInterest(id: 'photography', name: '摄影'),
      UserInterest(id: 'karaoke', name: '卡拉 OK'),
      UserInterest(id: 'hot_spring', name: '温泉'),
      UserInterest(id: 'walking', name: '散步'),
      UserInterest(id: 'cafe_hop', name: '巡访咖啡馆'),
      UserInterest(id: 'instagram', name: 'Instagram'),
      UserInterest(id: 'aquarium', name: '水族馆'),
      UserInterest(id: 'foodie', name: '吃货'),
      UserInterest(id: 'running', name: '跑步'),
      UserInterest(id: 'cocktails', name: '鸡尾酒'),
      UserInterest(id: 'yoga', name: '瑜伽'),
      UserInterest(id: 'fitness', name: '健身'),
      UserInterest(id: 'swimming', name: '游泳'),
      UserInterest(id: 'disney', name: '迪士尼'),
      UserInterest(id: 'athletics', name: '田径'),
      UserInterest(id: 'scuba_diving', name: '潜水'),
      UserInterest(id: 'yachting', name: '赛艇'),
      UserInterest(id: 'shooting', name: '射击运动'),
      UserInterest(id: 'ice_hockey', name: '冰球'),
      UserInterest(id: 'comedy', name: '喜剧'),
      UserInterest(id: 'netflix', name: '网飞'),
      UserInterest(id: 'music', name: '音乐'),
      UserInterest(id: 'cycling', name: '骑行'),
      UserInterest(id: 'diy', name: 'DIY'),
      UserInterest(id: 'picnic', name: '野餐'),
      UserInterest(id: 'outdoor', name: '户外活动'),
      UserInterest(id: 'language_exchange', name: '语言交流'),
      UserInterest(id: 'opera', name: '歌剧'),
      UserInterest(id: 'latin_music', name: '拉丁音乐'),
      UserInterest(id: 'folk_music', name: '民俗音乐'),
      UserInterest(id: 'kpop_2', name: '浩室音乐'),
      UserInterest(id: 'edm_2', name: '电子舞曲'),
      UserInterest(id: 'blues', name: '蓝调音乐'),
      UserInterest(id: 'jazz', name: '爵士乐'),
      UserInterest(id: 'tech', name: '高科技'),
      UserInterest(id: 'indie_music', name: '独立音乐'),
      UserInterest(id: 'anime', name: '动漫'),
      UserInterest(id: 'fashion', name: '时尚'),
      UserInterest(id: 'positive_lifestyle', name: '积极的生活方式'),
      UserInterest(id: 'travel', name: '旅行'),
      UserInterest(id: 'baking', name: '烘焙'),
      UserInterest(id: 'sweets', name: '甜食'),
      UserInterest(id: 'non_alcoholic_cocktails', name: '无酒精鸡尾酒'),
      UserInterest(id: 'beach_sports', name: '沙滩运动'),
      UserInterest(id: 'fitness_class', name: '健身课'),
      UserInterest(id: 'roller_skating_2', name: '滑旱冰'),
      UserInterest(id: 'alternative_music', name: '另类音乐'),
      UserInterest(id: 'pop_music', name: '流行音乐'),
      UserInterest(id: 'punk_rock', name: '朋克摇滚'),
      UserInterest(id: 'hip_hop', name: '说唱音乐'),
      UserInterest(id: 'soul_music', name: '灵魂音乐'),
      UserInterest(id: 'musical', name: '音乐剧'),
      UserInterest(id: 'action_movies', name: '动作片'),
      UserInterest(id: 'anime_movies', name: '动漫电影'),
      UserInterest(id: 'true_crime', name: '犯罪类节目'),
      UserInterest(id: 'documentaries', name: '纪录片'),
      UserInterest(id: 'drama_movies', name: '剧情片'),
      UserInterest(id: 'fantasy_movies', name: '奇幻电影'),
      UserInterest(id: 'indie_films', name: '独立电影'),

      // 图5
      UserInterest(id: 'reality_tv', name: '真人秀'),
      UserInterest(id: 'rom_com', name: '爱情喜剧'),
      UserInterest(id: 'sports_shows', name: '体育节目'),
      UserInterest(id: 'thrillers', name: '惊悚片'),
      UserInterest(id: 'k_dramas', name: '韩剧'),
      UserInterest(id: 'x', name: 'X'),
      UserInterest(id: 'comic_con', name: '漫展'),
      UserInterest(id: 'blogging', name: '写博客'),
      UserInterest(id: 'camping', name: '野营'),
      UserInterest(id: 'mountain_climbing', name: '登山'),
      UserInterest(id: 'concerts', name: '音乐会'),
      UserInterest(id: 'crossfit', name: 'Crossfit 综合体能训练'),
      UserInterest(id: 'fishing', name: '钓鱼'),
      UserInterest(id: 'hiking_2', name: '徒步旅行'),
      UserInterest(id: 'movies', name: '电影'),
      UserInterest(id: 'nature', name: '自然'),
      UserInterest(id: 'nightlife', name: '夜生活'),
    ];
  }

  @override
  void initState() {
    super.initState();
    // 从传入的 selectedInterest 中提取ID，用于回显选中状态
    _selectedIds =
        widget.selectedInterest?.map((lang) => lang.id).toList() ?? [];
    _allInterests = getAllInterests();
    _filteredInterests = _allInterests;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 切换语言选中状态
  void _toggleInterest(UserInterest UserInterest) {
    if (_selectedIds.contains(UserInterest.id)) {
      if (isMax) {
        setState(() {
          isMax = false;
        });
      }
      // 取消选中
      setState(() {
        _selectedIds.remove(UserInterest.id);
      });
    } else {
      // 限制最多选5种
      if (_selectedIds.length >= 5) {
        setState(() {
          isMax = true;
        });
        return;
      } else {
        setState(() {
          isMax = false;
        });
      }
      // 选中语言
      setState(() {
        _selectedIds.add(UserInterest.id);
      });
    }
  }

  /// 搜索过滤语言列表
  void _filterInterests(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _filteredInterests = _allInterests;
      });
      return;
    }
    final lowerKeyword = keyword.toLowerCase();
    setState(() {
      _filteredInterests = _allInterests
          .where((lang) => lang.name.toLowerCase().contains(lowerKeyword))
          .toList();
    });
  }

  /// 完成按钮点击 - 转换为 UserInterest 回调
  void _handleComplete() {
    // 筛选出选中的基础 UserInterest 模型
    final selectedBaseInterests = _allInterests
        .where((lang) => _selectedIds.contains(lang.id))
        .toList();
    // 转换为 UserInterest 模型（适配你的业务类型）
    final selectedUserInterests = selectedBaseInterests
        .map((lang) => UserInterest(id: lang.id, name: lang.name))
        .toList();
    // 回调返回 UserInterest 数组
    widget.onCompleted(selectedUserInterests);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 计算选中数量（用于回显计数）
    final selectedCount = _selectedIds.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部拖拽条
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 24),
          // 标题 + 完成按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '兴趣',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton(
                onPressed: _handleComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  minimumSize: Size(60, 32),
                ),
                child: Text(
                  '完成',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // 提示文案 + 选中计数回显
          Text(
            '请至多选择 5 个你想要与大家分享的兴趣',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$selectedCount/5',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isMax == true) SizedBox(width: 4),
              if (isMax == true)
                Text(
                  '（最多选择5种语言）',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          // 搜索框
          TextField(
            controller: _searchController,
            onChanged: _filterInterests,
            decoration: InputDecoration(
              hintText: '搜索语言',
              prefixIcon: Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          SizedBox(height: 16),
          // 语言列表（可滑动 + 选中状态回显）
          SizedBox(
            height: 300, // 固定列表高度，保证滑动
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filteredInterests.map((lang) {
                  // 关键：判断当前语言是否在选中列表中（回显核心逻辑）
                  final isSelected = _selectedIds.contains(lang.id);
                  return GestureDetector(
                    onTap: () => _toggleInterest(lang),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.redAccent
                              : Colors.grey[300]!,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        lang.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.redAccent : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // 底部安全区适配
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
