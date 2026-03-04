import 'package:flutter/material.dart';

// ...existing code...
class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final List<Map<String, dynamic>> plans = [
    {'label': '热门', 'title': '1周', 'price': 'HK\$148.00/周', 'selected': true},
    {'label': '', 'title': '1个月', 'price': 'HK\$388.00/月', 'selected': false},
    {
      'label': '',
      'title': '6个月',
      'price': 'HK\$1,488.00/6个月',
      'selected': false,
    },
  ];
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    final isBottom = (maxScroll - current).abs() < 20;
    if (isBottom != _isBottom) {
      setState(() {
        _isBottom = isBottom;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Text(
                          '开通 Tinder Gold™ 可以查看给你点赞的人，然后快速和对方达成配对。',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Text(
                          '选择一个套餐',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 142,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          itemCount: plans.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, i) {
                            final plan = plans[i];
                            final isSelected = selectedIndex == i;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedIndex = i);
                              },
                              child: Container(
                                width: 210,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFF181820),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFFD700)
                                        : Colors.white24,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (plan['label'] != '')
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFD700),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            plan['label'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            plan['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isSelected)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Icon(
                                                Icons.check,
                                                color: Color(0xFFFFD700),
                                                size: 28,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Expanded(child: const SizedBox()),
                                      Text(
                                        plan['price'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Text(
                              'Tinder Gold™ 专属特权',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeature(title: '无限点赞'),
                            _buildFeature(title: '查看给你点赞的人'),
                            _buildFeature(title: '无限倒回'),
                            _buildFeature(
                              title: '每月 1 个免费 Boost',
                              sub: '购买一个月或更长时间的订阅，才可享受每月免费的 Boost。',
                            ),
                            _buildFeature(title: '每周免费 2 个 Super Like'),
                            _buildFeature(
                              title: '无限位置漫游模式',
                              sub: '你可以和世界各地的用户配对聊天。*含限制条件',
                            ),
                            _buildFeature(title: '管理你的个人资', sub: '仅显示你想公布的信息'),
                            _buildFeature(
                              title: '限制谁可以看到你',
                              sub: '你可以管理谁可以看到你',
                            ),
                            _buildFeature(
                              title: '管理你的可见用',
                              sub: '你可以选择你想要结识哪类用',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isBottom
                    ? _buildBottomBarImageStyle()
                    : _buildBottomBarDefault(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Image.asset('assets/tinder_logo.png', height: 32),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'GOLD',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature({String? title, String? sub}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                if (sub != null)
                  Text(
                    sub,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarDefault() {
    return Container(
      key: const ValueKey('default'),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            '当您点击“继续”后，我们将向您收取费用，您的订阅会以相同的套餐期限和价格续订，直至您在账号设置中取消续订。点击即表示您同意我们的条款。',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              elevation: 2,
            ),
            onPressed: () {},
            child: const Text(
              '继续',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarImageStyle() {
    return Container(
      key: const ValueKey('image'),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      color: Colors.black,
      child: Column(
        children: [
          const Text(
            '当您点击“继续”后，我们将向您收取费用，您的订阅会以相同的套餐期限和价格续订，直至您在账号设置中取消续订。点击即表示您同意我们的条款。',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 24),
              //   child:
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFFD700),
                        size: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '1周',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'HK\$148.00/周',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 24),
              //   child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(120, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 2,
                ),
                onPressed: () {},
                child: const Text(
                  '继续',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
