import 'package:flutter/material.dart';

enum SafetySheetResult { none, unmatched, blocked, reported }

enum _SafetyAction { unmatch, report, block, safetyCenter }

Future<SafetySheetResult> showSafetyToolboxSheet(
  BuildContext context, {
  required String peerName,
  Future<void> Function()? onUnmatchConfirmed,
  Future<void> Function()? onBlockConfirmed,
}) async {
  final action = await showModalBottomSheet<_SafetyAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFBEC2CD),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '安全工具包',
              style: TextStyle(fontSize: 42 / 2, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _sheetTile(
              icon: Icons.cancel,
              iconColor: const Color(0xFFFF5A5F),
              title: '与$peerName取消配对',
              subtitle: '已经不感兴趣？你可以与对方取消配对。',
              onTap: () => Navigator.of(ctx).pop(_SafetyAction.unmatch),
            ),
            _sheetTile(
              icon: Icons.flag,
              iconColor: const Color(0xFFFF2D55),
              title: '举报$peerName',
              subtitle: '别担心，我们不会告知对方。',
              onTap: () => Navigator.of(ctx).pop(_SafetyAction.report),
            ),
            _sheetTile(
              icon: Icons.block,
              iconColor: const Color(0xFF5A5A6B),
              title: '屏蔽$peerName',
              subtitle: '你和对方将互不可见。',
              onTap: () => Navigator.of(ctx).pop(_SafetyAction.block),
            ),
            _sheetTile(
              icon: Icons.shield,
              iconColor: const Color(0xFF1E63F1),
              title: '访问安全中心',
              subtitle: '你的体验至关重要。请在此处查找安全资源和工具。',
              onTap: () => Navigator.of(ctx).pop(_SafetyAction.safetyCenter),
            ),
          ],
        ),
      );
    },
  );
  if (!context.mounted) {
    return SafetySheetResult.none;
  }

  switch (action) {
    case _SafetyAction.unmatch:
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => _ConfirmActionDialog(
          title: '你想要与该用户取消配对吗?',
          message: '',
          dangerText: '是的，取消配对',
          cancelText: '取消',
        ),
      );
      if (!context.mounted) {
        return SafetySheetResult.none;
      }
      if (confirmed == true) {
        await onUnmatchConfirmed?.call();
        return SafetySheetResult.unmatched;
      }
      return SafetySheetResult.none;
    case _SafetyAction.block:
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => _ConfirmActionDialog(
          title: '要屏蔽$peerName吗?',
          message: '此操作无法撤销，确定要继续吗？',
          dangerText: '是的，屏蔽',
          cancelText: '不，不要屏蔽',
          pillStyle: true,
        ),
      );
      if (!context.mounted) {
        return SafetySheetResult.none;
      }
      if (confirmed == true) {
        await onBlockConfirmed?.call();
        return SafetySheetResult.blocked;
      }
      return SafetySheetResult.none;
    case _SafetyAction.report:
      final submitted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => ReportFlowPage(peerName: peerName)),
      );
      if (!context.mounted) {
        return SafetySheetResult.none;
      }
      return submitted == true
          ? SafetySheetResult.reported
          : SafetySheetResult.none;
    case _SafetyAction.safetyCenter:
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SafetyCenterPage()));
      return SafetySheetResult.none;
    case null:
      return SafetySheetResult.none;
  }
}

