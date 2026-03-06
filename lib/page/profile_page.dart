import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/profile_edit/page/profile_edit_page.dart';
import 'package:tinder_app/page/setting/setting.dart';
import 'package:tinder_app/page/upgrade/upgrade_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _packageController = PageController(
    viewportFraction: 0.93,
  );
  int _packageIndex = 0;

  UserProfileModel? _activeUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _packageController.addListener(_onPackageScroll);
    _loadActiveUser();
  }

  @override
  void dispose() {
    _packageController.removeListener(_onPackageScroll);
    _packageController.dispose();
    super.dispose();
  }

  Future<void> _loadActiveUser() async {
    final active = await UserAuthLocalDb.instance.getActiveUser();

    UserProfileModel? model = active;
    if (model == null) {
      final seed = OptionDataManager.getUserList();
      if (seed.isNotEmpty) {
        model = seed.first;
      }
    }

    if (model != null) {
      await UserAuthLocalDb.instance.upsertUser(model, keepActive: true);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _activeUser = model;
      _loading = false;
    });
  }

  void _onPackageScroll() {
    if (!_packageController.hasClients) {
      return;
    }
    final idx = (_packageController.page ?? 0).round().clamp(0, 2);
    if (idx != _packageIndex) {
      setState(() {
        _packageIndex = idx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE7E8EC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_activeUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFE7E8EC),
        body: Center(child: Text('请先登录后查看个人资料')),
      );
    }

    final user = _activeUser!;
    final completion = _completionPercent(user);
    final tasks = _incompleteTasks(user);

    return Scaffold(
      backgroundColor: const Color(0xFFE7E8EC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadActiveUser,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 18),
            children: [
              _buildHeader(user),
              const SizedBox(height: 10),
              _buildProgress(completion),
              const SizedBox(height: 10),
              ...tasks.map((task) => _taskCard(task)),
              const SizedBox(height: 10),
              _actionTiles(),
              const SizedBox(height: 10),
              _packageSlider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserProfileModel user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatar(user, 60),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.nikeName.isEmpty ? 'Duxu' : user.nikeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1D2332),
                          fontSize: 53 / 4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.verified_outlined,
                      color: Color(0xFF8E96A6),
                      size: 17,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileEditPage(),
                      ),
                    );
                    await _loadActiveUser();
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 15),
                        SizedBox(width: 7),
                        Text(
                          '编辑个人资料',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingPage()));
              await _loadActiveUser();
            },
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF4E5567),
              size: 42 / 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(int percent) {
    final ratio = (percent / 100).clamp(0.02, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final indicatorX = (constraints.maxWidth * ratio) - 40;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 12,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF656D7D),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 12,
                      child: Container(
                        width: constraints.maxWidth * ratio,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2C67),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Positioned(
                      left: indicatorX.clamp(0, constraints.maxWidth - 80),
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2C67),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$percent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '完善个人资料，让更多的人看到你!',
            style: TextStyle(
              color: Color(0xFF5C6272),
              fontSize: 47 / 4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(_ProfileTask task) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            child: Column(
              children: [
                Icon(task.icon, size: 28, color: const Color(0xFFFF5A9A)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    task.percent,
                    style: const TextStyle(
                      color: Color(0xFFFF2E6D),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Color(0xFF181E2C),
                    fontSize: 49 / 4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  task.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF616878),
                    fontSize: 46 / 4,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF98A0AF), width: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _actionTile(
              icon: Icons.star,
              iconColor: const Color(0xFF1087CF),
              title: '0 个 Super Like',
              sub: '获得更多',
              subColor: const Color(0xFF1878DA),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SuperLikePage()),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionTile(
              icon: Icons.bolt,
              iconColor: const Color(0xFF9624FA),
              title: '我的 Boost',
              sub: '获得更多',
              subColor: const Color(0xFFA029FF),
              onTap: _showBoostSheet,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionTile(
              icon: Icons.local_fire_department,
              iconColor: const Color(0xFFFF2D63),
              title: '订阅套餐',
              sub: '',
              subColor: const Color(0xFF5A6172),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MySubscriptionPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String sub,
    required Color subColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4D5567),
                    fontSize: 42 / 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (sub.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    style: TextStyle(
                      color: subColor,
                      fontSize: 43 / 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: -6,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F2F4),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA8AEBB)),
              ),
              child: const Icon(Icons.add, size: 15, color: Color(0xFF667083)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _packageSlider() {
    final cards = <_PackageCardData>[
      _PackageCardData(
        bg: const Color(0xFFF8E9AE),
        text: const Color(0xFF1F2533),
        name: 'GOLD',
        logoColor: const Color(0xFFE5AF0E),
        buttonStart: const Color(0xFFE2B429),
        buttonEnd: const Color(0xFFE8C141),
        rightTitle: '免费  Gold',
        rows: const ['查看给你点赞的人', '最佳精选', '免费 Super Like'],
      ),
      _PackageCardData(
        bg: const Color(0xFFD8DCE5),
        text: const Color(0xFF1F2533),
        name: 'PLATINUM',
        logoColor: const Color(0xFF0F1218),
        buttonStart: const Color(0xFF2A313E),
        buttonEnd: const Color(0xFF495364),
        rightTitle: '免费  Platinum',
        rows: const ['置顶赞', '附加信息促配对', '查看给你点赞的人'],
      ),
      _PackageCardData(
        bg: const Color(0xFFF4CDD6),
        text: const Color(0xFF1F2533),
        name: 'PLUS',
        logoColor: const Color(0xFFFF2A61),
        buttonStart: const Color(0xFFFF2D63),
        buttonEnd: const Color(0xFFFF5360),
        rightTitle: '免费  Plus',
        rows: const ['无限点赞次数', '无限倒回', '位置漫游'],
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _packageController,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final item = cards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: item.bg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFD0D4DC),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: item.logoColor,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'tinder',
                            style: TextStyle(
                              color: Color(0xFF1E2432),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                color: Color(0xFF293041),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [item.buttonStart, item.buttonEnd],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '升级',
                                style: TextStyle(
                                  color: Color(0xFF1C2432),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            '专属功能',
                            style: TextStyle(
                              color: Color(0xFF1F2533),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.rightTitle,
                            style: const TextStyle(
                              color: Color(0xFF1F2533),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ...item.rows.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  line,
                                  style: const TextStyle(
                                    color: Color(0xFF1F2533),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.lock,
                                color: Color(0xFF1F2533),
                                size: 12,
                              ),
                              const SizedBox(width: 18),
                              const Icon(
                                Icons.check,
                                color: Color(0xFF1F2533),
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Center(
                        child: Text(
                          '查看所有高级功能',
                          style: TextStyle(
                            color: Color(0xFF1F2533),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final selected = i == _packageIndex;
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: selected ? Colors.black : const Color(0xFF9299A8),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
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

  Widget _avatar(UserProfileModel user, double size) {
    if (user.mediaUrls.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          user.mediaUrls.first,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _avatarFallback(user, size),
        ),
      );
    }
    return _avatarFallback(user, size);
  }

  Widget _avatarFallback(UserProfileModel user, double size) {
    final text = user.nikeName.isEmpty ? 'U' : user.nikeName.substring(0, 1);
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFCED2DB),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF4A5060),
            fontSize: size / 4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  int _completionPercent(UserProfileModel user) {
    const total = 16;
    var done = 0;

    if (user.mediaUrls.length >= 3) done++;
    if (user.aboutMe.trim().isNotEmpty) done++;
    if (user.nikeName.trim().isNotEmpty) done++;
    if (user.prompts.isNotEmpty) done++;
    if (user.interests.isNotEmpty) done++;
    if (user.relationshipGoal != null) done++;
    if (user.languages.isNotEmpty) done++;
    if (user.height != null) done++;
    if ((user.jobTitle ?? '').trim().isNotEmpty) done++;
    if ((user.company ?? '').trim().isNotEmpty) done++;
    if ((user.school ?? '').trim().isNotEmpty) done++;
    if ((user.city ?? '').trim().isNotEmpty) done++;
    if (user.favoriteSong != null) done++;
    if ((user.gender ?? <GenderModel>[]).isNotEmpty) done++;
    if ((user.sexualOrientation ?? <SexualOrientationModel>[]).isNotEmpty) {
      done++;
    }
    if (user.age != null) done++;

    final percent = (done * 100 / total).round();
    return percent.clamp(0, 100);
  }

  List<_ProfileTask> _incompleteTasks(UserProfileModel user) {
    final list = <_ProfileTask>[];

    if (user.mediaUrls.length < 3) {
      list.add(
        const _ProfileTask(
          icon: Icons.image,
          title: '上传至少3张照片',
          subtitle: '上传6张照片，至多可获双倍赞。',
          percent: '+21%',
        ),
      );
    }

    if (user.aboutMe.trim().isEmpty) {
      list.add(
        const _ProfileTask(
          icon: Icons.edit,
          title: '上传个人简介',
          subtitle: '添加自我介绍，配对数量提高至多25%。',
          percent: '+20%',
        ),
      );
    }

    if ((user.gender ?? <GenderModel>[]).isEmpty ||
        (user.sexualOrientation ?? <SexualOrientationModel>[]).isEmpty) {
      list.add(
        const _ProfileTask(
          icon: Icons.verified,
          title: '进行验证',
          subtitle: '验证个人资料，提高资料可信度。',
          percent: '+8%',
        ),
      );
    }

    if (list.isEmpty) {
      list.add(
        const _ProfileTask(
          icon: Icons.check_circle,
          title: '资料已较完整',
          subtitle: '继续补充更多信息可获得更多曝光。',
          percent: '+5%',
        ),
      );
    }

    return list;
  }
}

class _ProfileTask {
  final IconData icon;
  final String title;
  final String subtitle;
  final String percent;

  const _ProfileTask({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.percent,
  });
}

class _PackageCardData {
  final Color bg;
  final Color text;
  final String name;
  final Color logoColor;
  final Color buttonStart;
  final Color buttonEnd;
  final String rightTitle;
  final List<String> rows;

  const _PackageCardData({
    required this.bg,
    required this.text,
    required this.name,
    required this.logoColor,
    required this.buttonStart,
    required this.buttonEnd,
    required this.rightTitle,
    required this.rows,
  });
}

class SuperLikePage extends StatefulWidget {
  const SuperLikePage({super.key});

  @override
  State<SuperLikePage> createState() => _SuperLikePageState();
}

class _SuperLikePageState extends State<SuperLikePage> {
  final PageController _controller = PageController(viewportFraction: 0.86);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final next = (_controller.page ?? 0).round();
      if (next != _index && mounted) {
        setState(() {
          _index = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = const [
      ('3 Super Like', 'HK\$26.00/个', ''),
      ('15 Super Like', 'HK\$20.50/个', '热门'),
      ('30 Super Like', 'HK\$17.00/个', '超值'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 48 / 1.8),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: Color(0xFF27A8F1),
                  size: 38 / 1.5,
                ),
                const SizedBox(width: 8),
                const Text(
                  '获取 Super Like',
                  style: TextStyle(
                    color: Color(0xFF1F2534),
                    fontSize: 62 / 4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '使用 Super Like 吸引 Ta 的目\n光吧，让你的配对成功几率提高\n3 倍!',
              style: TextStyle(
                color: Color(0xFF1F2534),
                fontSize: 86 / 4,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '选择一个套餐',
              style: TextStyle(
                color: Color(0xFF1F2534),
                fontSize: 78 / 4,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _controller,
                itemCount: cards.length,
                itemBuilder: (context, i) {
                  final item = cards[i];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FA),
                      border: Border.all(
                        color: const Color(0xFFC7CBD4),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.$3.isNotEmpty)
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: Color(0xFF1784DD),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        Text(
                          item.$1,
                          style: const TextStyle(
                            color: Color(0xFF1F2534),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: Color(0xFF1F2534),
                            fontSize: 61 / 4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF198DDD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              '选择',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final selected = i == _index;
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1F2534)
                        : const Color(0xFF98A0AF),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(height: 2, color: const Color(0xFFD1D5DF)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '或',
                    style: TextStyle(
                      color: Color(0xFF555C6B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(height: 2, color: const Color(0xFFD1D5DF)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC9CDD5), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9EBF0),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '包括 2 次免费 Super Like 每 1 周',
                        style: TextStyle(
                          color: Color(0xFF2C3446),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFE1B11F),
                          size: 48 / 1.4,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '开通 Tinder Gold™',
                          style: TextStyle(
                            color: Color(0xFF1D2332),
                            fontSize: 64 / 4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const UpgradePage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFC7CBD5),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            minimumSize: const Size(20, 30),
                          ),
                          child: const Text(
                            '选择',
                            style: TextStyle(
                              color: Color(0xFF293041),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySubscriptionPage extends StatefulWidget {
  const MySubscriptionPage({super.key});

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage> {
  final PageController _controller = PageController(viewportFraction: 0.86);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final idx = (_controller.page ?? 0).round();
      if (idx != _index && mounted) {
        setState(() {
          _index = idx;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logos = const [
      ('tinder +', Color(0xFFF4CDD6), Color(0xFFFF3A66)),
      ('tinder gold', Color(0xFFF9EAB2), Color(0xFFE2B327)),
      ('tinder platinum', Color(0xFFDDE0E8), Color(0xFF2E3443)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0F4),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 52 / 1.8),
                    ),
                    const Spacer(),
                    const Text(
                      '我的订阅',
                      style: TextStyle(
                        color: Color(0xFF1D2332),
                        fontSize: 70 / 4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: logos.length,
                    itemBuilder: (context, i) {
                      final item = logos[i];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: item.$2,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: item.$3, width: 5),
                        ),
                        child: Center(
                          child: Text(
                            item.$1,
                            style: const TextStyle(
                              color: Color(0xFF1D2332),
                              fontSize: 88 / 4,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final selected = i == _index;
                    return Container(
                      width: 17,
                      height: 17,
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1E2433)
                            : const Color(0xFF97A0AF),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                _featureSection(
                  tag: '升级你的赞',
                  items: const [
                    ('无限点赞', true),
                    ('查看给你点赞的人', false),
                    ('顶置赞', false),
                  ],
                  desc: '置顶赞可以让你赞的人更快看到你。',
                ),
                const SizedBox(height: 14),
                _featureSection(
                  tag: '升级你的体验',
                  items: const [
                    ('无限倒回', true),
                    ('每月 1 个免费 Boost', false),
                    ('每周 3 个免费 Super Like', false),
                    ('每周 3 次免费初印象', false),
                  ],
                  desc: '配对前可发送信息赢得好感。',
                ),
                const SizedBox(height: 14),
                _featureSection(
                  tag: '高级探索',
                  items: const [('无限位置漫游模式*', true)],
                  desc: '你可以和世界各地的用户配对聊天。*含限制条件。',
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18 + MediaQuery.of(context).padding.bottom,
              child: Container(
                height: 78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF2E64), Color(0xFFFF644D)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    '价格为 HK\$100.00 起',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 74 / 4,
                      fontWeight: FontWeight.w800,
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

  Widget _featureSection({
    required String tag,
    required List<(String, bool)> items,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFC7CBD5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F8),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFC7CBD5), width: 2),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: Color(0xFF2C3345),
                  fontSize: 49 / 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...items.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    row.$2 ? Icons.check : Icons.lock,
                    color: row.$2
                        ? const Color(0xFFFF5963)
                        : const Color(0xFF7E8797),
                    size: 40 / 1.5,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      row.$1,
                      style: const TextStyle(
                        color: Color(0xFF2A3142),
                        fontSize: 77 / 4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Text(
            desc,
            style: const TextStyle(
              color: Color(0xFF5A6071),
              fontSize: 58 / 4,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
