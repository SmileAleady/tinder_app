import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_about_me_edit_page.dart';

// data_model.dart

class ProfileAboutMeListPage extends StatefulWidget {
  const ProfileAboutMeListPage({super.key});

  @override
  State<ProfileAboutMeListPage> createState() => _ProfileAboutMeListPageState();
}

class _ProfileAboutMeListPageState extends State<ProfileAboutMeListPage> {
  // 模拟图1和图2中的所有提示数据
  final List<UserPrompt> _prompts = [
    UserPrompt(title: '我可以在...游戏中打败你。'),
    UserPrompt(title: '我的弱点是...'),
    UserPrompt(title: '如果我的生命只剩 20 分钟，我会...'),
    UserPrompt(title: '如果...，那么我的父母会喜欢你。'),
    UserPrompt(title: '给我发消息如果你也喜欢...'),
    UserPrompt(title: '我的隐藏天赋是...'),
    UserPrompt(title: '关于我的两个真相和一个谎言...'),
    UserPrompt(title: '什么能让我敞开心扉...'),
    UserPrompt(title: '你能做的最过火的事是...'),
    UserPrompt(title: '我最糟糕的宵夜习惯是...'),
    UserPrompt(title: '我的一个既怪异又真实的经历是...'),
    UserPrompt(title: '生命太短暂，不能浪费在...'),
    UserPrompt(title: '我：我已经长大成人了。还是我：'),
    UserPrompt(title: '我理想的工作是...'),
    UserPrompt(title: '最让我警惕的是...'),
    UserPrompt(title: '我最喜欢的歌单叫...'),
    UserPrompt(title: '如果我不在家，你会在...找到我。'),
    UserPrompt(title: '我的初次约会愿望清单：'),
    UserPrompt(title: '关于我的一个惊人事实是...'),
    UserPrompt(title: '我想要找...的人。'),
    UserPrompt(title: '和我约会的好处是...'),
    UserPrompt(title: '我的卡拉 OK 必唱曲目是...'),
    UserPrompt(title: '我的传记可能会名为...'),
    UserPrompt(title: '大家会说我...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择一条提示')),
      body: ListView.builder(
        itemCount: _prompts.length,
        itemBuilder: (context, index) {
          final item = _prompts[index];
          return ListTile(
            title: Text(item.title),
            subtitle: (item.content != null && item.content!.isNotEmpty)
                ? Text(
                    item.content!,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            onTap: () {
              // 跳转到详情页，并等待回传数据
              // final result = await Navigator.push(
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileAboutMeEditPage(model: item),
                ),
              );

              // 如果有回传数据，更新列表项
              // if (result != null && result is String) {
              //   setState(() {
              //     _prompts[index].answer = result;
              //   });
              // }
            },
          );
        },
      ),
    );
  }
}
