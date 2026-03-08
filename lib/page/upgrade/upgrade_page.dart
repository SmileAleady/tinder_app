import 'package:flutter/material.dart';

enum UpgradeType { gold, platinum, plus }

class UpgradePage extends StatefulWidget {
  final UpgradeType type;

  const UpgradePage({super.key, required this.type});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  int _selectedPlan = 0;

  @override
  Widget build(BuildContext context) {
    final config = _configFor(widget.type);
    final selected = config.plans[_selectedPlan];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 152),
              children: [
                _UpgradeTopBar(config: config),
                const SizedBox(height: 16),
                Text(
                  config.headline,
                  style: const TextStyle(
                    color: Color(0xFF1E2432),
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose a package',
                  style: TextStyle(
                    color: Color(0xFF1E2432),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 176,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: config.plans.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final plan = config.plans[i];
                      final selectedPlan = i == _selectedPlan;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPlan = i),
                        child: Container(
                          width: 196,
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selectedPlan
                                  ? config.primary
                                  : const Color(0xFFD1D5DF),
                              width: selectedPlan ? 2.3 : 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    plan.tag,
                                    style: TextStyle(
                                      color: config.primary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (selectedPlan)
                                    Icon(
                                      Icons.check,
                                      size: 27,
                                      color: config.primary,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                plan.title,
                                style: const TextStyle(
                                  color: Color(0xFF1E2432),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                plan.price,
                                style: const TextStyle(
                                  color: Color(0xFF1E2432),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(config.plans.length, (i) {
                    final active = i == _selectedPlan;
                    return Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF202633)
                            : const Color(0xFF9DA4B2),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                _FeaturePanel(config: config),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomCta(
                colorStart: config.buttonStart,
                colorEnd: config.buttonEnd,
                total: selected.total,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradeTopBar extends StatelessWidget {
  const _UpgradeTopBar({required this.config});

  final _UpgradeConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [config.topTint, const Color(0xFFF3F4F6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              size: 17 * 2,
              color: Color(0xFF1D2331),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.local_fire_department,
            color: config.primary,
            size: 17 * 1.6,
          ),
          const SizedBox(width: 4),
          const Text(
            'tinder',
            style: TextStyle(
              color: Color(0xFF1E2432),
              fontSize: 17 * 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: config.badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              config.badge,
              style: TextStyle(
                color: config.badgeText,
                fontSize: 17 * 0.75,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _FeaturePanel extends StatelessWidget {
  const _FeaturePanel({required this.config});

  final _UpgradeConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1D5DF), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFD1D5DF), width: 1.2),
              ),
              child: Text(
                config.featureTitle,
                style: const TextStyle(
                  color: Color(0xFF596071),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...config.features.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check,
                    color: Color(0xFF1E2432),
                    size: 17 * 1.6,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Color(0xFF1E2432),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (item.desc != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.desc!,
                            style: const TextStyle(
                              color: Color(0xFF5E6576),
                              fontSize: 17,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.colorStart,
    required this.colorEnd,
    required this.total,
  });

  final Color colorStart;
  final Color colorEnd;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F4F6),
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'When you click Continue, we will charge you and your subscription will be automatically renewed. By clicking, you agree to our terms.',
            style: TextStyle(
              color: Color(0xFF2F3646),
              fontSize: 17,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(colors: [colorStart, colorEnd]),
            ),
            child: Center(
              child: Text(
                'Continue with the operation at a total price of $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeConfig {
  final String badge;
  final Color topTint;
  final Color primary;
  final Color badgeBg;
  final Color badgeText;
  final String headline;
  final String featureTitle;
  final List<_UpgradeFeature> features;
  final List<_UpgradePlan> plans;
  final Color buttonStart;
  final Color buttonEnd;

  const _UpgradeConfig({
    required this.badge,
    required this.topTint,
    required this.primary,
    required this.badgeBg,
    required this.badgeText,
    required this.headline,
    required this.featureTitle,
    required this.features,
    required this.plans,
    required this.buttonStart,
    required this.buttonEnd,
  });
}

class _UpgradeFeature {
  final String title;
  final String? desc;

  const _UpgradeFeature(this.title, [this.desc]);
}

class _UpgradePlan {
  final String tag;
  final String title;
  final String price;
  final String total;

  const _UpgradePlan({
    required this.tag,
    required this.title,
    required this.price,
    required this.total,
  });
}

_UpgradeConfig _configFor(UpgradeType type) {
  switch (type) {
    case UpgradeType.gold:
      return const _UpgradeConfig(
        badge: 'GOLD',
        topTint: Color(0xFFF8EDC4),
        primary: Color(0xFFC39A17),
        badgeBg: Color(0xFFE8C048),
        badgeText: Color(0xFF1E2432),
        headline:
            'By activating Tinder Gold™  you can view who has liked you and quickly match with them. ',
        featureTitle: 'Tinder Gold® Exclusive Perks',
        features: [
          _UpgradeFeature('Unlimited Likes'),
          _UpgradeFeature('View who has liked you'),
          _UpgradeFeature('Unlimited Replay'),
          _UpgradeFeature(
            '1 free Boost per month',
            'Enjoyable when purchasing a one-month or longer subscription.',
          ),
        ],
        plans: [
          _UpgradePlan(
            tag: 'popular',
            title: '1week',
            price: 'HK\$148.00/week',
            total: 'HK\$148.00',
          ),
          _UpgradePlan(
            tag: '',
            title: '1 month',
            price: 'HK\$77.50/week',
            total: 'HK\$310.00',
          ),
          _UpgradePlan(
            tag: '',
            title: '6 month',
            price: 'HK\$47.30/week',
            total: 'HK\$1,135.20',
          ),
        ],
        buttonStart: Color(0xFFD7A824),
        buttonEnd: Color(0xFFE8C94B),
      );
    case UpgradeType.platinum:
      return const _UpgradeConfig(
        badge: 'PLATINUM',
        topTint: Color(0xFFDDE1E8),
        primary: Color(0xFF1E2432),
        badgeBg: Color(0xFF3B4352),
        badgeText: Color(0xFFFFFFFF),
        headline: 'Activate Platinum to upgrade your likes and Super Likes.',
        featureTitle: 'Tinder Platinum Premium Features',
        features: [
          _UpgradeFeature('Unlimited Likes'),
          _UpgradeFeature('View who has liked you'),
          _UpgradeFeature(
            'Top Praise',
            'Top Praise allows the people you praise to see you faster.',
          ),
          _UpgradeFeature('Unlimited Replay'),
        ],
        plans: [
          _UpgradePlan(
            tag: 'Hot',
            title: '1week',
            price: 'HK\$233.00/week',
            total: 'HK\$233.00',
          ),
          _UpgradePlan(
            tag: '',
            title: '1 month',
            price: 'HK\$117.00/week',
            total: 'HK\$468.00',
          ),
          _UpgradePlan(
            tag: '',
            title: '6 month',
            price: 'HK\$74.80/week',
            total: 'HK\$1,795.20',
          ),
        ],
        buttonStart: Color(0xFF2A3140),
        buttonEnd: Color(0xFF555F72),
      );
    case UpgradeType.plus:
      return const _UpgradeConfig(
        badge: 'PLUS',
        topTint: Color(0xFFF7D3DB),
        primary: Color(0xFFFF2B66),
        badgeBg: Color(0xFFFF4C6E),
        badgeText: Color(0xFFFFFFFF),
        headline:
            'Unlimited likes. Unlimited replays. Unlimited location roaming. No ads.',
        featureTitle: 'Tinder Plus™  Premium Features',
        features: [
          _UpgradeFeature('Unlimited Likes'),
          _UpgradeFeature('Unlimited Replay'),
          _UpgradeFeature(
            'Unlimited Location Roaming Mode*',
            'You can pair and chat with users from all over the world. *Restrictions apply.',
          ),
          _UpgradeFeature('Manage your personal profile'),
        ],
        plans: [
          _UpgradePlan(
            tag: 'Hot',
            title: '1 week',
            price: 'HK\$100.00/week',
            total: 'HK\$100.00',
          ),
          _UpgradePlan(
            tag: '',
            title: '1 month',
            price: 'HK\$48.20/week',
            total: 'HK\$192.80',
          ),
          _UpgradePlan(
            tag: '',
            title: '6 month',
            price: 'HK\$30.10/ week',
            total: 'HK\$722.40',
          ),
        ],
        buttonStart: Color(0xFFFF2D65),
        buttonEnd: Color(0xFFFF5D55),
      );
  }
}
