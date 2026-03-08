import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/data/home/home_swipe_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/widget/user_page.dart';

class HomePage extends StatefulWidget {
  final bool isFromSearchPage;
  final String? searchType;
  const HomePage({
    super.key,
    this.isFromSearchPage = false,
    this.searchType,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _swipeController;

  final List<UserProfileModel> _users = <UserProfileModel>[];
  String _activeUserId = 'guest';

  Offset _dragOffset = Offset.zero;
  Animation<Offset>? _swipeAnimation;

  bool _isLoading = true;
  bool _isAnimating = false;

  double _cardWidth = 0;
  Map<String, int> _photoIndexByUserId = <String, int>{};

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _swipeController.addListener(() {
      final anim = _swipeAnimation;
      if (anim == null || !mounted) {
        return;
      }
      setState(() {
        _dragOffset = anim.value;
      });
    });
    _loadData();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final active = await UserAuthLocalDb.instance.getActiveUser();
    final activeUserId = active?.userId ?? 'guest';
    final searchType = widget.searchType;
    final List<UserProfileModel> feedUsers;
    if (searchType != null && searchType.trim().isNotEmpty) {
      final typedUsers = OptionDataManager.getUserListBySearchType(searchType);
      await HomeSwipeLocalDb.instance.replaceFeedUsers(
        activeUserId: activeUserId,
        users: typedUsers,
      );
      feedUsers = typedUsers;
    } else {
      final fallbackUsers = OptionDataManager.getUserList();
      feedUsers = await HomeSwipeLocalDb.instance.getFeedUsers(
        activeUserId,
        fallbackUsers,
      );
    }
    _normalizeFeedUserPhotos(feedUsers);
    final photoIndexMap = <String, int>{};
    for (final user in feedUsers) {
      photoIndexMap[user.userId] = 0;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _activeUserId = activeUserId;
      _users
        ..clear()
        ..addAll(feedUsers);
      _photoIndexByUserId = photoIndexMap;
      _isLoading = false;
    });
  }

  Future<void> _refreshUsersWhenEmpty() async {
    final random = math.Random();
    final source = OptionDataManager.getUserList();
    if (source.isEmpty) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final generated = List<UserProfileModel>.generate(10, (index) {
      final template = source[random.nextInt(source.length)];
      final raw = Map<String, dynamic>.from(template.toJson());
      raw['userId'] = 'refresh_${_activeUserId}_${now}_$index';
      raw['nikeName'] = '${template.nikeName}${100 + random.nextInt(900)}';
      raw['distance'] = (1 + random.nextInt(30)).toDouble();
      raw['age'] = 18 + random.nextInt(15);
      return UserProfileModel.fromJson(raw);
    });

    _normalizeFeedUserPhotos(generated);
    await HomeSwipeLocalDb.instance.replaceFeedUsers(
      activeUserId: _activeUserId,
      users: generated,
    );

    if (!mounted) {
      return;
    }
    final photoIndexMap = <String, int>{for (final user in generated) user.userId: 0};
    setState(() {
      _users
        ..clear()
        ..addAll(generated);
      _photoIndexByUserId = photoIndexMap;
    });
  }

  void _normalizeFeedUserPhotos(List<UserProfileModel> users) {
    final random = math.Random();
    final imagePool = List<String>.generate(19, (i) => 'assets/user/$i.png');
    for (final user in users) {
      final valid = user.mediaUrls
          .where((item) => item.startsWith('assets/user/'))
          .toList();
      if (valid.length >= 2) {
        user.mediaUrls
          ..clear()
          ..addAll(valid);
        continue;
      }
      final perUserPool = List<String>.from(imagePool)..shuffle(random);
      final count = 3 + random.nextInt(3);
      user.mediaUrls
        ..clear()
        ..addAll(perUserPool.take(count));
    }
  }

  bool get _isDragging => _dragOffset.dx.abs() > 0.1;

  bool get _showNextCard {
    return _users.length > 1 && (_isDragging || _isAnimating);
  }

  double get _swipeThreshold {
    if (_cardWidth <= 0) {
      return 180;
    }
    return _cardWidth * 0.5;
  }

