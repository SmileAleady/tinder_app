import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/data/chat/chat_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/login/login_page.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_gender_selection_page.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_interest_sheet.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_language_sheet.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_relationship_goal_sheet.dart';
import 'package:tinder_app/page/profile_edit/widget/universal_option_sheet.dart';
import 'package:tinder_app/page/profile_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const Color _bg = Color(0xFFE7E8EC);
  static const Color _cardColor = Color(0xFFF4F5F7);
  static const Color _text = Color(0xFF1E2330);
  static const Color _sub = Color(0xFF6B7280);
  static const Color _pink = Color(0xFFFF2D68);

  UserProfileModel? _user;
  bool _loading = true;
  bool _processingAuthAction = false;

  bool _searchGlobal = false;
  bool _showOutDistance = true;
  bool _showOutAgeRange = true;
  bool _hasProfile = false;
  bool _discoveryEnabled = true;
  bool _verifiedOnlyChat = false;
  bool _useKm = true;

  double _maxDistance = 80;
  double _minPhotos = 1;
  RangeValues _ageRange = const RangeValues(18, 34);

  @override
  void initState() {
    super.initState();
    _loadActiveUser();
  }

  Future<void> _loadActiveUser() async {
    final active = await UserAuthLocalDb.instance.getActiveUser();
    if (!mounted) {
      return;
    }

    if (active != null) {
      _user = active;
      _maxDistance = (active.distance ?? 80).clamp(1, 160);
      final age = (active.age ?? 26).clamp(18, 60);
      _ageRange = RangeValues(
        (age - 8).clamp(18, 60).toDouble(),
        age.toDouble(),
      );
      _showOutDistance = !active.privacySettings.hideDistance;
      _showOutAgeRange = !active.privacySettings.hideAge;
      _hasProfile = active.aboutMe.trim().isNotEmpty;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateUser(void Function(UserProfileModel user) update) async {
    if (_user == null) {
      return;
    }
    update(_user!);
    await UserAuthLocalDb.instance.upsertUser(_user!, keepActive: true);
  }

  Future<void> _goToLoginPage() async {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _openLicensePage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LicenseListPage()));
  }

  Future<void> _openServiceTermsPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ServiceTermsPage()));
  }

  Future<void> _openCookiePolicyPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CookiePolicyPage()));
  }

  Future<void> _openPrivacyPolicyPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()));
  }

  Future<void> _openPrivacyPreferencePage() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PrivacyPreferencePage()),
    );
  }

  Future<void> _openMatchGroupPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MatchGroupInfoPage()));
  }

  Future<void> _handleLogout() async {
    if (_processingAuthAction) {
      return;
    }
    setState(() => _processingAuthAction = true);
    await UserAuthLocalDb.instance.logout();
    if (!mounted) {
      return;
    }
    await _goToLoginPage();
  }

  Future<void> _handleDeleteAccount() async {
    if (_processingAuthAction) {
      return;
    }

    final userId = _user?.userId;
    if (userId == null || userId.isEmpty) {
      await _handleLogout();
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('删除账户'),
          content: const Text('将删除本地账号信息和全部聊天记录，是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('确认删除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() => _processingAuthAction = true);
    await ChatLocalDb.instance.removeAllForUser(userId);
    await UserAuthLocalDb.instance.deleteUserById(userId);
    await UserAuthLocalDb.instance.logout();
    if (!mounted) {
      return;
    }
    await _goToLoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _pink, size: 28),
        ),
        title: const Text(
          'Setting',
          style: TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadActiveUser,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _membershipCard(
                    'PLATINUM',
                    const Color(0xFF171C24),
                    'You can use the pinned likes feature to see who has liked you, and enjoy more advanced functions at the same time',
                  ),
                  const SizedBox(height: 10),
                  _membershipCard(
                    'GOLD',
                    const Color(0xFFE4B025),
                    'View the people who have liked you and more information! ',
                  ),
                  const SizedBox(height: 10),
                  _membershipCard('PLUS', _pink, 'Unlimited likes and more!'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SuperLikePage(),
                              ),
                            );
                          },
                          child: _quickAction(
                            Icons.star,
                            const Color(0xFF20B7F2),
                            'Get Super Like',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: _showBoostSheet,
                          child: _quickAction(
                            Icons.bolt,
                            const Color(0xFFA03DFF),
                            'Gain Boost',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _quickAction(
                          Icons.visibility_off,
                          _text,
                          'Enable stealth mode',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _quickAction(
                          Icons.flight,
                          _pink,
                          'Location Roaming Mode',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Account Settings'),
                  _card(
                    child: Column(
                      children: [
                        _valueRow(
                          'Phone number',
                          _user?.phone.isNotEmpty == true
                              ? _user!.phone
                              : '86 198 8201 7769',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Verify your mobile phone number to help protect your account.',
                    style: TextStyle(color: _sub, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Discovery Settings'),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: _pink,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _user?.city?.isNotEmpty == true
                                  ? _user!.city!
                                  : '成都市, 中国',
                              style: const TextStyle(
                                color: _text,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add a new location',
                          style: TextStyle(
                            color: _pink,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Change location, pair up anywhere.',
                    style: TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Search globally',
                            style: TextStyle(color: _text, fontSize: 17),
                          ),
                        ),
                        _tinySwitch(
                          value: _searchGlobal,
                          onChanged: (v) => setState(() => _searchGlobal = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Activate the ‘Search Global’ mode, and you will see friends from nearby and all over the world.',
                    style: TextStyle(color: _sub, fontSize: 17, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Maximum distance',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_maxDistance.round()}${_useKm ? '公里' : '英里'}',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        Slider(
                          value: _maxDistance,
                          min: 1,
                          max: 160,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) async {
                            setState(() => _maxDistance = v);
                            await _updateUser((u) => u.distance = v);
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Show me users beyond the distance range after I have browsed through the viewable personal profiles',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _tinySwitch(
                              value: _showOutDistance,
                              activeColor: _pink,
                              onChanged: (v) async {
                                setState(() => _showOutDistance = v);
                                await _updateUser(
                                  (u) => u.privacySettings.hideDistance = !v,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        _entryRow(
                          'Interested',
                          trailing: _firstGender(),
                          onTap: _openGenderSelection,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Age range',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _ageRange,
                          min: 18,
                          max: 60,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) async {
                            setState(() => _ageRange = v);
                            await _updateUser((u) => u.age = v.end.round());
                          },
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'After I have browsed through the viewable profiles, show me users who are slightly outside my preference range.',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _tinySwitch(
                              value: _showOutAgeRange,
                              activeColor: _pink,
                              onChanged: (v) async {
                                setState(() => _showOutAgeRange = v);
                                await _updateUser(
                                  (u) => u.privacySettings.hideAge = !v,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F0DE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unlock more\nPreference settings',
                          style: TextStyle(
                            color: Color(0xFF8B6803),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Want more unique experiences? Set advanced preferences, view profiles tailored to your tastes, and still connect with other compatible individuals. ',
                          style: TextStyle(
                            color: _sub,
                            fontSize: 17,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 120,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: const Color(0xFFE8BD2C),
                            ),
                            child: const Center(
                              child: Text(
                                'Unlock',
                                style: TextStyle(
                                  color: _text,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Minimum number of photos',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _minPhotos.round().toString(),
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        Slider(
                          value: _minPhotos,
                          min: 1,
                          max: 6,
                          divisions: 5,
                          activeColor: _pink,
                          inactiveColor: const Color(0xFF7F8797),
                          onChanged: (v) => setState(() => _minPhotos = v),
                        ),
                        _entryRow(
                          'There is a personal profile',
                          trailingWidget: _tinySwitch(
                            value: _hasProfile,
                            onChanged: (v) => setState(() => _hasProfile = v),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _entryRow(
                          'Interest',
                          trailing: _interestSummary(),
                          topPadding: 12,
                          onTap: _openInterestSelection,
                        ),
                        _entryRow(
                          'I want',
                          trailing: _relationshipGoalSummary(),
                          topPadding: 12,
                          onTap: _openRelationshipGoalSelection,
                        ),
                        _entryRow(
                          'Add Language',
                          trailing: _languageSummary(),
                          topPadding: 12,
                          onTap: _openLanguageSelection,
                        ),
                        _entryRow(
                          'constellation',
                          trailing: _optionText(_user?.moreInfo.zodiac),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.constellation,
                          ),
                        ),
                        _entryRow(
                          'Education status',
                          trailing: _optionText(_user?.moreInfo.education),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.education,
                          ),
                        ),
                        _entryRow(
                          'Family Plan',
                          trailing: _optionText(_user?.moreInfo.familyPlan),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.wantChildren,
                          ),
                        ),
                        _entryRow(
                          'Communication style',
                          trailing: _optionText(
                            _user?.moreInfo.communicationStyle,
                          ),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.communicationStyle,
                          ),
                        ),
                        _entryRow(
                          'Way of love',
                          trailing: _optionText(_user?.moreInfo.loveLanguage),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.loveLanguage,
                          ),
                        ),
                        _entryRow(
                          'Pet preference',
                          trailing: _optionText(_user?.lifestyle.petPreference),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.petPreference,
                          ),
                        ),
                        _entryRow(
                          'drinking',
                          trailing: _optionText(_user?.lifestyle.drinking),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.drinking,
                          ),
                        ),
                        _entryRow(
                          'How often do you smoke?',
                          trailing: _optionText(_user?.lifestyle.smoking),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.smoking,
                          ),
                        ),
                        _entryRow(
                          'Fitness status',
                          trailing: _optionText(_user?.lifestyle.fitness),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.fitness,
                          ),
                        ),
                        _entryRow(
                          'Social media activity',
                          trailing: _optionText(
                            _user?.lifestyle.socialMediaActivity,
                          ),
                          topPadding: 12,
                          onTap: () => _openUniversalOptionSelection(
                            SheetOptionType.socialMediaActivity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _sectionTitle('Manage your visitors'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Tinder Plus™',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _card(
                    child: Column(
                      children: [
                        _choiceRow(
                          'Balanced recommendation',
                          'Check the people most relevant to you (default setting)',
                          selected: true,
                        ),
                        const SizedBox(height: 10),
                        _choiceRow(
                          'Recently Active',
                          'Let‘s first take a look at the recently active people',
                          selected: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Manage my visibility settings'),
                  _card(
                    child: Column(
                      children: [
                        _choiceRow(
                          'standard',
                          'You will be visible to other members in the card collection',
                          selected: true,
                        ),
                        const SizedBox(height: 10),
                        _choiceRow(
                          'Invisible   Tinder Plus™',
                          'It is only visible to members you have liked',
                          selected: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Enable Discovery'),
                  _card(
                    child: Row(
                      children: [
                        const Text(
                          'Enable discovery',
                          style: TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        _tinySwitch(
                          value: _discoveryEnabled,
                          activeColor: _pink,
                          onChanged: (v) =>
                              setState(() => _discoveryEnabled = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "If you turn off this feature, your profile will not be displayed in the card collection, and the discovery function will be disabled. Members you have liked may still be able to see you and match with you. ",
                    style: TextStyle(color: _sub, fontSize: 17, height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Managing Information Receipt'),
                  _card(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1485E2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Must pass verification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chatting is only allowed after photo verification',
                                    style: TextStyle(
                                      color: _text,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Members who have verified their identities through photos can enable this feature, which allows them to only receive messages from verified members. ',
                                    style: TextStyle(
                                      color: _sub,
                                      fontSize: 17,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            _tinySwitch(
                              value: _verifiedOnlyChat,
                              onChanged: (v) =>
                                  setState(() => _verifiedOnlyChat = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(child: _entryRow('Block contact')),
                  const SizedBox(height: 16),
                  _sectionTitle('Appearance'),
                  _card(child: _entryRow('Use System Settings')),
                  const SizedBox(height: 16),
                  _sectionTitle('Data Usage'),
                  _card(child: _entryRow('Auto-play video')),
                  const SizedBox(height: 10),
                  _card(
                    child: const Center(
                      child: Text(
                        'Apply for Tinder U',
                        style: TextStyle(
                          color: _pink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _sectionTitle('Web Profile'),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create a username. Share it. Users from all over the world will meet and match with you on Tinder.',
                          style: TextStyle(
                            color: _sub,
                            fontSize: 17,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _entryRow('User Name', trailing: 'Request User Name'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Q&A Activity'),
                  _card(
                    child: _entryRow(
                      'Manage Q&A Activities',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Matchmaker'),
                  _card(
                    child: _entryRow(
                      'Matchmaker Management',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Best Selection'),
                  _card(
                    child: _entryRow(
                      'Manage Best Selections',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Group Dating'),
                  _card(
                    child: _entryRow(
                      'Manage group dating function',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Zodiac Section'),
                  _card(
                    child: _entryRow(
                      'Manage constellation board',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Music'),
                  _card(
                    child: _entryRow('Manage music mode', trailing: 'Settings'),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Swipe Fever'),
                  _card(
                    child: _entryRow(
                      'Manage Slide Fever',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Active State'),
                  _card(
                    child: _entryRow(
                      'Manage Active Status',
                      trailing: 'Settings',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Mutual Friends'),
                  _card(child: _entryRow('mutual friend')),
                  const SizedBox(height: 8),
                  const Text(
                    "Check how many mutual friends you share with potential match partners.",
                    style: TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Application Settings'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('Notice'),
                        const SizedBox(height: 10),
                        _entryRow('Email address'),
                        const SizedBox(height: 10),
                        _entryRow('Push notification'),
                        const SizedBox(height: 10),
                        _entryRow('SMS'),
                        const SizedBox(height: 10),
                        _entryRow('Tinder Team'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'The display distance range is',
                              style: TextStyle(
                                color: _text,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _useKm ? 'km' : 'mi',
                              style: const TextStyle(color: _sub, fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE1E4EA)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _useKm = true),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _useKm
                                          ? _pink
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'km',
                                        style: TextStyle(
                                          color: _useKm ? Colors.white : _text,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _useKm = false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: !_useKm
                                          ? _pink
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'mi',
                                        style: TextStyle(
                                          color: !_useKm ? Colors.white : _text,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Payment Account'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('Manage Payment Accounts'),
                        const Divider(height: 20),
                        _entryRow('Manage Google Play Account'),
                        const Divider(height: 20),
                        _entryRow('Restore Purchase'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Contact Us'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('Help and Support'),
                        const SizedBox(height: 10),
                        _entryRow('Report'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Community'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('Community Rules'),
                        _entryRow('Safety Tips'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(child: _entryRow('Share Tinder')),
                  const SizedBox(height: 16),
                  _sectionTitle('Privacy'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow(
                          'Cookie Policy',
                          onTap: _openCookiePolicyPage,
                        ),
                        const SizedBox(height: 10),
                        _entryRow(
                          'Privacy Policy',
                          onTap: _openPrivacyPolicyPage,
                        ),
                        const SizedBox(height: 10),
                        _entryRow(
                          'Privacy Preferences',
                          onTap: _openPrivacyPreferencePage,
                        ),
                        const SizedBox(height: 10),
                        _entryRow(
                          'From Match Group',
                          onTap: _openMatchGroupPage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Legality'),
                  _card(
                    child: Column(
                      children: [
                        _entryRow('License', onTap: _openLicensePage),
                        _entryRow(
                          'Service Terms',
                          onTap: _openServiceTermsPage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _processingAuthAction ? null : _handleLogout,
                    borderRadius: BorderRadius.circular(16),
                    child: _card(
                      child: Center(
                        child: Text(
                          _processingAuthAction ? 'Processing...' : 'Logout',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: const [
                      Icon(Icons.local_fire_department, color: _pink, size: 64),
                      SizedBox(height: 8),
                      Text(
                        '版本 17.6.1(17060187)',
                        style: TextStyle(color: _sub, fontSize: 17),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _processingAuthAction ? null : _handleDeleteAccount,
                    borderRadius: BorderRadius.circular(16),
                    child: _card(
                      child: Center(
                        child: Text(
                          _processingAuthAction
                              ? 'Processing...'
                              : 'Deleting account',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
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

  Widget _membershipCard(String name, Color logoColor, String subtitle) {
    return _card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department, color: logoColor, size: 38),
              const SizedBox(width: 6),
              const Text(
                'tinder',
                style: TextStyle(
                  color: _text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  color: logoColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _sub, fontSize: 17, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, Color color, String title) {
    return _card(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD5D9E0)),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _text,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _entryRow(
    String title, {
    String? trailing,
    Widget? trailingWidget,
    double topPadding = 0,
    VoidCallback? onTap,
  }) {
    final Widget rightContent =
        trailingWidget ??
        (trailing != null
            ? Row(
                children: [
                  Text(
                    trailing,
                    style: const TextStyle(color: _sub, fontSize: 17),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF8D95A4),
                    size: 22,
                  ),
                ],
              )
            : const Icon(
                Icons.chevron_right,
                color: Color(0xFF8D95A4),
                size: 22,
              ));

    final row = Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: _text, fontSize: 17),
            ),
          ),
          rightContent,
        ],
      ),
    );

    if (onTap == null) {
      return row;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: row,
      ),
    );
  }

  Widget _choiceRow(String title, String subtitle, {required bool selected}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _sub,
                    fontSize: 17,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check : Icons.circle_outlined,
            color: selected ? _pink : const Color(0xFFB7BFCC),
            size: 34,
          ),
        ],
      ),
    );
  }

  Widget _valueRow(String left, String right) {
    return Row(
      children: [
        Text(left, style: const TextStyle(color: _text, fontSize: 17)),
        const Spacer(),
        Text(right, style: const TextStyle(color: _sub, fontSize: 17)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: Color(0xFF8D95A4), size: 22),
      ],
    );
  }

  Widget _tinySwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = const Color(0xFF858E9E),
  }) {
    final bg = value ? activeColor : const Color(0xFFDCE1EA);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF9DA6B6)),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              value ? Icons.check : Icons.close,
              color: value ? _pink : const Color(0xFF7E8798),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openGenderSelection() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileGenderSelectionPage(
          initialSelectedGenders: _user?.gender ?? <GenderModel>[],
          onConfirm: (selectedGenders) {
            setState(() {
              _user?.gender = selectedGenders;
            });
            _updateUser((u) => u.gender = selectedGenders);
          },
        ),
      ),
    );
  }

  Future<void> _openInterestSelection() async {
    await ProfileInterestSheet.show<void>(
      context,
      selectedInterest: _user?.interests ?? <UserInterest>[],
      onCompleted: (selectedInterests) {
        setState(() {
          _user?.interests = selectedInterests;
        });
        _updateUser((u) => u.interests = selectedInterests);
      },
    );
  }

  Future<void> _openRelationshipGoalSelection() async {
    await ProfileRelationshipGoalSheet.show<void>(
      context,
      selectedItem: _user?.relationshipGoal,
      onItemSelected: (item) {
        setState(() {
          _user?.relationshipGoal = item;
        });
        _updateUser((u) => u.relationshipGoal = item);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _openLanguageSelection() async {
    await ProfileLanguageSheet.show<void>(
      context,
      selectedLanguage: _user?.languages ?? <UserLanguage>[],
      onCompleted: (selectedLanguages) {
        setState(() {
          _user?.languages = selectedLanguages;
        });
        _updateUser((u) => u.languages = selectedLanguages);
      },
    );
  }

  Future<void> _openUniversalOptionSelection(SheetOptionType type) async {
    await UniversalOptionSheet.show<void>(
      context,
      type: type,
      onCompleted: (selectedItem) {
        setState(() {
          _applyUniversalOption(type, selectedItem.title);
        });
        _updateUser((u) {
          switch (type) {
            case SheetOptionType.constellation:
              u.moreInfo = UserMoreInfo(
                zodiac: selectedItem.title,
                education: u.moreInfo.education,
                familyPlan: u.moreInfo.familyPlan,
                communicationStyle: u.moreInfo.communicationStyle,
                loveLanguage: u.moreInfo.loveLanguage,
              );
              break;
            case SheetOptionType.education:
              u.moreInfo = UserMoreInfo(
                zodiac: u.moreInfo.zodiac,
                education: selectedItem.title,
                familyPlan: u.moreInfo.familyPlan,
                communicationStyle: u.moreInfo.communicationStyle,
                loveLanguage: u.moreInfo.loveLanguage,
              );
              break;
            case SheetOptionType.wantChildren:
              u.moreInfo = UserMoreInfo(
                zodiac: u.moreInfo.zodiac,
                education: u.moreInfo.education,
                familyPlan: selectedItem.title,
                communicationStyle: u.moreInfo.communicationStyle,
                loveLanguage: u.moreInfo.loveLanguage,
              );
              break;
            case SheetOptionType.communicationStyle:
              u.moreInfo = UserMoreInfo(
                zodiac: u.moreInfo.zodiac,
                education: u.moreInfo.education,
                familyPlan: u.moreInfo.familyPlan,
                communicationStyle: selectedItem.title,
                loveLanguage: u.moreInfo.loveLanguage,
              );
              break;
            case SheetOptionType.loveLanguage:
              u.moreInfo = UserMoreInfo(
                zodiac: u.moreInfo.zodiac,
                education: u.moreInfo.education,
                familyPlan: u.moreInfo.familyPlan,
                communicationStyle: u.moreInfo.communicationStyle,
                loveLanguage: selectedItem.title,
              );
              break;
            case SheetOptionType.petPreference:
              u.lifestyle = UserLifestyle(
                petPreference: selectedItem.title,
                drinking: u.lifestyle.drinking,
                smoking: u.lifestyle.smoking,
                fitness: u.lifestyle.fitness,
                socialMediaActivity: u.lifestyle.socialMediaActivity,
              );
              break;
            case SheetOptionType.drinking:
              u.lifestyle = UserLifestyle(
                petPreference: u.lifestyle.petPreference,
                drinking: selectedItem.title,
                smoking: u.lifestyle.smoking,
                fitness: u.lifestyle.fitness,
                socialMediaActivity: u.lifestyle.socialMediaActivity,
              );
              break;
            case SheetOptionType.smoking:
              u.lifestyle = UserLifestyle(
                petPreference: u.lifestyle.petPreference,
                drinking: u.lifestyle.drinking,
                smoking: selectedItem.title,
                fitness: u.lifestyle.fitness,
                socialMediaActivity: u.lifestyle.socialMediaActivity,
              );
              break;
            case SheetOptionType.fitness:
              u.lifestyle = UserLifestyle(
                petPreference: u.lifestyle.petPreference,
                drinking: u.lifestyle.drinking,
                smoking: u.lifestyle.smoking,
                fitness: selectedItem.title,
                socialMediaActivity: u.lifestyle.socialMediaActivity,
              );
              break;
            case SheetOptionType.socialMediaActivity:
              u.lifestyle = UserLifestyle(
                petPreference: u.lifestyle.petPreference,
                drinking: u.lifestyle.drinking,
                smoking: u.lifestyle.smoking,
                fitness: u.lifestyle.fitness,
                socialMediaActivity: selectedItem.title,
              );
              break;
            default:
              break;
          }
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _applyUniversalOption(SheetOptionType type, String selectedTitle) {
    final user = _user;
    if (user == null) {
      return;
    }
    switch (type) {
      case SheetOptionType.constellation:
        user.moreInfo = UserMoreInfo(
          zodiac: selectedTitle,
          education: user.moreInfo.education,
          familyPlan: user.moreInfo.familyPlan,
          communicationStyle: user.moreInfo.communicationStyle,
          loveLanguage: user.moreInfo.loveLanguage,
        );
        break;
      case SheetOptionType.education:
        user.moreInfo = UserMoreInfo(
          zodiac: user.moreInfo.zodiac,
          education: selectedTitle,
          familyPlan: user.moreInfo.familyPlan,
          communicationStyle: user.moreInfo.communicationStyle,
          loveLanguage: user.moreInfo.loveLanguage,
        );
        break;
      case SheetOptionType.wantChildren:
        user.moreInfo = UserMoreInfo(
          zodiac: user.moreInfo.zodiac,
          education: user.moreInfo.education,
          familyPlan: selectedTitle,
          communicationStyle: user.moreInfo.communicationStyle,
          loveLanguage: user.moreInfo.loveLanguage,
        );
        break;
      case SheetOptionType.communicationStyle:
        user.moreInfo = UserMoreInfo(
          zodiac: user.moreInfo.zodiac,
          education: user.moreInfo.education,
          familyPlan: user.moreInfo.familyPlan,
          communicationStyle: selectedTitle,
          loveLanguage: user.moreInfo.loveLanguage,
        );
        break;
      case SheetOptionType.loveLanguage:
        user.moreInfo = UserMoreInfo(
          zodiac: user.moreInfo.zodiac,
          education: user.moreInfo.education,
          familyPlan: user.moreInfo.familyPlan,
          communicationStyle: user.moreInfo.communicationStyle,
          loveLanguage: selectedTitle,
        );
        break;
      case SheetOptionType.petPreference:
        user.lifestyle = UserLifestyle(
          petPreference: selectedTitle,
          drinking: user.lifestyle.drinking,
          smoking: user.lifestyle.smoking,
          fitness: user.lifestyle.fitness,
          socialMediaActivity: user.lifestyle.socialMediaActivity,
        );
        break;
      case SheetOptionType.drinking:
        user.lifestyle = UserLifestyle(
          petPreference: user.lifestyle.petPreference,
          drinking: selectedTitle,
          smoking: user.lifestyle.smoking,
          fitness: user.lifestyle.fitness,
          socialMediaActivity: user.lifestyle.socialMediaActivity,
        );
        break;
      case SheetOptionType.smoking:
        user.lifestyle = UserLifestyle(
          petPreference: user.lifestyle.petPreference,
          drinking: user.lifestyle.drinking,
          smoking: selectedTitle,
          fitness: user.lifestyle.fitness,
          socialMediaActivity: user.lifestyle.socialMediaActivity,
        );
        break;
      case SheetOptionType.fitness:
        user.lifestyle = UserLifestyle(
          petPreference: user.lifestyle.petPreference,
          drinking: user.lifestyle.drinking,
          smoking: user.lifestyle.smoking,
          fitness: selectedTitle,
          socialMediaActivity: user.lifestyle.socialMediaActivity,
        );
        break;
      case SheetOptionType.socialMediaActivity:
        user.lifestyle = UserLifestyle(
          petPreference: user.lifestyle.petPreference,
          drinking: user.lifestyle.drinking,
          smoking: user.lifestyle.smoking,
          fitness: user.lifestyle.fitness,
          socialMediaActivity: selectedTitle,
        );
        break;
      default:
        break;
    }
  }

  String _interestSummary() {
    final list = _user?.interests ?? <UserInterest>[];
    if (list.isEmpty) {
      return 'Choice';
    }
    return list.map((e) => e.name).join(', ');
  }

  String _relationshipGoalSummary() {
    final goal = _user?.relationshipGoal;
    if (goal == null) {
      return 'choose';
    }
    return '${goal.emoji} ${goal.title}';
  }

  String _languageSummary() {
    final list = _user?.languages ?? <UserLanguage>[];
    if (list.isEmpty) {
      return 'Select';
    }
    return list.map((e) => e.name).join(', ');
  }

  String _optionText(String? value, {String fallback = 'Select'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return fallback;
    }
    return text;
  }

  String _firstGender() {
    final list = _user?.gender;
    if (list == null || list.isEmpty) {
      return '女性';
    }
    return list.first.name;
  }

  Future<void> _showBoostSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F6F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF949CAB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF7A8090),
                    size: 52 / 1.7,
                  ),
                ),
              ),
              const Text(
                'My Boost',
                style: TextStyle(fontSize: 68 / 4, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                '在 30 分钟里成为你所在地区的热门会员，以达成更多配对!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF545B6D), fontSize: 45 / 4),
              ),
              const SizedBox(height: 18),
              _boostRow(icon: Icons.bolt, title: 'Boost', remain: '剩余 0 个'),
              const Divider(color: Color(0xFFD2D6DF), height: 24),
              _boostRow(
                icon: Icons.timer_outlined,
                title: '优时 Boost',
                remain: '剩余 0 个',
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E17FF), Color(0xFFC651FF)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'get more Boost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64 / 4,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _boostRow({
    required IconData icon,
    required String title,
    required String remain,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFA93AF5), size: 46),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1D2433),
                fontSize: 63 / 4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              remain,
              style: const TextStyle(
                color: Color(0xFF5E6576),
                fontSize: 53 / 4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LicenseListPage extends StatelessWidget {
  const LicenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <({String name, String version, String license})>[
      (name: 'Android SDK hCaptcha', version: '4.4.0', license: 'MIT License'),
      (
        name: 'AutoValue Annotations',
        version: '1.6.3',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.android.datatransport:transport-api',
        version: '3.1.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-common',
        version: '21.0.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-messaging',
        version: '21.0.0',
        license: 'Apache Version 2.0',
      ),
      (
        name: 'com.google.firebase:firebase-analytics',
        version: '18.2.0',
        license: 'Apache Version 2.0',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE7E8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF2D68),
        centerTitle: true,
        title: const Text(
          'License',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD3D8E1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF222938),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Text(
                      item.version,
                      style: const TextStyle(
                        color: Color(0xFF4E5668),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  item.license,
                  style: const TextStyle(
                    color: Color(0xFF556071),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ServiceTermsPage extends StatelessWidget {
  const ServiceTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TextDocPage(
      title: 'Terms of Service',
      sections: const [
        _DocSectionData(
          title: 'Welcome to Tinder Chat Service',
          body:
              'These Terms of Service apply to your use of the Tinder App, including the matching, chatting, reporting, and account management functions. By continuing to use the App, you agree to be bound by these Terms. ',
        ),
        _DocSectionData(
          title: 'Account and Security',
          body:
              'You need to provide authentic and complete information and keep your login credentials safe. You are responsible for all actions taken under your account. If you notice any abnormal login activity, please change your password immediately and contact us. ',
        ),
        _DocSectionData(
          title: 'Usage Guidelines',
          body:
              'You are prohibited from posting content that is illegal, harassing, discriminatory, hateful, fraudulent, or infringes on the rights of others. You are also prohibited from impersonating others, bypassing the platform’s security mechanisms, and batch crawling or abusing interfaces. ',
        ),
        _DocSectionData(
          title: 'Chat and Content',
          body:
              'You are responsible for the messages you send. We may review, restrict, or remove content based on risk control, reports, or legal requirements to ensure the safety of the platform and its users. ',
        ),
        _DocSectionData(
          title: 'Subscription and Virtual Rights',
          body:
              'The functions such as Boost, Super Like, and subscription packages are subject to the instructions on the purchase page. Except as otherwise provided by law, consumed benefits are generally non-refundable. ',
        ),
        _DocSectionData(
          title: 'Ban and Termination',
          body:
              'If you violate these terms, we may take actions such as warning, restricting, banning, deleting content, or terminating services based on the severity of the violation. You may stop using the service at any time and apply for deletion of your account.',
        ),
        _DocSectionData(
          title: 'Disclaimer',
          body:
              "We strive to ensure stable service, but we cannot guarantee continuous uninterrupted and absolutely error-free service. For issues caused by network, equipment, or third-party services, the platform bears limited liability within the scope permitted by law.",
        ),
        _DocSectionData(
          title: 'Terms Update',
          body:
              'We may update these terms. Major changes will be notified through in-app prompts or other means. Continued use after the update will be deemed as acceptance of the new terms.',
        ),
      ],
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TextDocPage(
      title: 'Privacy Policy',
      sections: const [
        _DocSectionData(
          title: 'The information we collect',
          body:
              'We will collect the account information (email, nickname, avatar, etc.), usage information (operation logs, device information), and chat-related metadata you provide, which will be used to provide and optimize services. ',
        ),
        _DocSectionData(
          title: 'Purpose of information usage',
          body:
              'We use information to complete account login, matching and recommendation, message delivery, anti-cheating risk control, problem investigation, and experience improvement. It may also be used to show you relevant function recommendations. ',
        ),
        _DocSectionData(
          title: 'Information Sharing',
          body:
              'Except as required by law or with your explicit authorization, we will not sell your personal information to unrelated third parties. When necessary, we will share the minimum necessary information with entrusted service providers. ',
        ),
        _DocSectionData(
          title: 'Storage and Security',
          body:
              'We take reasonable security measures to protect your data, including access control, encrypted transmission, and least privilege. You should also protect your account password and device security. ',
        ),
        _DocSectionData(
          title: 'Your rights',
          body:
              'You can access, modify, or delete your personal information, manage privacy preferences, log out of your account, and delete local data. You can also contact our support channels to exercise your legal rights. ',
        ),
        _DocSectionData(
          title: 'Protection of minors',
          body:
              'This service is only available to users who meet the local legal age requirements. If we discover any unauthorized use by minors, we will take measures such as restricting or deleting their accounts. ',
        ),
        _DocSectionData(
          title: 'Policy Updates and Contacts',
          body:
              'If there are any policy changes, we will update them within the app and indicate the effective date. If you have any privacy concerns, you can contact the platform through "Settings - Help and Support". ',
        ),
      ],
    );
  }
}

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cookie Policy',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 10),
          const _WebHeader(),
          const SizedBox(height: 16),
          const Text(
            'Session and persistent cookies',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cookies can also be divided into session cookies and persistent cookies. Session cookies expire after you close your browser, while persistent cookies can be retained for a period of time to remember preferences and enhance the experience.',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "The purposes of web beacons and SDKs",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Web beacons (pixel tags) and SDKs help us understand page visits, message delivery, and functional stability. They do not individually identify your true identity, but are used in conjunction with service performance analysis.",
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'What do we use cookies for? ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          _cookieTypeTable(),
          const SizedBox(height: 16),
          const Text(
            'How do you control cookies? ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You can manage your cookie preferences in the settings. Disabling certain types may affect your personalized experience, recommendation accuracy, or the availability of certain features.",
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Interest-based advertising tool',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "We may provide access to ad preference management through industry self-regulatory tools. You can choose to opt out of personalized ads, but it doesn't mean you won't see ads anymore.",
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Google Analytics',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We use Google Analytics to understand usage trends. You can limit related statistics through browser plugins or device settings. ',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How to contact us? ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2330),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'If you have any questions about the Cookie Policy, please submit a request in the “Help and Support” section of the app, and we will handle it as soon as possible',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF566072),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _cookieTypeTable() {
    Widget cell(String text, {bool strong = false}) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            height: 1.25,
            color: const Color(0xFF4F596A),
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: const Color(0xFFCAD1DC)),
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      children: [
        TableRow(
          children: [
            cell('Cookie Type', strong: true),
            cell('description', strong: true),
          ],
        ),
        TableRow(
          children: [
            cell('必要 cookie', strong: true),
            cell(
              'Used for login verification, session security, and basic function operation. ',
            ),
          ],
        ),
        TableRow(
          children: [
            cell('necessary cookies', strong: true),
            cell(
              'Used for statistical function usage, performance improvement, and stability enhancement. ',
            ),
          ],
        ),
        TableRow(
          children: [
            cell('advertising marketing cookie', strong: true),
            cell(
              'Used to measure the effectiveness of marketing activities and reduce duplicate impressions. ',
            ),
          ],
        ),
        TableRow(
          children: [
            cell('social network cookie', strong: true),
            cell(
              'Supports sharing content and integration with third-party social scenarios. ',
            ),
          ],
        ),
      ],
    );
  }
}

class PrivacyPreferencePage extends StatefulWidget {
  const PrivacyPreferencePage({super.key});

  @override
  State<PrivacyPreferencePage> createState() => _PrivacyPreferencePageState();
}

class _PrivacyPreferencePageState extends State<PrivacyPreferencePage> {
  bool requiredPermission = true;
  bool adPermission = true;
  bool marketingPermission = true;
  bool matchGroupPermission = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E8EC),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8292)),
        ),
        title: const Text(
          'Privacy Preference Center',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Complete',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Like other applications, if you use Tinder, our and our partners' trackers will store and retrieve information on your device. You can adjust your preferences here.",
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF5A6475),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Administrative Permissions',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
            ),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: 'Necessary Permissions',
            subtitle:
                'These are the basic permissions required to run the application and cannot be closed.',
            value: requiredPermission,
            enabled: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: 'Agree to Enable Advertising Permissions',
            subtitle:
                'Advertising permissions will be enabled by default, and you can go to‘ Personalized Customized Advertising Permissions’to view details. ',
            value: adPermission,
            onChanged: (v) => setState(() => adPermission = v),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: 'Agree to Enable Marketing Permissions',
            subtitle:
                'Used to monitor and enhance the effectiveness of marketing activities.',
            value: marketingPermission,
            onChanged: (v) => setState(() => marketingPermission = v),
          ),
          const SizedBox(height: 10),
          _PreferenceCard(
            title: 'Agree to Enable Match Group Data Sharing',
            subtitle:
                'Used for personalized experience and service optimization.',
            value: matchGroupPermission,
            onChanged: (v) => setState(() => matchGroupPermission = v),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                adPermission = true;
                marketingPermission = true;
                matchGroupPermission = true;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF2D68), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text(
              'All agree to enable',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              setState(() {
                adPermission = false;
                marketingPermission = false;
                matchGroupPermission = false;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF2D68), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text(
              'Reject all activation',
              style: TextStyle(
                color: Color(0xFFFF2D68),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class MatchGroupInfoPage extends StatefulWidget {
  const MatchGroupInfoPage({super.key});

  @override
  State<MatchGroupInfoPage> createState() => _MatchGroupInfoPageState();
}

class _MatchGroupInfoPageState extends State<MatchGroupInfoPage> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'From Match Group',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _WebHeader(),
          const SizedBox(height: 16),
          const Text(
            'Tinder>Security&Privacy>Privacy',
            style: TextStyle(fontSize: 17, color: Color(0xFF444C5A)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFCDD3DE)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFF8D95A4), size: 30),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(fontSize: 17, color: Color(0xFF8D95A4)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Why do we need to share information among companies in Match Group',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tinder is a product under Match Group. We may share necessary data within the group for service stability, account security, risk control, fraud prevention, and experience optimization.',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF4F596A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Protect your and others‘ safety',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2533),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We will share risk signals when necessary to identify fake accounts, junk content, fraudulent behavior, and serious violations. ',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF4F596A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '• Investigate and handle illegal and irregular behavior \ n • Improve anti harassment and anti fraud capabilities \ n • Cooperate with law enforcement agencies as required by law',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF1F2533),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFCBD2DD)),
          const SizedBox(height: 10),
          const Text(
            'How much has the information in this article helped you?  *',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF1F2533),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final active = index < _rating;
              return IconButton(
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  active ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFF4C72),
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          const Text(
            'Share your thoughts on this:',
            style: TextStyle(fontSize: 17, color: Color(0xFF1F2533)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLength: 500,
            maxLines: 4,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'Please enter feedback content',
              counterStyle: const TextStyle(
                fontSize: 17,
                color: Color(0xFF5B6476),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 140,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Submission successful')),
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Powered by Medallia',
              style: TextStyle(fontSize: 17, color: Color(0xFF5D6678)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextDocPage extends StatelessWidget {
  const _TextDocPage({required this.title, required this.sections});

  final String title;
  final List<_DocSectionData> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2533)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sections[i].title,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF1F2533),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sections[i].body,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF4F596A),
                height: 1.35,
              ),
            ),
          ],
        ),
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemCount: sections.length,
      ),
    );
  }
}

class _DocSectionData {
  const _DocSectionData({required this.title, required this.body});
  final String title;
  final String body;
}

class _WebHeader extends StatelessWidget {
  const _WebHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6DBE3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.local_fire_department, color: Color(0xFFFF5A6F), size: 40),
          SizedBox(width: 6),
          Text(
            'tinder',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202736),
            ),
          ),
          Spacer(),
          Icon(Icons.menu, color: Color(0xFF667084), size: 32),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF1F2533),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFF2D68),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: const Color(0xFFFF2D68).withValues(alpha: 0.4),
            activeThumbColor: const Color(0xFFFF2D68),
          ),
        ],
      ),
    );
  }
}