Widget _sheetTile({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(icon, size: 30, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 38 / 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6E7280),
                    fontSize: 33 / 2,
                    height: 1.35,
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

class _ConfirmActionDialog extends StatelessWidget {
  const _ConfirmActionDialog({
    required this.title,
    required this.message,
    required this.dangerText,
    required this.cancelText,
    this.pillStyle = false,
  });

  final String title;
  final String message;
  final String dangerText;
  final String cancelText;
  final bool pillStyle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pillStyle)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close, size: 30),
                ),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 46 / 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 39 / 2,
                  color: Color(0xFF4A4A56),
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pillStyle
                      ? const Color(0xFFFF0050)
                      : Colors.transparent,
                  foregroundColor: pillStyle
                      ? Colors.white
                      : const Color(0xFFFF2D55),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: pillStyle ? 14 : 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(pillStyle ? 999 : 0),
                  ),
                ),
                child: Text(
                  dangerText,
                  style: TextStyle(
                    fontSize: 48 / 2,
                    fontWeight: FontWeight.w700,
                    color: pillStyle ? Colors.white : const Color(0xFFFF2D55),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: Color(0xFF3A3D4A),
                  fontWeight: FontWeight.w500,
                  fontSize: 48 / 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportFlowPage extends StatefulWidget {
  const ReportFlowPage({super.key, required this.peerName});

  final String peerName;

  @override
  State<ReportFlowPage> createState() => _ReportFlowPageState();
}

class _ReportFlowPageState extends State<ReportFlowPage> {
  int _step = 0;
  int _reasonIndex = 1;
  int _detailIndex = 1;
  final TextEditingController _commentController = TextEditingController();

  final List<String> _reasonOptions = const [
    '对方在 Tinder 上给我发送的信息',
    '发生在 Tinder 之外或线下的事',
    '我对这个人不感兴趣',
  ];

  final List<String> _detailOptions = const ['裸露内容', '性暴露行为', '性勒索'];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.shield, color: Color(0xFF1E63F1), size: 28),
        title: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消', style: TextStyle(color: Color(0xFF1F5FD6))),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: _buildStepBody(),
              ),
            ),
            const Text(
              '我们不会将你的举报告知 ria',
              style: TextStyle(color: Color(0xFF4A4A56), fontSize: 17),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF07070F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    _step == 2 ? '提交' : '下一步',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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

  Widget _buildStepHeader() {
    final labels = const ['原因', '详细信息', '提交'];
    return Column(
      children: [
        Row(
          children: List.generate(3, (index) {
            final active = index <= _step;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                color: active
                    ? const Color(0xFFFF2D55)
                    : const Color(0xFFE5E6EC),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            labels.length,
            (index) => Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index == _step
                      ? const Color(0xFF121320)
                      : const Color(0xFF8A8D9A),
                  fontSize: 30 / 2,
                  fontWeight: index == _step
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepBody() {
    if (_step == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
            '你想向我们举报什么?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 52 / 2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          const Text(
            '我们重视你的安全和你提供的信息。如果你正面临直接危险，请联系你当地的相关部门。我们将会对你提供的信息进行保密处理。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36 / 2,
              color: Color(0xFF4A4D5A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(_reasonOptions.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _selectableCard(
                selected: _reasonIndex == index,
                title: _reasonOptions[index],
                onTap: () => setState(() => _reasonIndex = index),
              ),
            );
          }),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '如果你需要举报他人的个人资料，请回到对方的个人资料页面，并查找你想要举报的内容。接着点击三点图标，然后选择“举报”。',
              style: TextStyle(
                fontSize: 35 / 2,
                color: Color(0xFF4F5360),
                height: 1.4,
              ),
            ),
          ),
        ],
      );
    }

    if (_step == 1) {
      if (_reasonIndex == 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              '可以告诉我们发生了什么吗?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 52 / 2, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 18),
            ...List.generate(_detailOptions.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _selectableCard(
                  selected: _detailIndex == index,
                  title: _detailOptions[index],
                  onTap: () => setState(() => _detailIndex = index),
                ),
              );
            }),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          const Text(
            '你愿意分享更多细节信息吗?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 52 / 2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          const Text(
            '添加评论',
            style: TextStyle(fontSize: 44 / 2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            minLines: 3,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: '事实上点点滴滴\n俄二人反反复复',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF808494)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF808494)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '最少字符数：5',
            style: TextStyle(fontSize: 14, color: Color(0xFF535766)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          '举报 ${widget.peerName}',
          style: const TextStyle(fontSize: 56 / 2, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        const Text(
          '我们重视你的安全和你提供的信息。出于你的安全考虑，我们将会对你提供的信息进行保密处理。',
          style: TextStyle(
            fontSize: 35 / 2,
            color: Color(0xFF3A3E4D),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '查看你的举报',
          style: TextStyle(fontSize: 48 / 2, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        _summaryItem('我要举报的是：', _reasonOptions[_reasonIndex]),
        _summaryItem('我举报的原因：', _reasonIndex == 1 ? '含裸露或性暴露内容' : '需要平台介入处理'),
        _summaryItem(
          '发生的事情：',
          _reasonIndex == 1 ? _detailOptions[_detailIndex] : '更多细节已填写',
        ),
        const SizedBox(height: 6),
        const Text(
          '更多评论：',
          style: TextStyle(fontSize: 46 / 2, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commentController,
          minLines: 2,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '输入补充信息',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF808494)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF808494)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E3EA))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 46 / 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 42 / 2, color: Color(0xFF313445)),
          ),
        ],
      ),
    );
  }

  Widget _selectableCard({
    required bool selected,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFFF2D55) : const Color(0xFFCACDDA),
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 42 / 2,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check, color: Color(0xFFFF2D55), size: 22),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (_step < 2) {
      setState(() {
        _step += 1;
      });
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('举报已提交')));
    Navigator.of(context).pop(true);
  }
}