  double get _dragProgress {
    return (_dragOffset.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
  }

  bool get _isLeftDrag => _dragOffset.dx < 0;

  bool get _isRightDrag => _dragOffset.dx > 0;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating || _users.isEmpty) {
      return;
    }
    setState(() {
      _dragOffset = Offset(_dragOffset.dx + details.delta.dx, 0);
    });
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_isAnimating || _users.isEmpty) {
      return;
    }

    final shouldDismiss = _dragOffset.dx.abs() >= _swipeThreshold;
    if (!shouldDismiss) {
      await _animateCardTo(Offset.zero, shouldDismiss: false, liked: false);
      return;
    }

    final direction = _dragOffset.dx.isNegative ? -1.0 : 1.0;
    await _animateCardTo(
      Offset(direction * (_cardWidth + 120), 0),
      shouldDismiss: true,
      liked: direction > 0,
    );
  }

  Future<void> _onRejectTap() async {
    if (_isAnimating || _users.isEmpty) {
      return;
    }
    await _animateCardTo(
      Offset(-(_cardWidth + 120), 0),
      shouldDismiss: true,
      liked: false,
    );
  }

  Future<void> _onLikeTap() async {
    if (_isAnimating || _users.isEmpty) {
      return;
    }
    await _animateCardTo(
      Offset(_cardWidth + 120, 0),
      shouldDismiss: true,
      liked: true,
    );
  }

  Future<void> _animateCardTo(
    Offset target, {
    required bool shouldDismiss,
    required bool liked,
  }) async {
    if (_users.isEmpty) {
      return;
    }

    setState(() {
      _isAnimating = true;
    });

    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _swipeController
      ..reset()
      ..duration = Duration(milliseconds: shouldDismiss ? 230 : 260);

    await _swipeController.forward();

    if (shouldDismiss && _users.isNotEmpty) {
      final removedUser = _users.first;
      setState(() {
        _users.removeAt(0);
        _photoIndexByUserId.remove(removedUser.userId);
        _dragOffset = Offset.zero;
      });
      await HomeSwipeLocalDb.instance.consumeTopCard(
        activeUserId: _activeUserId,
        user: removedUser,
        liked: liked,
      );
    } else {
      setState(() {
        _dragOffset = Offset.zero;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isAnimating = false;
    });
  }

  List<String> _userPhotos(UserProfileModel user) {
    return user.mediaUrls
        .where((item) => item.startsWith('assets/user/'))
        .toList();
  }

  void _onCardTap() {
    if (_users.isEmpty || _isAnimating || _isDragging) {
      return;
    }
    final topUser = _users.first;
    final photos = _userPhotos(topUser);
    if (photos.length <= 1) {
      return;
    }
    final current = _photoIndexByUserId[topUser.userId] ?? 0;
    setState(() {
      _photoIndexByUserId[topUser.userId] = (current + 1) % photos.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cardWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _users.isEmpty
            ? RefreshIndicator(
                onRefresh: _refreshUsersWhenEmpty,
                color: Colors.white,
                backgroundColor: const Color(0xFF202638),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: _buildEmptyState(),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  if (_showNextCard)
                    Positioned.fill(
                      bottom: widget.isFromSearchPage ? 48 : 68,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Transform.scale(
                          scale: 0.96,
                          child: _buildProfileCard(_users[1], isTopCard: false),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    bottom: widget.isFromSearchPage ? 48 : 68,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _onCardTap,
                      onHorizontalDragUpdate: _onDragUpdate,
                      onHorizontalDragEnd: _onDragEnd,
                      child: Transform.translate(
                        offset: _dragOffset,
                        child: Transform.rotate(
                          angle:
                              (_dragOffset.dx / _cardWidth).clamp(-0.35, 0.35) *
                              0.18,
                          child: _buildProfileCard(
                            _users.first,
                            isTopCard: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //_buildTopHintBar(),
                  _buildTopDots(),
                  _buildRewindButton(),
                  if (_isLeftDrag) _buildOverlayBadge(isLike: false),
                  if (_isRightDrag) _buildOverlayBadge(isLike: true),
                  _buildBottomActions(),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white70,
              size: 52,
            ),
            const SizedBox(height: 12),
            const Text(
              'No more nearby users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Liked users are saved locally.\nPull down to load 10 new users.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHintBar() {
    final remains = math.max(0, 6 - (_dragProgress * 6).round());

    return Positioned(
      top: 6,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EBF0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFD5FF19), Color(0xFF2ED85A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9BFF2D).withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: Color(0xFF13A93C),
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Learn your type',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222A35),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Give $remains more likes to unlock details',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF616A79),
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

  Widget _buildTopDots() {
    final topUserId = _users.isNotEmpty ? _users.first.userId : '';
    final topUser = _users.isEmpty ? null : _users.first;
    final topPhotos = topUser == null ? <String>[] : _userPhotos(topUser);
    final total = topPhotos.isEmpty ? 1 : topPhotos.length;
    final current = (_photoIndexByUserId[topUserId] ?? 0).clamp(0, total - 1);

    return Positioned(
      top: 76,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          total,
          (index) => Container(
            width: index == current ? 14 : 10,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index == current
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewindButton() {
    return Positioned(
      top: 84,
      right: 14,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: const Icon(Icons.rotate_left, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildOverlayBadge({required bool isLike}) {
    final colorA = isLike ? const Color(0xFFE0FF25) : const Color(0xFFFF44BE);
    final colorB = isLike ? const Color(0xFF33D86A) : const Color(0xFFFF1759);

    return Positioned(
      top: 116,
      left: isLike ? null : 188,
      right: isLike ? 188 : null,
      child: Transform.rotate(
        angle: isLike ? -0.36 : 0.36,
        child: Opacity(
          opacity: _dragProgress,
          child: Container(
            width: 116,
            height: 86,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(colors: [colorA, colorB]),
            ),
            child: Icon(
              isLike ? Icons.favorite : Icons.add,
              color: Colors.white,
              size: 58,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    final bottom = widget.isFromSearchPage ? 12.0 : 22.0;

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            onTap: _onRejectTap,
            icon: Icons.close,
            active: _isLeftDrag,
            gradient: const [Color(0xFFFF44BE), Color(0xFFFF1759)],
          ),
          const SizedBox(width: 34),
          _buildActionButton(
            onTap: _onLikeTap,
            icon: Icons.favorite,
            active: _isRightDrag,
            gradient: const [Color(0xFFE1FF29), Color(0xFF34D86B)],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required bool active,
    required List<Color> gradient,
  }) {
    return AnimatedScale(
      scale: active ? 1.12 : 1,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            gradient: active ? LinearGradient(colors: gradient) : null,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Icon(
            icon,
            color: active
                ? const Color(0xFFF1F2F6)
                : (icon == Icons.close
                      ? const Color(0xFFFF25AA)
                      : const Color(0xFF7DFF38)),
            size: 46,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfileModel user, {required bool isTopCard}) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(44)),
      child: Stack(
        children: [
          Positioned.fill(child: _buildCardImage(user)),
          if (isTopCard && _isLeftDrag)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.18 * _dragProgress),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.84),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FFE9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(0xFF0C8A56),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${user.nikeName} ${user.age ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0A84FF),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Distance ${user.distance?.round() ?? 0} km',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          final action = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserPage(userProfile: user),
                            ),
                          );
                          if (!mounted) {
                            return;
                          }
                          if (action == UserPageAction.dislike) {
                            await _onRejectTap();
                          } else if (action == UserPageAction.like) {
                            await _onLikeTap();
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.4),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
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

  Widget _buildCardImage(UserProfileModel user) {
    final assetPhotos = _userPhotos(user);
    if (assetPhotos.isNotEmpty) {
      final rawIndex = _photoIndexByUserId[user.userId] ?? 0;
      final index = rawIndex.clamp(0, assetPhotos.length - 1);
      return Image(
        image: AssetImage(assetPhotos[index]),
        fit: BoxFit.cover,
      );
    }
    final image = user.mediaUrls.isNotEmpty ? user.mediaUrls.first : '';

    if (image.startsWith('http')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageFallback(user),
      );
    }

    if (image.isNotEmpty) {
      return Image.file(
        File(image),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageFallback(user),
      );
    }

    return _buildImageFallback(user);
  }

  Widget _buildImageFallback(UserProfileModel user) {
    final letter = user.nikeName.isEmpty ? 'U' : user.nikeName.substring(0, 1);

    return Container(
      color: const Color(0xFF313647),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
