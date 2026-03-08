import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/page/home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final List<_SearchSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = _buildSections();
  }

  List<_SearchSection> _buildSections() {
    return [
      _SearchSection(
        title: '',
        subtitle: '',
        items: [
          _item('Free Tonight', 511, const Color(0xFF5A27A6), 'assets/user/6.png'),
          _item('Make New Friends', 881, const Color(0xFFC99817), 'assets/user/11.png'),
          _item('Photo Verification', 1000, const Color(0xFFB9552B), 'assets/user/1.png', wide: true, cta: 'Try Now'),
        ],
      ),
      _SearchSection(
        title: 'Like-minded',
        subtitle: _subtitleFromModel('Nature Lovers'),
        items: [
          _item('No-kids Lifestyle', 52, const Color(0xFF25A981), 'assets/user/4.png', wide: true, cta: 'Try Now'),
        ],
      ),
      _SearchSection(
        title: 'Shared Interests',
        subtitle: _subtitleFromModel('Travel'),
        items: [
          _item('Travel', 614, const Color(0xFF8F2257), 'assets/user/8.png'),
          _item('Binge Watchers', 540, const Color(0xFF1F8B4C), 'assets/user/5.png'),
        ],
      ),
      _SearchSection(
        title: '',
        subtitle: '',
        items: [
          _item('Nature Lovers', 351, const Color(0xFF1B8E46), 'assets/user/2.png'),
          _item('Music Lovers', 380, const Color(0xFF55319A), 'assets/user/3.png'),
          _item('Self Care', 540, const Color(0xFF1F8B4C), 'assets/user/10.png'),
          _item('Gamers', 34, const Color(0xFF2F8D46), 'assets/user/9.png'),
          _item('Pet Lovers', 81, const Color(0xFFB5432A), 'assets/user/12.png', wide: true, cta: 'Try Now'),
        ],
      ),
      _SearchSection(
        title: '',
        subtitle: '',
        items: [
          _item('Sports', 452, const Color(0xFFB64933), 'assets/user/13.png'),
          _item('Coffee Dates', 135, const Color(0xFFC59818), 'assets/user/14.png'),
          _item('Night Dates', 196, const Color(0xFF89235F), 'assets/user/15.png'),
          _item('Adventure Seekers', 347, const Color(0xFFD6AA23), 'assets/user/16.png'),
          _item('Creative Minds', 539, const Color(0xFF126E8D), 'assets/user/17.png'),
          _item('Foodies', 274, const Color(0xFF92204D), 'assets/user/18.png'),
        ],
      ),
      _SearchSection(
        title: 'Intentional Dating',
        subtitle: _subtitleFromModel('Looking for a Long-term Partner'),
        items: [
          _item('Looking for a Long-term Partner', 934, const Color(0xFFB64933), 'assets/user/7.png'),
          _item('Serious Relationship', 650, const Color(0xFFC45D3D), 'assets/user/11.png'),
          _item('Enjoy Short-term Dating', 159, const Color(0xFF8F2257), 'assets/user/0.png', wide: true),
        ],
      ),
    ];
  }

  _SearchItem _item(
    String title,
    int count,
    Color tone,
    String image, {
    bool wide = false,
    String? cta,
  }) {
    return _SearchItem(
      title: title,
      count: count,
      tone: tone,
      image: image,
      wide: wide,
      cta: cta,
    );
  }

  String _subtitleFromModel(String type) {
    final sample = OptionDataManager.getUserListBySearchType(type, count: 1).first;
    final goal = sample.relationshipGoal?.title ?? '';
    if (goal.isNotEmpty) {
      return goal;
    }
    return sample.aboutMe;
  }

  Future<void> _onTapItem(_SearchItem item) async {
    final dialogContext = context;
    unawaited(
      showGeneralDialog<void>(
        context: dialogContext,
        barrierDismissible: false,
        barrierLabel: 'loading',
        transitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (_, __, ___) => _LoadingOverlay(item: item),
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    Navigator.of(dialogContext, rootNavigator: true).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomePage(
          isFromSearchPage: true,
          searchType: item.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 2, bottom: 10),
              child: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF212734),
                ),
              ),
            ),
            for (final section in _sections) ...[
              if (section.title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 2),
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF212734),
                    ),
                  ),
                ),
              if (section.subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 8),
                  child: Text(
                    section.subtitle,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF606B7A),
                    ),
                  ),
                ),
              _buildSectionGrid(section),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionGrid(_SearchSection section) {
    final rows = <Widget>[];
    var i = 0;
    while (i < section.items.length) {
      final current = section.items[i];
      if (current.wide) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SearchCard(
              item: current,
              onTap: () => _onTapItem(current),
            ),
          ),
        );
        i += 1;
        continue;
      }

      final rightAvailable =
          i + 1 < section.items.length && !section.items[i + 1].wide;
      final rightItem = rightAvailable ? section.items[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: _SearchCard(
                  item: current,
                  onTap: () => _onTapItem(current),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: rightItem == null
                    ? const SizedBox.shrink()
                    : _SearchCard(
                        item: rightItem,
                        onTap: () => _onTapItem(rightItem),
                      ),
              ),
            ],
          ),
        ),
      );
      i += rightAvailable ? 2 : 1;
    }
    return Column(children: rows);
  }
}

class _LoadingOverlay extends StatelessWidget {
  final _SearchItem item;
  const _LoadingOverlay({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F4F6),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.close, size: 34, color: Color(0xFF202734)),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF212734),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.flash_on, color: Color(0xFFBB46F2)),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_horiz, color: Color(0xFF586272)),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: 178,
              height: 178,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3D9DF), width: 5),
              ),
              child: ClipOval(
                child: Image(
                  image: AssetImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Finding people near you...',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF3D4653),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _SearchSection {
  final String title;
  final String subtitle;
  final List<_SearchItem> items;

  _SearchSection({
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

class _SearchItem {
  final String title;
  final int count;
  final Color tone;
  final String image;
  final bool wide;
  final String? cta;

  _SearchItem({
    required this.title,
    required this.count,
    required this.tone,
    required this.image,
    required this.wide,
    this.cta,
  });
}

class _SearchCard extends StatelessWidget {
  final _SearchItem item;
  final VoidCallback onTap;

  const _SearchCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = item.wide ? 230.0 : 300.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: AssetImage(item.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              item.tone.withValues(alpha: 0.55),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.36),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white),
                    color: Colors.black.withValues(alpha: 0.16),
                  ),
                  child: Text(
                    '👥 ${item.count >= 1000 ? '1K' : item.count}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (item.cta != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        item.cta!,
                        style: const TextStyle(
                          color: Color(0xFF2B3240),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
