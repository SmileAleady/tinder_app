import 'package:flutter/material.dart';
import 'package:tinder_app/model/chat_conversation_model.dart';
import 'package:tinder_app/model/chat_user_model.dart';
import 'package:tinder_app/model/message_model.dart';
import 'package:tinder_app/page/chat/chat_page.dart';

class MyMessagePage extends StatefulWidget {
  const MyMessagePage({super.key});

  @override
  State<MyMessagePage> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {
  final List<ChatConversationModel> messages = [
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'Christine',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'hahah',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'yyyyy',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'Christine',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'Christine',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: '66hfthhtfht',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
    ChatConversationModel(
      conversationId: '1',
      receiver: null,
      sender: ChatUserModel(
        name: 'gdrgrdgrgrg',
        avatar: 'https://via.placeholder.com/150',
        message: '近期活跃，马上配对!',
        badge: '看谁点了赞',
        isOnline: true,
        isBadgeYellow: true,
      ),
    ),
  ];

  final List<MatchItem> matches = [
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: '20 次赞',
      subtitle: '',
      isHighlight: true,
    ),
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: 'SuperKelly',
      subtitle: '',
      isVerified: true,
    ),
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: 'Emma',
      subtitle: '',
      isVerified: true,
    ),
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: 'Sophie',
      subtitle: '',
    ),
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: 'Jessica',
      subtitle: '',
      isVerified: true,
    ),
    MatchItem(
      image: 'https://via.placeholder.com/150',
      title: 'Amanda',
      subtitle: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // 顶部AppBar
            // _buildTopBar(),

            // 新的配对部分
            _buildNewMatches(),

            // 消息部分
            _buildMessagesSection(),
          ],
        ),
      ),
    );
  }

  // Widget _buildTopBar() {
  //   return Container(
  //     color: Colors.black,
  //     padding: EdgeInsets.fromLTRB(
  //       16,
  //       MediaQuery.of(context).padding.top + 12,
  //       16,
  //       12,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         // Tinder Logo
  //         const Text(
  //           '🔥 tinder',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         // Shield Icon
  //         Container(
  //           width: 40,
  //           height: 40,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[800],
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(color: Colors.grey[600]!, width: 1),
  //           ),
  //           child: const Icon(Icons.shield, color: Colors.grey, size: 20),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildNewMatches() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '新的配对',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: matches.map((match) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 140,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: match.isHighlight
                                ? Colors.amber
                                : Colors.transparent,
                            width: match.isHighlight ? 4 : 0,
                          ),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                match.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[700],
                                    child: Center(
                                      child: Text(
                                        match.title.replaceAll(' ', '\n'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (match.title == '20 次赞')
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.amber[400],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                match.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (match.isVerified) const SizedBox(width: 4),
                            if (match.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 14,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesSection() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '消息',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...messages.map((session) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle message tap
                    ///跳转 UserPage
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatSession: ChatSession(
                            userId: 'userId',
                            userName: 'userName',
                            userAvatar: 'https://via.placeholder.com/150',
                            matchedDate: DateTime.now(),
                            messages: [],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      // Avatar with online indicator
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              session.sender.avatar,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[700],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (session.sender.isOnline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey[900]!,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Message content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  session.sender.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (session.sender.isVerified)
                                  const SizedBox(width: 4),
                                if (session.sender.isVerified)
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              session.sender.message,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Badge
                      if (session.sender.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: session.sender.isBadgeYellow
                                ? Colors.amber[700]
                                : Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            session.sender.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[800], height: 1),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class MatchItem {
  final String image;
  final String title;
  final String subtitle;
  final bool isHighlight;
  final bool isVerified;

  MatchItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.isHighlight = false,
    this.isVerified = false,
  });
}
