import 'package:flutter/material.dart';

class ProfilePersonalDescPage extends StatefulWidget {
  final String initialValue;

  const ProfilePersonalDescPage({super.key, required this.initialValue});

  @override
  State<ProfilePersonalDescPage> createState() => _ProfilePersonalDescPageState();
}

class _ProfilePersonalDescPageState extends State<ProfilePersonalDescPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = _controller.text.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Color(0xFF697385), size: 32),
                ),
                const Expanded(
                  child: Text(
                    '添加个人介绍',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1D2433),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text.trim());
                  },
                  icon: const Icon(Icons.check, color: Color(0xFF697385), size: 30),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFAAB1BE), width: 1.2),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLength: 500,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      counterText: '',
                      hintText: '烹饪与散步是我的小确幸，约会的话希望顺其自然。',
                      hintStyle: TextStyle(
                        color: Color(0xFF798395),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(Icons.edit, color: Color(0xFF7C8494)),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF293142),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: '$count',
                            style: TextStyle(
                              color: count >= 500
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF697385),
                            ),
                          ),
                          const TextSpan(
                            text: '/500',
                            style: TextStyle(color: Color(0xFF697385)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    '简短凝练的个人介绍才是好的。分享下你的兴趣、价值取向及交友期待。',
                    style: TextStyle(
                      color: Color(0xFF515A6B),
                      fontSize: 17,
                      height: 1.35,
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D2433),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          '个人介绍提示',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
