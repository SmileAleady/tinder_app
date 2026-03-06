import 'package:flutter/material.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/data/chat/chat_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/login/login_page.dart';
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
  bool _processingAuthAction = false;

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

  Future<void> _goToLoginPage() async {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _openLicensePage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LicenseListPage()));
  }

  Future<void> _openServiceTermsPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ServiceTermsPage()));
  }

  Future<void> _openCookiePolicyPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CookiePolicyPage()));
  }

  Future<void> _openPrivacyPolicyPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()));
  }

  Future<void> _openPrivacyPreferencePage() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PrivacyPreferencePage()),
    );
  }

  Future<void> _openMatchGroupPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MatchGroupInfoPage()));
  }

  Future<void> _handleLogout() async {
    if (_processingAuthAction) {
      return;
    }
    setState(() => _processingAuthAction = true);
    await UserAuthLocalDb.instance.logout();
    if (!mounted) {
      return;
    }
    await _goToLoginPage();
  }

  Future<void> _handleDeleteAccount() async {
    if (_processingAuthAction) {
      return;
    }

    final userId = _user?.userId;
    if (userId == null || userId.isEmpty) {
      await _handleLogout();
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('删除账户'),
          content: const Text('将删除本地账号信息和全部聊天记录，是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('确认删除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() => _processingAuthAction = true);
    await ChatLocalDb.instance.removeAllForUser(userId);
    await UserAuthLocalDb.instance.deleteUserById(userId);
    await UserAuthLocalDb.instance.logout();
    if (!mounted) {
      return;
    }
    await _goToLoginPage();
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
                        _entryRow('Cookie 政策', onTap: _openCookiePolicyPage),
                        _entryRow('隐私政策', onTap: _openPrivacyPolicyPage),
                        _entryRow('隐私偏好', onTap: _openPrivacyPreferencePage),
                        _entryRow('来自 Match Group', onTap: _openMatchGroupPage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('合法'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('许可证', onTap: _openLicensePage),
                        _entryRow('服务条款', onTap: _openServiceTermsPage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _processingAuthAction ? null : _handleLogout,
                    borderRadius: BorderRadius.circular(16),
                    child: _card(
                      child: Center(
                        child: Text(
                          _processingAuthAction ? '处理中...' : '登出',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
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
                  InkWell(
                    onTap: _processingAuthAction ? null : _handleDeleteAccount,
                    borderRadius: BorderRadius.circular(16),
                    child: _card(
                      child: Center(
                        child: Text(
                          _processingAuthAction ? '处理中...' : '删除账户',
                          style: const TextStyle(
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
    VoidCallback? onTap,
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

    final row = Padding(
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

    if (onTap == null) {
      return row;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: row,
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

class LicenseListPage extends StatelessWidget {
  const LicenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <({String name, String version, String license})>[
      (name: 'Android SDK hCaptcha', version: '4.4.0', license: 'MIT License'),
      (
        name: 'AutoValue Annotations',
        version: '1.6.3',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.android.datatransport:transport-api',
        version: '3.1.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-common',
        version: '21.0.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-messaging',
        version: '21.0.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-analytics',
        version: '18.2.0',
        license: 'Apache Version 2.0',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE7E8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF2D68),
        centerTitle: true,
        title: const Text(
          '许可证',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD3D8E1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF222938),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Text(
                      item.version,
                      style: const TextStyle(
                        color: Color(0xFF4E5668),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  item.license,
                  style: const TextStyle(
                    color: Color(0xFF556071),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ServiceTermsPage extends StatelessWidget {
  const ServiceTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TextDocPage(
      title: '服务条款',
      sections: const [
        _DocSectionData(
          title: '欢迎使用 Tinder 聊天服务',
          body: '本服务条款适用于你通过 Tinder App 使用匹配、聊天、举报与账号管理功能。继续使用即表示你同意遵守本条款。',
        ),
        _DocSectionData(
          title: '账号与安全',
          body: '你需要提供真实、完整的信息并妥善保管登录凭据。你应对账号下发生的行为负责。如发现异常登录，请立即修改密码并联系我们。',
        ),
        _DocSectionData(
          title: '使用规范',
          body: '你不得发布违法、骚扰、歧视、仇恨、欺诈或侵犯他人权利的内容。不得冒充他人，不得绕过平台安全机制，不得批量抓取或滥用接口。',
        ),
        _DocSectionData(
          title: '聊天与内容',
          body: '你对自己发送的消息负责。我们可能基于风控、举报或法律要求对内容进行审核、限制或下架，以保障平台与用户安全。',
        ),
        _DocSectionData(
          title: '订阅与虚拟权益',
          body: 'Boost、Super Like、订阅套餐等功能以购买页面说明为准。除法律另有规定，已消耗权益通常不可退回。',
        ),
        _DocSectionData(
          title: '封禁与终止',
          body: '若你违反本条款，我们可根据违规程度采取警告、限制、封禁、删除内容或终止服务。你可随时停止使用并申请删除账户。',
        ),
        _DocSectionData(
          title: '免责声明',
          body:
              '我们努力保证服务稳定，但不对持续不中断、绝对无误作保证。因网络、设备、第三方服务导致的问题，平台在法律允许范围内承担有限责任。',
        ),
        _DocSectionData(
          title: '条款更新',
          body: '我们可能更新本条款。重大变更会通过应用内提示等方式通知。更新后继续使用即视为接受新条款。',
        ),
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TextDocPage(
      title: '隐私政策',
      sections: const [
        _DocSectionData(
          title: '我们收集的信息',
          body: '我们会收集你提供的账号信息（邮箱、昵称、头像等）、使用信息（操作日志、设备信息）和聊天相关元数据，用于提供与优化服务。',
        ),
        _DocSectionData(
          title: '信息使用目的',
          body: '我们使用信息来完成账号登录、匹配推荐、消息投递、反作弊风控、问题排查和体验改进，也可能用于向你展示与你相关的功能推荐。',
        ),
        _DocSectionData(
          title: '信息共享',
          body: '除法律要求或你明确授权外，我们不会向无关第三方出售你的个人信息。必要时我们会与受托服务商共享最少必要信息。',
        ),
        _DocSectionData(
          title: '存储与安全',
          body: '我们采取合理安全措施保护你的数据，包括访问控制、加密传输、最小权限等。你也应保护好账号密码与设备安全。',
        ),
        _DocSectionData(
          title: '你的权利',
          body: '你可以访问、修改或删除个人资料，管理隐私偏好，注销账户并删除本地数据。你也可以联系支持渠道行使合法权利。',
        ),
        _DocSectionData(
          title: '未成年人保护',
          body: '本服务仅面向符合当地法律年龄要求的用户。若发现未成年人违规使用，我们会采取限制或删除账号等措施。',
        ),
        _DocSectionData(
          title: '政策更新与联系',
          body: '如政策发生变化，我们会在应用内更新并标注生效日期。若你有隐私问题，可通过“设置-帮助和支持”联系平台。',
        ),
      ],
    );
  }
}

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cookie 政策',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 10),
          const _WebHeader(),
          const SizedBox(height: 16),
          const Text(
            '会话和持久 cookie',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cookie 还可分为会话 cookie 和持久 cookie。会话 cookie 在你关闭浏览器后会失效，持久 cookie 可在一段时间内保留，以便记住偏好与提升体验。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '网络信标和 SDK 的用途',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '网络信标（像素标签）和 SDK 可帮助我们了解页面访问、消息送达与功能稳定性。它们不会单独识别你的真实身份，但会与服务性能分析配合使用。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '我们使用 cookie 做什么？',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          _cookieTypeTable(),
          const SizedBox(height: 16),
          const Text(
            '您如何控制 cookie？',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '你可以在设置中管理 Cookie 偏好。关闭某些类型可能影响个性化体验、推荐准确性或部分功能可用性。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '基于兴趣的广告工具',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '我们可能通过行业自律工具提供广告偏好管理入口。你可选择拒绝个性化广告，但并不意味着不再看到广告。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Google Analytics',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '我们使用 Google Analytics 了解功能使用趋势。你可通过浏览器插件或设备设置来限制相关统计。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '如何联系我们？',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '如你对 Cookie 政策有疑问，请在应用“帮助和支持”中提交请求，我们会尽快处理。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _cookieTypeTable() {
    Widget cell(String text, {bool strong = false}) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            height: 1.25,
            color: const Color(0xFF4F596A),
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: const Color(0xFFCAD1DC)),
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      children: [
        TableRow(
          children: [cell('Cookie 类型', strong: true), cell('描述', strong: true)],
        ),
        TableRow(
          children: [
            cell('必要 cookie', strong: true),
            cell('用于登录验证、会话安全和基础功能运行。'),
          ],
        ),
        TableRow(
          children: [
            cell('分析 cookie', strong: true),
            cell('用于统计功能使用、提升性能与稳定性。'),
          ],
        ),
        TableRow(
          children: [
            cell('广告营销 cookie', strong: true),
            cell('用于衡量营销活动效果，并减少重复展示。'),
          ],
        ),
        TableRow(
          children: [
            cell('社交网络 cookie', strong: true),
            cell('支持分享内容及第三方社交场景联动。'),
          ],
        ),
      ],
    );
  }
}

class PrivacyPreferencePage extends StatefulWidget {
  const PrivacyPreferencePage({super.key});

  @override
  State<PrivacyPreferencePage> createState() => _PrivacyPreferencePageState();
}

class _PrivacyPreferencePageState extends State<PrivacyPreferencePage> {
  bool requiredPermission = true;
  bool adPermission = true;
  bool marketingPermission = true;
  bool matchGroupPermission = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E8EC),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8292)),
        ),
        title: const Text(
          '隐私偏好中心',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '完成',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '和其它应用一样，如您使用 Tinder，我们及合作伙伴的追踪器将会存储和检索您设备上的信息。您可以在这里调整偏好。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF5A6475),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '管理权限',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
            ),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: '必要权限',
            subtitle: '这些是运行应用所需的基础权限，无法关闭。',
            value: requiredPermission,
            enabled: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: '同意启用广告权限',
            subtitle: '广告权限将默认启用，可进入“个性化定制广告权限”查看详情。',
            value: adPermission,
            onChanged: (v) => setState(() => adPermission = v),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: '同意启用营销权限',
            subtitle: '用于监测和提升营销活动有效性。',
            value: marketingPermission,
            onChanged: (v) => setState(() => marketingPermission = v),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: '同意启用 Match Group 数据共享',
            subtitle: '用于个性化体验和服务优化。',
            value: matchGroupPermission,
            onChanged: (v) => setState(() => matchGroupPermission = v),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                adPermission = true;
                marketingPermission = true;
                matchGroupPermission = true;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF2D68), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text(
              '全部同意启用',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              setState(() {
                adPermission = false;
                marketingPermission = false;
                matchGroupPermission = false;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF2D68), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text(
              '全部拒绝启用',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class MatchGroupInfoPage extends StatefulWidget {
  const MatchGroupInfoPage({super.key});

  @override
  State<MatchGroupInfoPage> createState() => _MatchGroupInfoPageState();
}

class _MatchGroupInfoPageState extends State<MatchGroupInfoPage> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '来自 Match Group',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _WebHeader(),
          const SizedBox(height: 16),
          const Text(
            'Tinder > 安全与隐私 > 隐私',
            style: TextStyle(fontSize: 17, color: Color(0xFF444C5A)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFCDD3DE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFF8D95A4), size: 30),
                SizedBox(width: 8),
                Text(
                  '搜索',
                  style: TextStyle(fontSize: 17, color: Color(0xFF8D95A4)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '为什么我们要在 Match Group 各公司之间共享讯息',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tinder 是 Match Group 旗下产品。我们可能会在集团内部共享必要数据，用于服务稳定、账号安全、风控防欺诈和体验优化。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF4F596A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '保护你和他人的安全',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '我们会在必要时共享风险信号，以识别虚假账号、垃圾内容、欺诈行为和严重违规。',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF4F596A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '• 调查并处理违法违规行为\n• 改进反骚扰与反欺诈能力\n• 在法律要求下配合执法机关',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF1F2533),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFCBD2DD)),
          const SizedBox(height: 10),
          const Text(
            '本文中的信息帮助了你多少？ *',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF1F2533),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final active = index < _rating;
              return IconButton(
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  active ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFF4C72),
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          const Text(
            '说说对此的想法：',
            style: TextStyle(fontSize: 17, color: Color(0xFF1F2533)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLength: 500,
            maxLines: 4,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: '请输入反馈内容',
              counterStyle: const TextStyle(
                fontSize: 17,
                color: Color(0xFF5B6476),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 140,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('提交成功')));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  '提交',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Powered by Medallia',
              style: TextStyle(fontSize: 17, color: Color(0xFF5D6678)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextDocPage extends StatelessWidget {
  const _TextDocPage({required this.title, required this.sections});

  final String title;
  final List<_DocSectionData> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sections[i].title,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF1F2533),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sections[i].body,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF4F596A),
                height: 1.35,
              ),
            ),
          ],
        ),
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemCount: sections.length,
      ),
    );
  }
}

class _DocSectionData {
  const _DocSectionData({required this.title, required this.body});
  final String title;
  final String body;
}

class _WebHeader extends StatelessWidget {
  const _WebHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6DBE3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.local_fire_department, color: Color(0xFFFF5A6F), size: 40),
          SizedBox(width: 6),
          Text(
            'tinder',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202736),
            ),
          ),
          Spacer(),
          Icon(Icons.menu, color: Color(0xFF667084), size: 32),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF1F2533),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFF2D68),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: const Color(0xFFFF2D68).withValues(alpha: 0.4),
            activeThumbColor: const Color(0xFFFF2D68),
          ),
        ],
      ),
    );
  }
}
