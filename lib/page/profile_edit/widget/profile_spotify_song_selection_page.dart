import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/model/user_profile_model.dart'; // 假设使用了spotify相关包

class ProfileSpotifySongSelectionWidget extends StatefulWidget {
  // 回调函数定义
  final Function(DateTime clickTime) onNoFavoriteClick;
  final Function(MusicModel selectedMusic) onMusicSelected;

  const ProfileSpotifySongSelectionWidget({
    super.key,
    required this.onNoFavoriteClick,
    required this.onMusicSelected,
  });

  @override
  State<ProfileSpotifySongSelectionWidget> createState() =>
      _ProfileSpotifySongSelectionWidgetState();
}

class _ProfileSpotifySongSelectionWidgetState
    extends State<ProfileSpotifySongSelectionWidget> {
  // 模拟从图中获取的歌曲列表数据

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TextField(
          decoration: InputDecoration(
            hintText: '搜索 Spotify 歌曲',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          // 可在此处添加搜索逻辑
        ),
      ),
      body: ListView(
        children: [
          // 1. "我不想要最爱歌曲" 项
          ListTile(
            leading: const Icon(Icons.not_interested),
            title: const Text('我不想要最爱歌曲'),
            onTap: () {
              // 回调点击时间
              widget.onNoFavoriteClick(DateTime.now());
              // 关闭当前界面
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // 2. 列表标题
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Spotify 上受欢迎',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 3. 歌曲列表
          ...OptionDataManager.songs.map((music) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  music.coverImageUrl ?? 'https://via.placeholder.com/50',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(music.title),
              subtitle: Row(
                children: [
                  const Icon(Icons.shopify, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(music.artist),
                ],
              ),
              onTap: () {
                // 回调选中的音乐模型
                widget.onMusicSelected(music);
                // 关闭当前界面
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
