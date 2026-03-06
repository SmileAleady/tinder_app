import 'package:flutter/material.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/profile_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const Color _bg = Color(0xFFE7E8EC);
  static const Color _cardColor = Color(0xFFF4F5F7);
  static const Color _text = Color(0xFF1E2330);
  static const Color _sub = Color(0xFF6B7280);
  static const Color _pink = Color(0xFFFF2D68);

  UserProfileModel? _user;
  bool _loading = true;

  bool _searchGlobal = false;
  bool _showOutDistance = true;
  bool _showOutAgeRange = true;
  bool _hasProfile = false;
  bool _discoveryEnabled = true;
  bool _verifiedOnlyChat = false;
  bool _useKm = true;

  double _maxDistance = 80;
  double _minPhotos = 1;
  RangeValues _ageRange = const RangeValues(18, 34);

  @override
  void initState() {
    super.initState();
    _loadActiveUser();
  }

  Future<void> _loadActiveUser() async {
    final active = await UserAuthLocalDb.instance.getActiveUser();
    if (!mounted) {
      return;
    }

    if (active != null) {
      _user = active;
      _maxDistance = (active.distance ?? 80).clamp(1, 160);
      final age = (active.age ?? 26).clamp(18, 60);
      _ageRange = RangeValues(
        (age - 8).clamp(18, 60).toDouble(),
        age.toDouble(),
      );
      _showOutDistance = !active.privacySettings.hideDistance;
      _showOutAgeRange = !active.privacySettings.hideAge;
      _hasProfile = active.aboutMe.trim().isNotEmpty;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateUser(void Function(UserProfileModel user) update) async {
    if (_user == null) {
      return;
    }
    update(_user!);
    await UserAuthLocalDb.instance.upsertUser(_user!, keepActive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _pink, size: 28),
        ),
        title: const Text(
          '设置',
          style: TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadActiveUser,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _membershipCard(
                    'PLATINUM',
                    const Color(0xFF171C24),
                    '你可以使用置顶赞，查看谁给你点了赞，同时享受更多高级功能',
                  ),
                  const SizedBox(height: 10),
                  _membershipCard(
                    'GOLD',
                    const Color(0xFFE4B025),
                    '查看给你点赞的人及更多信息！',
                  ),
                  const SizedBox(height: 10),
                  _membershipCard('PLUS', _pink, '无限点赞次数和更多！'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SuperLikePage(),
                              ),
                            );
                          },
                          child: _quickAction(
                            Icons.star,
                            const Color(0xFF20B7F2),
                            '获取 Super Like',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: _showBoostSheet,
                          child: _quickAction(
                            Icons.bolt,
                            const Color(0xFFA03DFF),
                            '获得 Boost',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _quickAction(
                          Icons.visibility_off,
                          _text,
                          '开启隐身模式',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _quickAction(Icons.flight, _pink, '位置漫游模式'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('账号设置'),
                  _card(
                    child: Column(
                      children: [
                        _valueRow(
                          '电话号码',
                          _user?.phone.isNotEmpty == true
                              ? _user!.phone
                              : '86 198 8201 7769',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '验证手机号码，以帮助保护你的账号。',
                    style: TextStyle(color: _sub, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('发现设置'),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '位置',
                          style: TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: _pink,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _user?.city?.isNotEmpty == true
                                  ? _user!.city!
                                  : '成都市, 中国',
                              style: const TextStyle(
                                color: _text,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '添加一个新位置',
                          style: TextStyle(
                            color: _pink,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '更改位置，随地配对。',
                    style: TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '搜索全球',
                            style: TextStyle(color: _text, fontSize: 17),
                          ),
                        ),
                        _tinySwitch(
                          value: _searchGlobal,
                          onChanged: (v) => setState(() => _searchGlobal = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '开启“搜索全球”模式，你将会看到来自附近和全球各地的朋友。',
                    style: TextStyle(color: _sub, fontSize: 17, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '最大距离',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_maxDistance.round()}${_useKm ? '公里' : '英里'}',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        Slider(
                          value: _maxDistance,
                          min: 1,
                          max: 160,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) async {
                            setState(() => _maxDistance = v);
                            await _updateUser((u) => u.distance = v);
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                '当我将可看的个人资料浏览完后向我显示超出距离范围的用户',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _tinySwitch(
                              value: _showOutDistance,
                              activeColor: _pink,
                              onChanged: (v) async {
                                setState(() => _showOutDistance = v);
                                await _updateUser(
                                  (u) => u.privacySettings.hideDistance = !v,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('感兴趣', trailing: _firstGender()),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              '年龄范围',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _ageRange,
                          min: 18,
                          max: 60,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) async {
                            setState(() => _ageRange = v);
                            await _updateUser((u) => u.age = v.end.round());
                          },
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                '当我将可看的个人资料浏览完毕后向我显示略微超出偏好范围的用户。',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _tinySwitch(
                              value: _showOutAgeRange,
                              activeColor: _pink,
                              onChanged: (v) async {
                                setState(() => _showOutAgeRange = v);
                                await _updateUser(
                                  (u) => u.privacySettings.hideAge = !v,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F0DE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '解锁更多\n偏好设置',
                          style: TextStyle(
                            color: Color(0xFF8B6803),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '想要更多独特体验？设置高级偏好，查看对你口味的个人资料，但又不会错过其他的有缘人。',
                          style: TextStyle(
                            color: _sub,
                            fontSize: 17,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 120,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: const Color(0xFFE8BD2C),
                            ),
                            child: const Center(
                              child: Text(
                                '解锁',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '最少照片数',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _minPhotos.round().toString(),
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        Slider(
                          value: _minPhotos,
                          min: 1,
                          max: 6,
                          divisions: 5,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) => setState(() => _minPhotos = v),
                        ),
                        _entryRow(
                          '有个人资料',
                          trailingWidget: _tinySwitch(
                            value: _hasProfile,
                            onChanged: (v) => setState(() => _hasProfile = v),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...[
                          ('兴趣', '选择'),
                          ('我想要', '选择'),
                          ('添加语言', '选择'),
                          ('星座', '选择'),
                          ('教育情况', '选择'),
                          ('家庭计划', '选择'),
                          ('沟通风格', '选择'),
                          ('爱的方式', '选择'),
                          ('宠物喜好', '选择'),
                          ('饮酒', '选择'),
                          ('你多久抽一次烟?', '选择'),
                          ('健身情况', '选择'),
                          ('社交媒体活跃度', '选择'),
                        ].map(
                          (item) => _entryRow(
                            item.$1,
                            trailing: item.$2,
                            topPadding: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _sectionTitle('管理您的访客'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Tinder Plus™',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _card(
                    child: Column(
                      children: [
                        _choiceRow('均衡的推荐', '看看和你最相关的人（默认设置）', selected: true),
                        const SizedBox(height: 10),
                        _choiceRow('最近活跃', '先看看最近活跃的人', selected: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('管理我的可见设置'),
                  _card(
                    child: Column(
                      children: [
                        _choiceRow('标准', '你将在卡片集中对其他会员可见', selected: true),
                        const SizedBox(height: 10),
                        _choiceRow(
                          '隐身   Tinder Plus™',
                          '你只对赞过的会员可见',
                          selected: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('启用发现'),
                  _card(
                    child: Row(
                      children: [
                        const Text(
                          '启用发现',
                          style: TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        _tinySwitch(
                          value: _discoveryEnabled,
                          activeColor: _pink,
                          onChanged: (v) =>
                              setState(() => _discoveryEnabled = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '如关闭此功能，你的个人资料将不会显示在卡片集中，并且发现功能将被禁用。你赞过的会员也许仍然能看到你并与你达成配对。',
                    style: TextStyle(color: _sub, fontSize: 17, height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('管理信息接收'),
                  _card(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1485E2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '必须通过验证',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '通过照片验证才可聊天',
                                    style: TextStyle(
                                      color: _text,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '通过照片验证的会员可以启用此功能，仅接收已验证会员发来的信息。',
                                    style: TextStyle(
                                      color: _sub,
                                      fontSize: 17,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _tinySwitch(
                              value: _verifiedOnlyChat,
                              onChanged: (v) =>
                                  setState(() => _verifiedOnlyChat = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(child: _entryRow('屏蔽联系人')),
                  const SizedBox(height: 16),
                  _sectionTitle('外观'),
                  _card(child: _entryRow('使用系统设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('数据使用情况'),
                  _card(child: _entryRow('自动播放视频')),
                  const SizedBox(height: 10),
                  _card(
                    child: const Center(
                      child: Text(
                        '申请 Tinder U',
                        style: TextStyle(
                          color: _pink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _sectionTitle('网页版个人资料'),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '创建用户名。并分享用户名。世界各地的用户将相聚在 Tinder，与你配对。',
                          style: TextStyle(
                            color: _sub,
                            fontSize: 17,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _entryRow('用户名', trailing: '申请用户名'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('问答活动'),
                  _card(child: _entryRow('管理问答活动', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('媒人'),
                  _card(child: _entryRow('管理媒人', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('最佳精选'),
                  _card(child: _entryRow('管理最佳精选', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('抱团约会'),
                  _card(child: _entryRow('管理抱团约会功能', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('星座板块'),
                  _card(child: _entryRow('管理星座板块', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('音乐'),
                  _card(child: _entryRow('管理音乐模式', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('滑动热潮'),
                  _card(child: _entryRow('管理滑动热潮', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('活跃状态'),
                  _card(child: _entryRow('管理活跃状态', trailing: '设置')),
                  const SizedBox(height: 16),
                  _sectionTitle('共同好友'),
                  _card(child: _entryRow('共同好友')),
                  const SizedBox(height: 8),
                  const Text(
                    '查看与潜在配对对象共享多少好友。',
                    style: TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('应用程序设置'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('通知'),
                        _entryRow('电子邮件地址'),
                        _entryRow('推送通知'),
                        _entryRow('短信'),
                        _entryRow('Tinder 团队'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '显示距离范围为',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _useKm ? '公里' : '英里',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE1E4EA)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _useKm = true),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _useKm
                                          ? _pink
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '公里',
                                        style: TextStyle(
                                          color: _useKm ? Colors.white : _text,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _useKm = false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: !_useKm
                                          ? _pink
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '英里',
                                        style: TextStyle(
                                          color: !_useKm ? Colors.white : _text,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('付款账户'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('管理付款账户'),
                        const Divider(height: 20),
                        _entryRow('管理 Google Play 账号'),
                        const Divider(height: 20),
                        _entryRow('恢复购买'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('联系我们'),
                  _card(
                    child: Column(
                      children: [_entryRow('帮助和支持'), _entryRow('进行举报')],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('社区'),
                  _card(
                    child: Column(
                      children: [_entryRow('社群规则'), _entryRow('安全贴士')],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(child: _entryRow('分享 Tinder')),
                  const SizedBox(height: 16),
                  _sectionTitle('隐私'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('Cookie 政策'),
                        _entryRow('隐私政策'),
                        _entryRow('隐私偏好'),
                        _entryRow('来自 Match Group'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('合法'),
                  _card(
                    child: Column(
                      children: [_entryRow('许可证'), _entryRow('服务条款')],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: const Center(
                      child: Text(
                        '登出',
                        style: TextStyle(
                          color: _text,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: const [
                      Icon(Icons.local_fire_department, color: _pink, size: 64),
                      SizedBox(height: 8),
                      Text(
                        '版本 17.6.1(17060187)',
                        style: TextStyle(color: _sub, fontSize: 17),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _card(
                    child: const Center(
                      child: Text(
                        '删除账户',
                        style: TextStyle(
                          color: _text,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _membershipCard(String name, Color logoColor, String subtitle) {
    return _card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department, color: logoColor, size: 38),
              const SizedBox(width: 6),
              const Text(
                'tinder',
                style: TextStyle(
                  color: _text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  color: logoColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _sub, fontSize: 17, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, Color color, String title) {
    return _card(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD5D9E0)),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _text,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _entryRow(
    String title, {
    String? trailing,
    Widget? trailingWidget,
    double topPadding = 0,
  }) {
    final Widget rightContent =
        trailingWidget ??
        (trailing != null
            ? Row(
                children: [
                  Text(
                    trailing,
                    style: const TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF8D95A4),
                    size: 22,
                  ),
                ],
              )
            : const Icon(
                Icons.chevron_right,
                color: Color(0xFF8D95A4),
                size: 22,
              ));

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: _text, fontSize: 17),
            ),
          ),
          rightContent,
        ],
      ),
    );
  }

  Widget _choiceRow(String title, String subtitle, {required bool selected}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _sub,
                    fontSize: 17,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check : Icons.circle_outlined,
            color: selected ? _pink : const Color(0xFFB7BFCC),
            size: 34,
          ),
        ],
      ),
    );
  }

  Widget _valueRow(String left, String right) {
    return Row(
      children: [
        Text(left, style: const TextStyle(color: _text, fontSize: 17)),
        const Spacer(),
        Text(right, style: const TextStyle(color: _sub, fontSize: 17)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: Color(0xFF8D95A4), size: 22),
      ],
    );
  }

  Widget _tinySwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = const Color(0xFF858E9E),
  }) {
    final bg = value ? activeColor : const Color(0xFFDCE1EA);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF9DA6B6)),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              value ? Icons.check : Icons.close,
              color: value ? _pink : const Color(0xFF7E8798),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  String _firstGender() {
    final list = _user?.gender;
    if (list == null || list.isEmpty) {
      return '女性';
    }
    return list.first.name;
  }

  Future<void> _showBoostSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F6F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF949CAB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF7A8090),
                    size: 52 / 1.7,
                  ),
                ),
              ),
              const Text(
                '我的 Boost',
                style: TextStyle(fontSize: 68 / 4, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                '在 30 分钟里成为你所在地区的热门会员，以达成更多配对!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF545B6D), fontSize: 45 / 4),
              ),
              const SizedBox(height: 18),
              _boostRow(icon: Icons.bolt, title: 'Boost', remain: '剩余 0 个'),
              const Divider(color: Color(0xFFD2D6DF), height: 24),
              _boostRow(
                icon: Icons.timer_outlined,
                title: '优时 Boost',
                remain: '剩余 0 个',
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E17FF), Color(0xFFC651FF)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    '获得更多 Boost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64 / 4,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _boostRow({
    required IconData icon,
    required String title,
    required String remain,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFA93AF5), size: 46),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1D2433),
                fontSize: 63 / 4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              remain,
              style: const TextStyle(
                color: Color(0xFF5E6576),
                fontSize: 53 / 4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
