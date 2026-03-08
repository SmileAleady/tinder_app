import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/chat/chat_safety_ui.dart';
import 'package:tinder_app/widget/user_apply_page.dart';

enum UserPageAction { close, dislike, like }

class UserPage extends StatefulWidget {
  final UserProfileModel userProfile;
  const UserPage({super.key, required this.userProfile});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final PageController _pageController;
  int _currentImage = 0;

  List<String> get _photos => widget.userProfile.mediaUrls;

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

  void _close([UserPageAction action = UserPageAction.close]) {
    Navigator.of(context).pop(action);
  }

  Future<void> _openApply(int initialIndex) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserApplyPage(
          userProfile: widget.userProfile,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Future<void> _openReport() async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ReportFlowPage(peerName: widget.userProfile.nikeName),
      ),
    );
  }

  Future<void> _openBlockConfirm() async {
    await showBlockConfirmDialog(
      context,
      peerName: widget.userProfile.nikeName,
      onConfirmed: () async {
        if (!mounted) {
          return;
        }
        _close(UserPageAction.dislike);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFE9EAEC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(user)),
              SliverToBoxAdapter(child: _buildPhotoCarousel()),
              SliverToBoxAdapter(
                child: _card(
                  title: 'Looking For',
                  replyIndex: 0,
                  child: _titleLine(user.relationshipGoal?.title ?? 'Long-term'),
                ),
              ),
              SliverToBoxAdapter(
                child: _card(
                  title: 'About Me',
                  replyIndex: 1,
                  child: _titleLine(user.aboutMe),
                ),
              ),
              SliverToBoxAdapter(child: _buildKeyInfoCard(user)),
              SliverToBoxAdapter(child: _buildLifestyleCard(user)),
              SliverToBoxAdapter(child: _buildMoreInfoCard(user)),
              ..._buildPromptCards(user),
              if (user.favoriteSong != null)
                SliverToBoxAdapter(child: _buildSongCard(user.favoriteSong!)),
              SliverToBoxAdapter(
                child: _actionRow('Share ${user.nikeName} profile'),
              ),
              SliverToBoxAdapter(
                child: _actionRow(
                  'Block ${user.nikeName}',
                  onTap: () {
                    _openBlockConfirm();
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: _actionRow(
                  'Report ${user.nikeName}',
                  color: const Color(0xFFE8002A),
                  onTap: () {
                    _openReport();
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 124)),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserProfileModel user) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${user.nikeName}, ${user.age ?? 0}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202633),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _close(UserPageAction.close),
              borderRadius: BorderRadius.circular(18),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCarousel() {
    final photos = _photos;
    final total = photos.isEmpty ? 1 : photos.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFD9DADF),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 480,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: total,
                    onPageChanged: (value) {
                      setState(() {
                        _currentImage = value;
                      });
                    },
                    itemBuilder: (_, index) {
                      if (photos.isEmpty) {
                        return Container(color: const Color(0xFFBFC2CB));
                      }
                      final path = photos[index];
                      if (path.startsWith('assets/')) {
                        return Image(
                          image: AssetImage(path),
                          fit: BoxFit.cover,
                        );
                      }
                      if (path.startsWith('http')) {
                        return Image.network(path, fit: BoxFit.cover);
                      }
                      return Image.file(File(path), fit: BoxFit.cover);
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: List.generate(
                      total,
                      (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: i == _currentImage
                                ? Colors.white
                                : Colors.black.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInfoCard(UserProfileModel user) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Distance', '${user.distance?.round() ?? 0} km'),
      MapEntry('Height', _heightText(user.height)),
      MapEntry('City', user.city ?? '-'),
      MapEntry('Gender', _join(user.gender?.map((e) => e.name).toList())),
      MapEntry(
        'Orientation',
        _join(user.sexualOrientation?.map((e) => e.name).toList()),
      ),
      MapEntry('Language', _join(user.languages.map((e) => e.name).toList())),
    ];

    return _card(
      title: 'Key Info',
      replyIndex: 2,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _infoRow(rows[i].key, rows[i].value, divider: i != rows.length - 1),
        ],
      ),
    );
  }

  Widget _buildLifestyleCard(UserProfileModel user) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Pet Preference', user.lifestyle.petPreference),
      MapEntry('Drinking', user.lifestyle.drinking),
      MapEntry('Smoking', user.lifestyle.smoking),
      MapEntry('Fitness', user.lifestyle.fitness),
    ];

    return _card(
      title: 'Lifestyle',
      replyIndex: 4,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _infoRow(rows[i].key, rows[i].value, divider: i != rows.length - 1),
        ],
      ),
    );
  }

  Widget _buildMoreInfoCard(UserProfileModel user) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Zodiac', user.moreInfo.zodiac ?? '-'),
      MapEntry('Education', user.moreInfo.education ?? '-'),
      MapEntry('Family Plan', user.moreInfo.familyPlan ?? '-'),
      MapEntry('Communication Style', user.moreInfo.communicationStyle ?? '-'),
      MapEntry('Love Language', user.moreInfo.loveLanguage ?? '-'),
    ];

    return _card(
      title: 'More About Me',
      replyIndex: 5,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _infoRow(rows[i].key, rows[i].value, divider: i != rows.length - 1),
        ],
      ),
    );
  }

  List<Widget> _buildPromptCards(UserProfileModel user) {
    if (user.prompts.isEmpty) {
      return const [];
    }

    return user.prompts
        .where((e) => (e.content ?? '').trim().isNotEmpty)
        .map(
          (prompt) => SliverToBoxAdapter(
            child: _card(
              title: prompt.title,
              replyIndex: 3,
              child: _titleLine(prompt.content ?? '-'),
            ),
          ),
        )
        .toList();
  }

  Widget _buildSongCard(MusicModel song) {
    return _card(
      title: 'Top Song',
      replyIndex: 7,
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFC8CBD3),
              image: song.coverImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(song.coverImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF212733),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF535B69),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionRow(
    String text, {
    Color color = const Color(0xFF202633),
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required Widget child,
    int? replyIndex,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5F6877),
            ),
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: replyIndex == null
                  ? null
                  : () => _openApply(replyIndex),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCAD0DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              icon: const Icon(Icons.send, size: 16, color: Color(0xFF1D9BC6)),
              label: const Text(
                'Reply',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF2A3242),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool divider = true}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF535B69),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF222834),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (divider) const Divider(height: 24, color: Color(0xFFD3D7DE)),
      ],
    );
  }

  Widget _titleLine(String text) {
    return Text(
      text.trim().isEmpty ? '-' : text,
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFF202633),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      top: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _fab(
            icon: Icons.close,
            color: const Color(0xFFFF1A8F),
            onTap: () => _close(UserPageAction.dislike),
          ),
          const SizedBox(width: 14),
          // _fab(
          //   icon: Icons.star,
          //   color: const Color(0xFF00A9FF),
          //   onTap: () => _close(UserPageAction.close),
          //   small: true,
          // ),
          const SizedBox(width: 14),
          _fab(
            icon: Icons.favorite,
            color: const Color(0xFF6BDB2D),
            onTap: () => _close(UserPageAction.like),
          ),
        ],
      ),
    );
  }

  Widget _fab({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool small = false,
  }) {
    final size = small ? 76.0 : 92.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF3F4F6),
          border: Border.all(color: const Color(0xFFD6DAE1)),
        ),
        child: Icon(icon, size: small ? 40 : 46, color: color),
      ),
    );
  }

  String _heightText(UserHeightModel? model) {
    if (model == null) {
      return '-';
    }
    if (model.unit == HeightUnit.cm && model.cm != null) {
      return '${model.cm!.round()} cm';
    }
    if (model.feet != null && model.inch != null) {
      return '${model.feet} ft ${model.inch} in';
    }
    return '-';
  }

  String _join(List<String>? list) {
    if (list == null || list.isEmpty) {
      return '-';
    }
    return list.where((e) => e.trim().isNotEmpty).join('，');
  }
}
