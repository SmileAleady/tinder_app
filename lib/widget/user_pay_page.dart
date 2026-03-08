import 'package:flutter/material.dart';

class UserPayPage extends StatefulWidget {
  const UserPayPage({super.key});

  @override
  State<UserPayPage> createState() => _UserPayPageState();
}

class _UserPayPageState extends State<UserPayPage> {
  int _selected = 0;

  static const _plans = [
    _Plan(title: '3 Impressions', unitPrice: 'HK\$36.30/each', total: 'HK\$109.00', badge: null),
    _Plan(title: '12 Impressions', unitPrice: 'HK\$25.60/each', total: 'HK\$308.00', badge: 'Save 29%', tag: 'Popular'),
    _Plan(title: '50 Impressions', unitPrice: 'HK\$13.90/each', total: 'HK\$699.00', badge: 'Save 62%', tag: 'Best Value'),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPlan = _plans[_selected];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, size: 36),
                      ),
                      const Spacer(),
                      const Icon(Icons.send, color: Color(0xFF17A8FF)),
                      const SizedBox(width: 8),
                      const Text(
                        'Get Impressions',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202733),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Send impressions to stand out first. Match success can increase up to 5x!',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF1F2632),
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var i = 0; i < _plans.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _planCard(i, _plans[i]),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFC5CBD4))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFC5CBD4))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF909CAD), width: 2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE1E4E9),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Text(
                            'Get 3 free impressions every week',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department, size: 42, color: Color(0xFF293040)),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Upgrade to Tinder Platinum™',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF202733),
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF9CA5B4)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                child: const Text(
                                  'Choose',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF1F2F4),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1177CE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Continue with total ${selectedPlan.total}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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

  Widget _planCard(int index, _Plan plan) {
    final selected = index == _selected;
    return InkWell(
      onTap: () {
        setState(() {
          _selected = index;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF1682D8) : const Color(0xFFC7CDD6),
            width: selected ? 3 : 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (plan.tag != null)
                  Text(
                    plan.tag!,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF0C79CC),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                const Spacer(),
                if (plan.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E6EA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.badge!,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFCBD1DA)),
            Row(
              children: [
                Text(
                  plan.title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF202733),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  plan.unitPrice,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF202733),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Plan {
  final String title;
  final String unitPrice;
  final String total;
  final String? badge;
  final String? tag;

  const _Plan({
    required this.title,
    required this.unitPrice,
    required this.total,
    this.badge,
    this.tag,
  });
}
