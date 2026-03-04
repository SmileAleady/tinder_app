import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tinder_app/page/upgrade/upgrade_page.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> with TickerProviderStateMixin {
  final List<String> tags = ['全部', '旅行', '电影', '音乐', '有个人标签'];
  int selectedTag = 0;
  late PageController _pageController;

  //是否需要升级
  bool _isUpgrade = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTagTap(int index) {
    setState(() {
      selectedTag = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      '20 次赞',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: tags.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = selectedTag == index;
                        return GestureDetector(
                          onTap: () => _onTagTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white12
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              tags[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isUpgrade)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          '升级至 Gold 来看看赞过你的人。',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (!_isUpgrade) const SizedBox(height: 12),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: tags.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedTag = index;
                        });
                      },
                      itemBuilder: (context, pageIndex) {
                        // return _WaterfallGrid(tag: tags[pageIndex]);
                        return _WaterfallGrid(tag: tags[pageIndex]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE082), Color(0xFFFFC107)],
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '查看给你点赞的人',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class _WaterfallGrid extends StatelessWidget {
  final String tag;
  const _WaterfallGrid({required this.tag});

  @override
  Widget build(BuildContext context) {
    // 模拟数据
    final List<Map<String, String>> items = List.generate(
      8,
      (i) => {
        'image': 'assets/user${i % 4 + 1}.jpg',
        'title': '昵称${i + 1}',
        'subtitle': '描述信息',
      },
    );

    // return Container(
    //   width: double.infinity,
    //   height: double.infinity,
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 16),
    //         child: Text(
    //           '升级至 Gold 来看看赞过你的人。',
    //           style: const TextStyle(
    //             color: Colors.white,
    //             fontSize: 22,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),

    //       GridView.builder(
    //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           crossAxisSpacing: 16,
    //           mainAxisSpacing: 16,
    //           childAspectRatio: 0.7,
    //         ),
    //         itemCount: items.length,
    //         itemBuilder: (context, index) {
    //           final item = items[index];
    //           return _UserCard(item: item);
    //         },
    //       ),
    //     ],
    //   ),
    // );

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _UserCard(item: item);
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, String> item;
  const _UserCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const UpgradePage()));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 328,
          height: 408,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 背景层：可以替换为任意图片
              Container(
                color: Colors.grey[300],
                child: const Center(child: FlutterLogo(size: 100)),
              ),
              // 2. 毛玻璃模糊层
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
              // 3. 中心渐变暗区（模拟原图的模糊中心）
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.8],
                    ),
                  ),
                ),
              ),
              // 4. 底部的两个圆角条
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部白色条
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 底部灰色条
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Stack(
    //   children: [
    //     Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white10,
    //         borderRadius: BorderRadius.circular(18),
    //         image: DecorationImage(
    //           image: AssetImage(item['image']!),
    //           fit: BoxFit.cover,
    //           colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcATop),
    //         ),
    //       ),
    //     ),

    //     Positioned(
    //       bottom: 0,
    //       left: 0,
    //       right: 0,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 8,
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   height: 8,
    //                   width: 80,
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 8),
    //                 Container(
    //                   height: 8,
    //                   width: 60,
    //                   decoration: BoxDecoration(
    //                     color: Colors.black26,
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
