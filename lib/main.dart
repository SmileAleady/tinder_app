import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/page/chat/chat_page.dart';
import 'package:tinder_app/page/home_page.dart';
import 'package:tinder_app/page/like_page.dart';
import 'package:tinder_app/page/login/login_page.dart';
import 'package:tinder_app/page/profile_page.dart';
import 'package:tinder_app/page/search_page.dart';
import 'package:tinder_app/tool/event_bus.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinder App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      routes: {'/home': (_) => const MyHomePage(title: 'Tinder')},
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await UserAuthLocalDb.instance.ensureDefaultContactAccount();
    final user = await UserAuthLocalDb.instance.getActiveUser();
    if (!mounted) {
      return;
    }
    setState(() {
      _hasActiveSession = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_hasActiveSession) {
      return const MyHomePage(title: 'Tinder');
    }
    return const LoginPage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<int> _tabVersion = [0, 0, 0, 0, 0];
  int _likeCount = 0;
  StreamSubscription<LikeUsersChangedEvent>? _likeChangedSubscription;

  @override
  void initState() {
    super.initState();
    _refreshLikeCount();
    _likeChangedSubscription = eventBus.on<LikeUsersChangedEvent>().listen((_) {
      _refreshLikeCount();
    });
  }

  @override
  void dispose() {
    _likeChangedSubscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshLikeCount() async {
    final users = await OptionDataManager.getUserlike();
    if (!mounted) {
      return;
    }
    setState(() {
      _likeCount = users.length;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabVersion[index] = _tabVersion[index] + 1;
    });
    _refreshLikeCount();
  }

  @override
  Widget build(BuildContext context) {
    final isHomeTab = _selectedIndex == 0;
    final pageBackground = isHomeTab ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: pageBackground,
      body: Container(color: pageBackground, child: _buildCurrentPage()),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedIndex == 3)
            const Divider(height: 1, thickness: 1, color: Color(0xFFD1D7E2)),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    final key = ValueKey('tab-$_selectedIndex-${_tabVersion[_selectedIndex]}');
    switch (_selectedIndex) {
      case 0:
        return KeyedSubtree(key: key, child: HomePage());
      case 1:
        return KeyedSubtree(key: key, child: SearchPage());
      case 2:
        return KeyedSubtree(key: key, child: LikePage());
      case 3:
        return KeyedSubtree(key: key, child: ChatPage());
      case 4:
      default:
        return KeyedSubtree(key: key, child: ProfilePage());
    }
  }

  Widget _buildBottomNav() {
    final isDark = _selectedIndex == 0;
    final bg = isDark ? Colors.black : Colors.white;
    final selectedColor = isDark ? Colors.white : const Color(0xFF151C2B);
    final unselectedColor = isDark
        ? const Color(0xFF6E7A90)
        : const Color(0xFF7D8899);

    return Container(
      color: bg,
      padding: EdgeInsets.only(
        left: 6,
        right: 6,
        top: 6,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          _navItem(
            index: 0,
            label: 'Slide',
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            iconBuilder: (selected, color) => Icon(
              selected
                  ? Icons.local_fire_department
                  : Icons.local_fire_department_outlined,
              color: color,
              size: 36,
            ),
          ),
          _navItem(
            index: 1,
            label: 'Explore',
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            iconBuilder: (selected, color) => Icon(
              selected ? Icons.explore : Icons.explore_outlined,
              color: color,
              size: 34,
            ),
          ),
          _navItem(
            index: 2,
            label: 'Likes',
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            iconBuilder: (selected, color) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(
                  selected ? Icons.favorite : Icons.favorite_border,
                  color: color,
                  size: 34,
                ),
                Positioned(
                  top: -8,
                  right: -12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4C842),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_likeCount',
                        style: const TextStyle(
                          color: Color(0xFF1C2333),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _navItem(
            index: 3,
            label: 'Chat',
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            iconBuilder: (selected, color) => Icon(
              selected ? Icons.chat_bubble : Icons.chat_bubble_outline,
              color: color,
              size: 33,
            ),
          ),
          _navItem(
            index: 4,
            label: 'Profile',
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            iconBuilder: (selected, color) => Icon(
              selected ? Icons.person : Icons.person_outline,
              color: color,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required Color selectedColor,
    required Color unselectedColor,
    required Widget Function(bool selected, Color color) iconBuilder,
  }) {
    final selected = _selectedIndex == index;
    final color = selected ? selectedColor : unselectedColor;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: Center(child: iconBuilder(selected, color)),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
