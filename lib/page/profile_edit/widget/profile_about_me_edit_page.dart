import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/tool/event_bus.dart';

class ProfileAboutMeEditPage extends StatefulWidget {
  final UserPrompt model;

  const ProfileAboutMeEditPage({super.key, required this.model});

  @override
  State<ProfileAboutMeEditPage> createState() => _ProfileAboutMeEditPageState();
}

class _ProfileAboutMeEditPageState extends State<ProfileAboutMeEditPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 初始化控制器，设置初始值
    _controller = TextEditingController(text: widget.model.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回答提示'),
        actions: [
          // 右上角勾按钮
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 回传输入框中的文本
              //返回 ProfileEditPage 页面
              widget.model.content = _controller.text;
              // 通过 eventBus 发送文本
              eventBus.fire(PromptAnswerEvent(widget.model));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 显示从列表页传过来的提示文本
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.model.title),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 输入框
            TextField(
              controller: _controller,
              maxLength: 150,
              decoration: const InputDecoration(
                hintText: '写点有趣的答案吧...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
