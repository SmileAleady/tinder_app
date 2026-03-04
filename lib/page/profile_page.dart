import 'package:flutter/material.dart';
import 'package:tinder_app/page/profile_edit/page/profile_edit_page.dart';
import 'package:tinder_app/page/upgrade/upgrade_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/home/gold_fire.png'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Duxu',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.verified,
                                    color: Colors.grey.shade600,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEditPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '编辑个人资料',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.settings, color: Colors.grey.shade600),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.26,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5A5F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.26 - 28,
                            top: -10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5A5F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '26%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '完善个人资料，让更多的人看到你！',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // completion tasks
              _buildCompletionTasks(),

              const SizedBox(height: 12),

              // small feature cards row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SmallFeatureCard(
                      icon: Icons.star,
                      labelTop: '0 个',
                      label: 'Super Like',
                    ),
                    _SmallFeatureCard(
                      icon: Icons.flash_on,
                      labelTop: '',
                      label: '我的 Boost',
                    ),
                    _SmallFeatureCard(
                      icon: Icons.local_fire_department,
                      labelTop: '',
                      label: '订阅套餐',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tinder Gold card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSubscriptionCard(),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionTasks() {
    final tasks = [
      {
        'icon': Icons.photo_camera,
        'title': '上传至少3张照片',
        'subtitle': '上传6张照片，至多可获双倍赞。',
        'percent': '+21%',
      },
      {
        'icon': Icons.edit,
        'title': '上传个人简介',
        'subtitle': '添加自我介绍，配对数量提高至多25%。',
        'percent': '+20%',
      },
      {
        'icon': Icons.verified_user,
        'title': '进行验证',
        'subtitle': '验证个人资料，提高资料可信度。',
        'percent': '+8%',
      },
    ];

    return Column(
      children: tasks.map((t) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      t['icon'] as IconData,
                      color: Colors.pink,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        t['percent'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t['subtitle'] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.add_circle_outline, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'tinder',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('GOLD'),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const UpgradePage()));
      },
                child: SizedBox(
                  width: 96,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '升级',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '专属功能',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('查看给你点赞的人'),
          const SizedBox(height: 6),
          const Text('最佳精选'),
          const SizedBox(height: 6),
          const Text('免费 Super Like'),
        ],
      ),
    );
  }
}

class _SmallFeatureCard extends StatelessWidget {
  final IconData icon;
  final String labelTop;
  final String label;

  const _SmallFeatureCard({
    required this.icon,
    required this.labelTop,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey.shade700, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              labelTop,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
