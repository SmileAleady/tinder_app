import 'package:flutter/material.dart';
import 'package:tinder_app/widget/user_page.dart';

class HomePage extends StatefulWidget {
  final bool isFromSearchPage;
  const HomePage({super.key, this.isFromSearchPage = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _dragController;
  late AnimationController _nextCardController;

  // 用户数据列表
  final List<Map<String, String>> users = [
    {'name': 'Lee Na', 'age': '25', 'distance': '3公里远'},
    {'name': 'Emma Smith', 'age': '23', 'distance': '5公里远'},
    {'name': 'Sophia Chen', 'age': '26', 'distance': '2公里远'},
    {'name': 'Jessica Wang', 'age': '24', 'distance': '4公里远'},
  ];

  int currentUserIndex = 0;
  Offset dragOffset = Offset.zero;
  bool showNextCard = false;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _nextCardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    _nextCardController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragOffset = Offset(dragOffset.dx + details.delta.dx, dragOffset.dy);
    });

    // 当向左拖动超过50%屏幕宽度时，显示下一个卡片
    // final screenWidth = MediaQuery.of(context).size.width;
    // if (dragOffset.dx.abs() > screenWidth / 2) {
    if (dragOffset.dx.abs() > 10) {
      if (!showNextCard) {
        showNextCard = true;
        _nextCardController.forward();
      }
    } else {
      if (showNextCard) {
        showNextCard = false;
        _nextCardController.reverse();
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = dragOffset.dx.abs() / screenWidth;

    if (dragPercentage > 0.5) {
      // 划出卡片
      await _dragController.animateTo(1.0);
      setState(() {
        currentUserIndex = (currentUserIndex + 1) % users.length;
        dragOffset = Offset.zero;
        showNextCard = false;
      });
      _dragController.reset();
      _nextCardController.reset();
    } else {
      // 回到原位
      _dragController.reverse();
      setState(() {
        dragOffset = Offset.zero;
        showNextCard = false;
      });
      _nextCardController.reset();
    }
  }

  bool get isCardDragging {
    return dragOffset.dx.abs() > 0;
  }

  double get rejectButtonScale {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = (dragOffset.dx.abs() / screenWidth).clamp(0.0, 1.0);
    return dragOffset.dx < 0 ? 1.0 + dragPercentage * 1.5 : 1.0;
  }

  double get nopeOpacity {
    if (dragOffset.dx >= 0) return 0.0;
    final screenWidth = MediaQuery.of(context).size.width;
    return (dragOffset.dx.abs() / (screenWidth * 0.3)).clamp(0.0, 1.0);
  }

  double get nopeScale {
    if (dragOffset.dx >= 0) return 0.5;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = (dragOffset.dx.abs() / screenWidth).clamp(0.0, 1.0);
    return 0.5 + dragPercentage * 1.0;
  }

  double get likeOpacity {
    if (dragOffset.dx <= 0) return 0.0;
    final screenWidth = MediaQuery.of(context).size.width;
    return (dragOffset.dx / (screenWidth * 0.3)).clamp(0.0, 1.0);
  }

  double get likeScale {
    if (dragOffset.dx <= 0) return 0.5;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = (dragOffset.dx / screenWidth).clamp(0.0, 1.0);
    return 0.5 + dragPercentage * 1.0;
  }

  double get cardRotationAngle {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = (dragOffset.dx / screenWidth).clamp(-0.5, 0.5);
    return dragPercentage * 0.2; // 最大旋转角度
  }

  @override
  Widget build(BuildContext context) {
    final user = users[currentUserIndex];
    final nextUser = users[(currentUserIndex + 1) % users.length];

    return Scaffold(
      body: Stack(
        children: [
          // 下一个用户卡片（在后面）
          if (showNextCard)
            Positioned(
              top: 0,
              bottom: widget.isFromSearchPage == true ? 48 : 68,
              left: 0,
              right: 0,
              child: _buildBackUserCard(nextUser),
            ),
          // 当前用户卡片（可拖动）
          Positioned(
            top: 0,
            bottom: widget.isFromSearchPage == true ? 48 : 68,
            left: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: Transform.translate(
                offset: dragOffset,
                child: _buildUserCard(user),
              ),
            ),
          ),
          // 底部操作按钮
          Positioned(
            bottom: widget.isFromSearchPage == true ? 0 : 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 撤销按钮（橙色）
                  if (!isCardDragging)
                    _buildScalableActionButton(
                      icon: Icons.rotate_left,
                      color: const Color(0xFFFF8C42),
                      onPressed: () {},
                      scale: rejectButtonScale,
                    ),
                  // 不喜欢按钮（红色）
                  _buildScalableActionButton(
                    icon: Icons.close,
                    color: const Color(0xFFFF1744),
                    onPressed: () {},
                    scale: rejectButtonScale,
                  ),
                  // 超级喜欢按钮（蓝色）
                  if (!isCardDragging)
                    _buildScalableActionButton(
                      icon: Icons.star,
                      color: const Color(0xFF1E88E5),
                      onPressed: () {},
                      scale: rejectButtonScale,
                    ),
                  // 喜欢按钮（绿色心形）
                  if (!isCardDragging)
                    _buildScalableActionButton(
                      icon: Icons.favorite,
                      color: const Color(0xFF9CCC65),
                      onPressed: () {},
                      scale: rejectButtonScale,
                    ),
                  // 快速匹配按钮（蓝色闪电）
                  if (!isCardDragging)
                    _buildScalableActionButton(
                      icon: Icons.send,
                      color: const Color(0xFF64B5F6),
                      onPressed: () {},
                      scale: rejectButtonScale,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackUserCard(Map<String, String> user) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/profile.jpg'),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {},
        ),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          // 顶部渐变叠加层
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent],
                ),
              ),
            ),
          ),
          // 底部用户信息区域
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 最近活跃标志
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '最近活跃',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 名字和年龄
                  Row(
                    children: [
                      Text(
                        user['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user['age']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 位置信息
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user['distance']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, String> user) {
    return Transform.rotate(
      angle: cardRotationAngle,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/profile.jpg'),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
          color: Colors.grey[300],
        ),
        child: Stack(
          children: [
            // 顶部渐变叠加层
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black26, Colors.transparent],
                  ),
                ),
              ),
            ),
            // 底部用户信息区域
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 最近活跃标志
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '最近活跃',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {
                            ///跳转 UserPage
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const UserPage(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_circle_up,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 名字和年龄
                    Row(
                      children: [
                        Text(
                          user['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user['age']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 位置信息
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user['distance']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // NOPE 标签（向左拖动时显示）
            Positioned(
              top: 80,
              left: 20,
              child: Transform.scale(
                scale: nopeScale,
                child: Opacity(
                  opacity: nopeOpacity,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFF1744),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NOPE',
                        style: TextStyle(
                          color: Color(0xFFFF1744),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // LIKE 标签（向右拖动时显示）
            Positioned(
              top: 80,
              right: 20,
              child: Transform.scale(
                scale: likeScale,
                child: Opacity(
                  opacity: likeOpacity,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF1E88E5),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Color(0xFFFFD700),
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LIKE',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
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

  Widget _buildScalableActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double scale,
  }) {
    return Transform.scale(
      scale: scale.clamp(0.3, 2.0),
      child: Opacity(
        opacity: scale < 0.5 ? scale * 2 : 1.0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2C2F3E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(28),
              child: Icon(icon, color: color, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
