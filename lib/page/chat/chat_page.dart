import 'package:flutter/material.dart';
import 'package:tinder_app/data/chat/chat_local_db.dart';
import 'package:tinder_app/page/chat/chat_safety_ui.dart';
import 'package:tinder_app/page/chat/conversation_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUserProfile? _activeUser;
  ConversationListData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final active = await ChatLocalDb.instance.getActiveUser();
    if (!mounted) {
      return;
    }

    if (active == null) {
      setState(() {
        _activeUser = null;
        _loading = false;
      });
      return;
    }

    final listData = await ChatLocalDb.instance.getConversationListData(
      activeUserId: active.userId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _activeUser = active;
      _data = listData;
      _loading = false;
    });
  }

  Future<void> _openConversation(ConversationPeer peer) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ConversationPage(peer: peer)),
    );
    if (changed == true) {
      await _load();
    }
  }

  Future<void> _openTopSafetySheet() async {
    if (_data == null) {
      return;
    }

    final target = _data!.chatted.isNotEmpty
        ? _data!.chatted.first
        : (_data!.newMatches.isNotEmpty ? _data!.newMatches.first : null);
    if (target == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('暂无可操作的配对用户')));
      return;
    }

    final result = await showSafetyToolboxSheet(
      context,
      peerName: target.peerName,
      onUnmatchConfirmed: () =>
          ChatLocalDb.instance.removePairAndMessages(target.pairId),
      onBlockConfirmed: () =>
          ChatLocalDb.instance.removePairAndMessages(target.pairId),
    );

    if (result == SafetySheetResult.unmatched ||
        result == SafetySheetResult.blocked) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_activeUser == null || _data == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('请先登录后查看聊天列表', style: TextStyle(fontSize: 16)),
        ),
      );
    }

    final count = _data!.newMatches.length + _data!.chatted.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '聊天',
                        style: TextStyle(
                          fontSize: 44 / 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shield,
                        color: Color(0xFF283B66),
                        size: 26,
                      ),
                    ),
                    // Stack(
                    //   clipBehavior: Clip.none,
                    //   children: [
                    //     IconButton(
                    //       onPressed: _openTopSafetySheet,
                    //       icon: const Icon(
                    //         Icons.link,
                    //         color: Color(0xFF283B66),
                    //         size: 26,
                    //       ),
                    //     ),
                    //     Positioned(
                    //       right: 6,
                    //       top: 6,
                    //       child: Container(
                    //         width: 18,
                    //         height: 18,
                    //         decoration: const BoxDecoration(
                    //           color: Color(0xFFDF123B),
                    //           shape: BoxShape.circle,
                    //         ),
                    //         child: const Center(
                    //           child: Text(
                    //             '1',
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 11,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
              //   child: Container(
              //     height: 54,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFFE6E7ED)),
              //       borderRadius: BorderRadius.circular(14),
              //     ),
              //     child: Row(
              //       children: [
              //         const SizedBox(width: 12),
              //         const Icon(
              //           Icons.search,
              //           color: Color(0xFF6D7382),
              //           size: 24,
              //         ),
              //         const SizedBox(width: 12),
              //         Text(
              //           '搜索 $count 个配对',
              //           style: const TextStyle(
              //             color: Color(0xFF505667),
              //             fontSize: 21 / 1.2,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const Divider(height: 1, color: Color(0xFFE9EAF0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '新的配对',
                      style: TextStyle(
                        fontSize: 37 / 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 126,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _data!.newMatches.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final item = _data!.newMatches[index];
                          return GestureDetector(
                            onTap: () => _openConversation(item),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  _avatar(item.peerName, item.peerAvatar, 88),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item.peerName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 34 / 2,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      if (item.isVerified)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Icon(
                                            Icons.verified,
                                            color: Color(0xFF1D6AF5),
                                            size: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const Text(
                      '消息',
                      style: TextStyle(
                        fontSize: 37 / 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (_unreadCount > 0)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD90E37),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ..._data!.chatted.map((item) {
                return InkWell(
                  onTap: () => _openConversation(item),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                _avatar(item.peerName, item.peerAvatar, 50),
                                if (item.unreadCount > 0)
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF11C35E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item.peerName,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      if (item.isVerified)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.verified,
                                            size: 18,
                                            color: Color(0xFF1E67F1),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.latestMessage ?? '近期活跃，马上配对！',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF515666),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD60D35),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${item.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: Color(0xFFE5E6ED)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  int get _unreadCount =>
      _data?.chatted.fold<int>(0, (sum, item) => sum + item.unreadCount) ?? 0;

  Widget _avatar(String name, String url, double size) {
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _avatarFallback(name, size),
        ),
      );
    }
    return _avatarFallback(name, size);
  }

  Widget _avatarFallback(String name, double size) {
    final initials = name.isEmpty ? '?' : name.substring(0, 1);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: const Color(0xFF3D4150),
            fontSize: size / 2.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
