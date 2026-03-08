import 'package:flutter/material.dart';

class ProfileAboutMeSheet extends StatefulWidget {
  const ProfileAboutMeSheet({super.key});

  @override
  State<ProfileAboutMeSheet> createState() => _ProfileAboutMeSheetState();
}

class _ProfileAboutMeSheetState extends State<ProfileAboutMeSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Community Guidelines',
      'subtitle': 'Quick tips for "About Me"',
      'content': 'Social media usernames must not appear in your bio. If included, they will be removed.',
    },
    {
      'title': 'Community Guidelines',
      'subtitle': 'Quick tips for "About Me"',
      'content': 'Do not mention sexual kinks in your profile. Only discuss them in chat with consent.',
    },
    {
      'title': 'Community Guidelines',
      'subtitle': 'Quick tips for "About Me"',
      'content': 'This space is for personal connections only, not business networking.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 16),

          // 页面内容
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.shield, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            page['subtitle']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page['content']!,
                        style: const TextStyle(fontSize: 20, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          // 点击查看完整规则
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(text: 'Learn more about our '),
                              TextSpan(
                                text: 'Community Guidelines',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // 页面指示器
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.black
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // 底部导航栏（可选，模拟手机系统栏）
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.menu, size: 28),
              Icon(Icons.circle, size: 28),
              Icon(Icons.arrow_back_ios, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}
