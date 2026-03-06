import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/search_page.dart';

class UserPage extends StatefulWidget {
  final UserProfileModel userProfile;
  const UserPage({Key? key, required this.userProfile});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  bool _expandMoreInfo = false;

  // Mock data
  List<String> mockImages = [];

  final List<SectionItem> _sections = [
    SectionItem(
      title: '我的更多信息',
      array: [
        CardItem(
          title: '教育情况',
          subtitle: '学士',
          image: 'assets/long_term.png',
          color: Colors.red.shade700,
        ),
        CardItem(
          title: '人格类型',
          subtitle: '水 ENTJ',
          image: 'assets/short_term.png',
          color: Colors.red.shade400,
        ),
        CardItem(
          title: 'title - 3',
          subtitle: '学士',
          image: 'assets/long_term.png',
          color: Colors.red.shade700,
        ),
        CardItem(
          title: 'title - 4',
          subtitle: '水 ENTJ',
          image: 'assets/short_term.png',
          color: Colors.red.shade400,
        ),
        CardItem(
          title: 'title - 5',
          subtitle: '学士',
          image: 'assets/long_term.png',
          color: Colors.red.shade700,
        ),
        CardItem(
          title: 'title - 6',
          subtitle: '水 ENTJ',
          image: 'assets/short_term.png',
          color: Colors.red.shade400,
        ),
        CardItem(
          title: 'title - 7',
          subtitle: '学士',
          image: 'assets/long_term.png',
          color: Colors.red.shade700,
        ),
        CardItem(
          title: 'title - 8',
          subtitle: '水 ENTJ',
          image: 'assets/short_term.png',
          color: Colors.red.shade400,
        ),
      ],
    ),
    SectionItem(
      title: '生活方式',
      array: [
        CardItem(
          title: '饮酒',
          subtitle: '遇到特殊场合才喝',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
        CardItem(
          title: '你多久抽一次烟？',
          subtitle: '在社交时吸烟',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
        CardItem(
          title: '健身情况',
          subtitle: '每周锻炼3-4次',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
        CardItem(
          title: '饮食偏好',
          subtitle: '偏爱清淡口味',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
        CardItem(
          title: '社交媒体活跃度',
          subtitle: '◎ 不常上网',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),

        CardItem(
          title: '睡眠习惯',
          subtitle: '时「',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    mockImages =
        (widget.userProfile.mediaUrls != null &&
            widget.userProfile.mediaUrls!.isNotEmpty)
        ? widget.userProfile.mediaUrls!
        : [];
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onImageTap() {
    int nextIndex = (_currentImageIndex + 1) % mockImages.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // 预留顶部空间
                SizedBox(height: kToolbarHeight + 24),

                // 轮播图
                _buildCarouselBanner(),

                // 基本信息及关键信息
                _buildBasicInfo(),

                // 更多信息部分
                _buildMoreInfo(),
                SizedBox(height: 80), // 底部按钮预留空间
              ],
            ),
          ),

          // 顶部固定AppBar
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),

          Positioned(
            bottom: 16 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: // 底部操作按钮
                _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFF1a1a1a),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top,
        16,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧：日期和认证
          Row(
            children: [
              const Text(
                'Feb 27',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
          // 右侧：下载按钮
          InkWell(
            onTap: () {
              // 关闭当前页
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4458),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.arrow_downward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselBanner() {
    return Column(
      children: [
        // 顶部指示器
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mockImages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? Colors.grey[400]
                      : Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        // 轮播图
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            itemCount: mockImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _onImageTap,
                child: Container(
                  color: Colors.grey[800],
                  child: Image.network(
                    mockImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image ${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索栏：我想要
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[500], size: 20),
                const SizedBox(width: 8),
                Text(
                  '我想要',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 我还在思考
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('🤔', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                const Text(
                  '我还在思考',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 关键信息
          Text(
            '关键信息',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 距离
          _buildInfoItem('📍', '50 公里远'),
          const SizedBox(height: 12),

          // 身高
          _buildInfoItem('📏', '170 厘米'),
          const SizedBox(height: 12),

          // 职业
          _buildInfoItem('💼', '律师助理'),
          const SizedBox(height: 12),

          // 学校
          _buildInfoItem('🎓', '东吴大学'),
          const SizedBox(height: 12),

          // 居住地
          _buildInfoItem('🏠', '居住 某某市'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[700]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton('❌', Colors.grey[700]!),
          const SizedBox(width: 20),
          _buildActionButton('⭐', const Color(0xFF4444FF)),
          const SizedBox(width: 20),
          _buildActionButton('💚', const Color(0xFFAAFF00)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String emoji, Color bgColor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
    );
  }

  Widget _buildMoreInfo() {
    // 计算总信息数量
    int totalItems = _sections.fold(
      0,
      (sum, section) => sum + section.array.length,
    );

    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 遍历 _sections 来生成内容
          ..._sections
              .expand(
                (section) => [
                  _buildSectionTitle(section.title),
                  const SizedBox(height: 12),
                  ...section.array
                      .take(_expandMoreInfo ? section.array.length : 4)
                      .expand(
                        (item) => [
                          _buildSectionSubtitle(item.title),
                          _buildInfoText(item.subtitle),
                          const SizedBox(height: 12),
                        ],
                      )
                      .toList(),
                  if (section.array.length > 4) const SizedBox(height: 12),
                  // 查看所有信息
                  if (section.array.length > 4)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandMoreInfo = !_expandMoreInfo;
                          });
                        },
                        child: Text(
                          _expandMoreInfo
                              ? '收起 ˄'
                              : '查看所有 ${section.array.length} 项信息 ˅',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              )
              .toList(),

          const SizedBox(height: 24),

          // 屏蔽按钮
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '屏蔽Feb',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 举报按钮
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '举报 Feb',
                style: TextStyle(
                  color: Color(0xFFFF4458),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(color: Colors.grey[400], fontSize: 12),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