class SafetyCenterPage extends StatefulWidget {
  const SafetyCenterPage({super.key});

  @override
  State<SafetyCenterPage> createState() => _SafetyCenterPageState();
}

class _SafetyCenterPageState extends State<SafetyCenterPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const Expanded(
                    child: Text(
                      '安全中心',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Row(
              children: [
                _tabItem('指南', 0),
                _tabItem('工具', 1),
                _tabItem('资源', 2),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
                children: _tab == 0
                    ? _guideContent()
                    : _tab == 1
                    ? _toolsContent()
                    : _resourceContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String label, int index) {
    final selected = _tab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = index),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 34 / 2,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF191B29)
                      : const Color(0xFF697088),
                ),
              ),
            ),
            Container(
              height: 3,
              color: selected
                  ? const Color(0xFFFF2D55)
                  : const Color(0xFFDADDE7),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _guideContent() {
    return [
      const SizedBox(height: 2),
      const Text(
        '嗨 Duxu',
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
      ),
      const Text('以下是你需要了解的一些安全贴士', style: TextStyle(color: Color(0xFF5F6475))),
      const SizedBox(height: 16),
      _sectionTitle('Safety'),
      _card(
        'The Basics',
        'What you need to know to be safer on Tinder and IRL — all in one place.',
      ),
      _smallCard('Online Dating Safety Quiz'),
      _smallCard('Tinder Community Guidelines Quiz'),
      const SizedBox(height: 10),
      _sectionTitle('Harassment'),
      _card('How To Deal', 'If you see something, say something.'),
      const SizedBox(height: 10),
      _sectionTitle('In Real Life'),
      _card(
        'Your IRL Guide',
        'Tips to help you be safer IRL (even though we wish you didn’t have to).',
      ),
      _smallCard('IRL Safety 101 Quiz'),
      const SizedBox(height: 10),
      _sectionTitle('Reporting'),
      _card(
        'What to Report',
        'When you should report someone and when you shouldn’t.',
      ),
      _smallCard('How To Report Someone'),
      _smallCard('What Happens After I Report?'),
      const SizedBox(height: 10),
      _sectionTitle('Consent'),
      _card(
        'Consent 101',
        'It’s a necessary part of any connection and we’re here to give you a crash course.',
      ),
      const SizedBox(height: 10),
      _sectionTitle('Travel'),
      _card(
        "The Do's and Don'ts",
        'In order to have the trip of a lifetime, there are a few things you need to know.',
      ),
    ];
  }

  List<Widget> _toolsContent() {
    return [
      _card(
        'How to report',
        'Reporting is a safe way to let us know that someone is acting inappropriately.',
      ),
      _card(
        'Privacy Settings',
        'Customize your experience with these privacy features and settings.',
      ),
      _card(
        'How to Unmatch',
        'Whether you realize you just aren’t that interested or your match starts acting inappropriately, you can always unmatch them.',
      ),
      _card(
        'How to get Photo Verified',
        'The best way to know someone isn’t too good to be true.',
      ),
    ];
  }

  List<Widget> _resourceContent() {
    return [
      Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ThroughLine',
              style: TextStyle(
                color: Color(0xFF1D4AB4),
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'ThroughLine 可为您提供免费、保密的心理健康热线支持，或在您遭遇创伤性事件时提供支持。注意：帮助热线是独立服务，与 Tinder 无关。',
              style: TextStyle(
                fontSize: 33 / 2,
                color: Color(0xFF2F3340),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB6B8C7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                '访问网站',
                style: TextStyle(color: Color(0xFF2D3142)),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 38 / 2, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _card(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.security, color: Color(0xFF5F73F6)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF4D5160),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Color(0xFF7A7F8D)),
        ],
      ),
    );
  }

  Widget _smallCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF7A7F8D)),
        ],
      ),
    );
  }
}
