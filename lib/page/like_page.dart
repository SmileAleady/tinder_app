import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/upgrade/upgrade_page.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  static const List<String> _likeTags = [
    'All',
    'Nearby',
    "There is a profile",
    'Photo verified',
    'Travel',
    'Movie',
    'Music',
  ];

  int _tabIndex = 0;
  String _selectedLikeTag = _likeTags.first;
  bool _loading = true;
  List<UserProfileModel> _likedUsers = <UserProfileModel>[];
  _LikeFilterConfig _filter = _LikeFilterConfig.initial();

  @override
  void initState() {
    super.initState();
    _loadLikedUsers();
  }

  Future<void> _loadLikedUsers() async {
    setState(() {
      _loading = true;
    });
    final users = await OptionDataManager.getUserlike();
    if (!mounted) {
      return;
    }
    setState(() {
      _likedUsers = users;
      _loading = false;
    });
  }

  Future<void> _showFilterSheet() async {
    final interestPool = <String>{
      '旅行',
      '电影',
      '音乐',
      ..._likedUsers.expand((u) => u.interests.map((e) => e.name)),
    }.toList();

    final result = await showModalBottomSheet<_LikeFilterConfig>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LikeFilterSheet(initial: _filter, allInterests: interestPool);
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _filter = result;
    });
  }

  bool _containsKeyword(String value, List<String> keywords) {
    final lower = value.toLowerCase();
    return keywords.any((k) => lower.contains(k.toLowerCase()));
  }

  bool _isVerified(UserProfileModel user) {
    final hasVisibleGender = (user.gender ?? <GenderModel>[]).any(
      (item) => item.isVisible,
    );
    final hasVisibleOrientation =
        (user.sexualOrientation ?? <SexualOrientationModel>[]).any(
          (item) => item.isVisible,
        );
    return hasVisibleGender || hasVisibleOrientation;
  }

  bool _matchTag(UserProfileModel user) {
    switch (_selectedLikeTag) {
      case 'All':
        return true;
      case 'Nearby':
        return (user.distance ?? 999) <= 10;
      case 'There is a profile':
        return user.aboutMe.trim().isNotEmpty;
      case 'Photo verified':
        return _isVerified(user);
      case 'Travel':
        return user.interests.any(
          (i) => _containsKeyword(i.name, ['Travel', 'travel']),
        );
      case 'Movie':
        return user.interests.any(
          (i) => _containsKeyword(i.name, ['Movie', 'movie', 'film']),
        );
      case 'Music':
        return user.interests.any(
          (i) => _containsKeyword(i.name, ['Music', 'music']),
        );
      default:
        return true;
    }
  }

  bool _matchFilter(UserProfileModel user) {
    final age = user.age ?? 18;
    final distance = user.distance ?? 999;

    if (distance > _filter.maxDistanceKm) {
      return false;
    }
    if (age < _filter.minAge || age > _filter.maxAge) {
      return false;
    }
    if (user.mediaUrls.length < _filter.minPhotos) {
      return false;
    }
    if (_filter.onlyVerified && !_isVerified(user)) {
      return false;
    }
    if (_filter.onlyHasProfile && user.aboutMe.trim().isEmpty) {
      return false;
    }
    if (_filter.interests.isNotEmpty) {
      final names = user.interests.map((e) => e.name).toList();
      final ok = _filter.interests.any(
        (selected) => names.any((item) => _containsKeyword(item, [selected])),
      );
      if (!ok) {
        return false;
      }
    }
    return true;
  }

  List<UserProfileModel> get _filteredLikeUsers {
    return _likedUsers.where((u) => _matchTag(u) && _matchFilter(u)).toList();
  }

  List<UserProfileModel> get _topPickUsers {
    final source = _likedUsers.where(_matchFilter).toList();
    source.sort((a, b) {
      final scoreA =
          (a.interests.length * 2) + (a.aboutMe.trim().isNotEmpty ? 2 : 0);
      final scoreB =
          (b.interests.length * 2) + (b.aboutMe.trim().isNotEmpty ? 2 : 0);
      return scoreB.compareTo(scoreA);
    });
    return source;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      'Like',
                      style: TextStyle(
                        color: Color(0xFF1E2432),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _buildTabs(),
                  Expanded(
                    child: _tabIndex == 0
                        ? _buildLikeTab(_filteredLikeUsers)
                        : _buildTopPickTab(_topPickUsers),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD5D8DF))),
      ),
      child: Row(
        children: [
          Expanded(child: _tabButton('${_likedUsers.length} likes', 0)),
          Container(width: 1, height: 36, color: const Color(0xFFD4D7DE)),
          Expanded(child: _tabButton('Best Selection', 1)),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final selected = _tabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _tabIndex = index;
        });
      },
      child: Column(
        children: [
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF1F2533)
                  : const Color(0xFF778192),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            height: 2,
            color: selected ? const Color(0xFFFF2D63) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildLikeTab(List<UserProfileModel> users) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadLikedUsers,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 104),
            children: [
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _likeTags.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: _showFilterSheet,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFC4C9D3),
                              width: 1.4,
                            ),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Color(0xFF7A8394),
                            size: 22,
                          ),
                        ),
                      );
                    }

                    final tag = _likeTags[index - 1];
                    final selected = _selectedLikeTag == tag;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLikeTag = tag;
                        });
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF8A93A3)
                                : const Color(0xFFC4C9D3),
                            width: 1.4,
                          ),
                          color: selected
                              ? const Color(0xFFEDEFF3)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF667184),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Upgrade to Gold to see who has liked you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2D3444),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'All likes',
                  style: TextStyle(
                    color: Color(0xFF1E2432),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildUserGrid(users, topPickMode: false),
            ],
          ),
        ),
        _bottomActionButton(
          title: 'View the people who have liked you',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const UpgradePage(type: UpgradeType.gold),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopPickTab(List<UserProfileModel> users) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadLikedUsers,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 104),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '升级至 Tinder Gold™ 以get more最佳精选!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2D3444),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildUserGrid(users, topPickMode: true),
            ],
          ),
        ),
        _bottomActionButton(
          title: '解锁所有最佳精选',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const UpgradePage(type: UpgradeType.gold),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserGrid(
    List<UserProfileModel> users, {
    required bool topPickMode,
  }) {
    if (users.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Text(
          'No user data available',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF7A8292), fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _LikeUserCard(user: user, topPickMode: topPickMode);
        },
      ),
    );
  }

  Widget _bottomActionButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFFFCE06D), Color(0xFFF3C629)],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF232B3A),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _LikeUserCard extends StatelessWidget {
  final UserProfileModel user;
  final bool topPickMode;

  const _LikeUserCard({required this.user, required this.topPickMode});

  Widget _buildImage() {
    if (user.mediaUrls.isNotEmpty) {
      final path = user.mediaUrls.first;
      if (path.startsWith('assets/')) {
        return Image(image: AssetImage(path), fit: BoxFit.cover);
      }
      if (path.startsWith('http')) {
        return Image.network(path, fit: BoxFit.cover);
      }
      return Image.file(File(path), fit: BoxFit.cover);
    }

    return Container(
      color: const Color(0xFFC5C9D3),
      alignment: Alignment.center,
      child: Text(
        user.nikeName.isNotEmpty ? user.nikeName[0] : 'U',
        style: const TextStyle(
          color: Color(0xFF4C5363),
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          Positioned.fill(child: _buildImage()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.nikeName.isEmpty ? 'User' : user.nikeName}, ${user.age ?? 20}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topPickMode
                            ? '剩余 5 小时'
                            : '距离 ${(user.distance ?? 0).round()} 公里',
                        style: TextStyle(
                          color: topPickMode
                              ? const Color(0xFFF3C62B)
                              : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (topPickMode)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F7FB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFF20C5F5),
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeFilterConfig {
  final double maxDistanceKm;
  final int minAge;
  final int maxAge;
  final int minPhotos;
  final Set<String> interests;
  final bool onlyVerified;
  final bool onlyHasProfile;

  const _LikeFilterConfig({
    required this.maxDistanceKm,
    required this.minAge,
    required this.maxAge,
    required this.minPhotos,
    required this.interests,
    required this.onlyVerified,
    required this.onlyHasProfile,
  });

  factory _LikeFilterConfig.initial() {
    return const _LikeFilterConfig(
      maxDistanceKm: 161,
      minAge: 18,
      maxAge: 100,
      minPhotos: 1,
      interests: <String>{},
      onlyVerified: false,
      onlyHasProfile: false,
    );
  }

  _LikeFilterConfig copyWith({
    double? maxDistanceKm,
    int? minAge,
    int? maxAge,
    int? minPhotos,
    Set<String>? interests,
    bool? onlyVerified,
    bool? onlyHasProfile,
  }) {
    return _LikeFilterConfig(
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minPhotos: minPhotos ?? this.minPhotos,
      interests: interests ?? this.interests,
      onlyVerified: onlyVerified ?? this.onlyVerified,
      onlyHasProfile: onlyHasProfile ?? this.onlyHasProfile,
    );
  }
}

class _LikeFilterSheet extends StatefulWidget {
  final _LikeFilterConfig initial;
  final List<String> allInterests;

  const _LikeFilterSheet({required this.initial, required this.allInterests});

  @override
  State<_LikeFilterSheet> createState() => _LikeFilterSheetState();
}

class _LikeFilterSheetState extends State<_LikeFilterSheet> {
  late _LikeFilterConfig _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final sortedInterests = widget.allInterests.toSet().toList()..sort();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF7A8394),
                    size: 30,
                  ),
                ),
                const Expanded(
                  child: Text(
                    '点赞分组',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E2432),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD2D7E0)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                _sectionTitle('最大距离', '${_draft.maxDistanceKm.round()}+ 公里'),
                Slider(
                  value: _draft.maxDistanceKm,
                  min: 1,
                  max: 161,
                  activeColor: const Color(0xFFFF2D63),
                  onChanged: (value) {
                    setState(() {
                      _draft = _draft.copyWith(maxDistanceKm: value);
                    });
                  },
                ),
                const Divider(height: 1, color: Color(0xFFD2D7E0)),
                _sectionTitle('年龄范围', '${_draft.minAge}-${_draft.maxAge}+ 岁'),
                RangeSlider(
                  values: RangeValues(
                    _draft.minAge.toDouble(),
                    _draft.maxAge.toDouble(),
                  ),
                  min: 18,
                  max: 100,
                  activeColor: const Color(0xFFFF2D63),
                  onChanged: (value) {
                    setState(() {
                      _draft = _draft.copyWith(
                        minAge: value.start.round(),
                        maxAge: value.end.round(),
                      );
                    });
                  },
                ),
                const Divider(height: 1, color: Color(0xFFD2D7E0)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    '最少照片数',
                    style: TextStyle(
                      color: Color(0xFF2A3141),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(9, (idx) {
                      final value = idx + 1;
                      final selected = _draft.minPhotos == value;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _draft = _draft.copyWith(minPhotos: value);
                          });
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 46,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFFFF2D63)
                                  : const Color(0xFFC4C9D3),
                              width: 1.5,
                            ),
                            color: selected
                                ? const Color(0xFFFFE8EF)
                                : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$value',
                            style: const TextStyle(
                              color: Color(0xFF5D6676),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFD2D7E0)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    '兴趣',
                    style: TextStyle(
                      color: Color(0xFF2A3141),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sortedInterests.take(9).map((interest) {
                      final selected = _draft.interests.contains(interest);
                      return InkWell(
                        onTap: () {
                          final next = Set<String>.from(_draft.interests);
                          if (selected) {
                            next.remove(interest);
                          } else {
                            next.add(interest);
                          }
                          setState(() {
                            _draft = _draft.copyWith(interests: next);
                          });
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFFFF2D63)
                                  : const Color(0xFFC4C9D3),
                              width: 1.5,
                            ),
                            color: selected
                                ? const Color(0xFFFFE8EF)
                                : Colors.transparent,
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Color(0xFF657084),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    '查看所有兴趣',
                    style: TextStyle(
                      color: Color(0xFFFF2D63),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFD2D7E0)),
                _checkRow(
                  title: '照片已验证',
                  value: _draft.onlyVerified,
                  onChanged: (value) {
                    setState(() {
                      _draft = _draft.copyWith(onlyVerified: value);
                    });
                  },
                ),
                const Divider(height: 1, color: Color(0xFFD2D7E0)),
                _checkRow(
                  title: '有个人资料',
                  value: _draft.onlyHasProfile,
                  onChanged: (value) {
                    setState(() {
                      _draft = _draft.copyWith(onlyHasProfile: value);
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD2D7E0)),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _draft = _LikeFilterConfig.initial();
                    });
                  },
                  child: const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        '清空',
                        style: TextStyle(
                          color: Color(0xFF1E2432),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 60, color: const Color(0xFFD2D7E0)),
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(_draft),
                  child: const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        '应用',
                        style: TextStyle(
                          color: Color(0xFF929BAA),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _sectionTitle(String left, String right) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Text(
            left,
            style: const TextStyle(
              color: Color(0xFF2A3141),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            right,
            style: const TextStyle(
              color: Color(0xFF2A3141),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2A3141),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: Color(0xFF8993A4), width: 2),
              activeColor: const Color(0xFFFF2D63),
            ),
          ],
        ),
      ),
    );
  }
}
