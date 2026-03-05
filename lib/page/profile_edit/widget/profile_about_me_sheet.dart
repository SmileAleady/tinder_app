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
      'title': '社群规则',
      'subtitle': '"关于我"的快速提示',
      'content': '社交媒体用户名不能出现在个人介绍中，如有出现，它们将会被删除。',
    },
    {
      'title': '社群规则',
      'subtitle': '"关于我"的快速提示',
      'content': '请勿在个人资料中提及自己的性癖好。仅在获得聊天对象的同意后才在对话中提及。',
    },
    {
      'title': '社群规则',
      'subtitle': '"关于我"的快速提示',
      'content': '在这里只能建立个人联系，不能建立业务联系。',
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
                              TextSpan(text: '详细了解我们的'),
                              TextSpan(
                                text: '社群规则',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: '。'),
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
