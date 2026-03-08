import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/widget/user_pay_page.dart';

class UserApplyPage extends StatefulWidget {
  final UserProfileModel userProfile;
  final int initialIndex;

  const UserApplyPage({
    super.key,
    required this.userProfile,
    this.initialIndex = 0,
  });

  @override
  State<UserApplyPage> createState() => _UserApplyPageState();
}

class _UserApplyPageState extends State<UserApplyPage> {
  late final PageController _cardController;
  late final PageController _photoController;
  late final TextEditingController _textController;

  int _currentCard = 0;
  int _currentPhoto = 0;

  List<String> get _photos => widget.userProfile.mediaUrls;

  @override
  void initState() {
    super.initState();
    final clampedIndex = widget.initialIndex.clamp(0, 7);
    _currentCard = clampedIndex;
    _cardController = PageController(
      initialPage: clampedIndex,
      viewportFraction: 0.9,
    );
    _photoController = PageController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _photoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toPayPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserPayPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001530),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: const Icon(Icons.close, size: 34, color: Color(0xFF8FA1BB)),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF001130),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.send, color: Color(0xFF15A8FF), size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Boost match success up to 5x',
                    style: TextStyle(
                      color: Color(0xFF0A72CA),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                'Send a first impression, win attention early, and improve your match chance.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(
              height: 600,
              child: PageView.builder(
                controller: _cardController,
                onPageChanged: (value) {
                  setState(() {
                    _currentCard = value;
                  });
                },
                itemCount: 8,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildApplyCard(index),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                height: 84,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF8290A6)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(fontSize: 17),
                        decoration: const InputDecoration(
                          hintText: 'Write a message',
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF616B7C),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _toPayPage,
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF6A7586),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1795FF), width: 2),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _buildApplyCardContent(index)),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6E6E6E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${index + 1}/8',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyCardContent(int index) {
    final user = widget.userProfile;
    switch (index) {
      case 0:
        return _buildPhotoCard();
      case 1:
        return _quoteCard('About Me', user.aboutMe);
      case 2:
        return _infoBlock('Key Info', [
          MapEntry('Distance', '${user.distance?.round() ?? 0} km'),
          MapEntry('Gender', _join(user.gender?.map((e) => e.name).toList())),
        ]);
      case 3:
        final firstPrompt = user.prompts.isEmpty ? null : user.prompts.first;
        return _quoteCard(firstPrompt?.title ?? 'Prompt', firstPrompt?.content ?? '-');
      case 4:
        return _infoBlock('Lifestyle', [
          MapEntry('Smoking', user.lifestyle.smoking),
          MapEntry('Drinking', user.lifestyle.drinking),
          MapEntry('Pet Preference', user.lifestyle.petPreference),
        ]);
      case 5:
        return _infoBlock('More About Me', [
          MapEntry('Love Language', user.moreInfo.loveLanguage ?? '-'),
          MapEntry('Communication Style', user.moreInfo.communicationStyle ?? '-'),
          MapEntry('Zodiac', user.moreInfo.zodiac ?? '-'),
        ]);
      case 6:
        return _interestsCard(user);
      case 7:
      default:
        final lastPrompt = user.prompts.length > 1 ? user.prompts[1] : null;
        return _quoteCard(lastPrompt?.title ?? 'More Topics', lastPrompt?.content ?? 'Tell me more about your recent life.');
    }
  }

  Widget _buildPhotoCard() {
    final total = _photos.isEmpty ? 1 : _photos.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: PageView.builder(
        controller: _photoController,
        itemCount: total,
        onPageChanged: (value) {
          setState(() {
            _currentPhoto = value;
          });
        },
        itemBuilder: (_, idx) {
          if (_photos.isEmpty) {
            return Container(color: const Color(0xFFC5C8D0));
          }
          final path = _photos[idx];
          if (path.startsWith('assets/')) {
            return Image(image: AssetImage(path), fit: BoxFit.cover);
          }
          if (path.startsWith('http')) {
            return Image.network(path, fit: BoxFit.cover);
          }
          return Image.file(File(path), fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _quoteCard(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '❝  $title',
          style: const TextStyle(fontSize: 17, color: Color(0xFF67707E), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: const TextStyle(fontSize: 17, color: Color(0xFF252C38), height: 1.35, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _infoBlock(String title, List<MapEntry<String, String>> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📁  $title',
          style: const TextStyle(fontSize: 17, color: Color(0xFF67707E), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < rows.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rows[i].key,
                style: const TextStyle(fontSize: 17, color: Color(0xFF4B5463), fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                rows[i].value,
                style: const TextStyle(fontSize: 17, color: Color(0xFF252C38), fontWeight: FontWeight.w600),
              ),
              if (i != rows.length - 1)
                const Divider(height: 24, color: Color(0xFFD0D4DC)),
            ],
          ),
      ],
    );
  }

  Widget _interestsCard(UserProfileModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '♣  Interests',
          style: TextStyle(fontSize: 17, color: Color(0xFF67707E), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.interests
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E5EA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF2A313D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String _join(List<String>? list) {
    if (list == null || list.isEmpty) {
      return '-';
    }
    return list.join('，');
  }
}
