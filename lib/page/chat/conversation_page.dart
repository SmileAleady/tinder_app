import 'package:flutter/material.dart';
import 'package:tinder_app/data/chat/chat_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/chat/chat_safety_ui.dart';
import 'package:tinder_app/widget/user_page.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key, required this.peer});

  final ConversationPeer peer;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatUserProfile? _activeUser;
  UserProfileModel? _peerProfile;
  final List<ConversationMessage> _messages = [];

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _isFirstConversation = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _bootstrap();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final active = await ChatLocalDb.instance.getActiveUser();
    final peer = await ChatLocalDb.instance.getUserProfileById(
      widget.peer.peerId,
    );

    if (!mounted) {
      return;
    }

    if (active == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _activeUser = active;
    _peerProfile = peer;

    await ChatLocalDb.instance.markConversationOpened(
      pairId: widget.peer.pairId,
      userId: active.userId,
    );

    final detail = await ChatLocalDb.instance.getConversationDetail(
      pairId: widget.peer.pairId,
      activeUserId: active.userId,
      page: _page,
      pageSize: 10,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _messages
        ..clear()
        ..addAll(detail.messages);
      _hasMore = detail.hasMore;
      _isFirstConversation = detail.isFirstConversation;
      _loading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _handleScroll() {
    if (_scrollController.position.pixels <= 80 &&
        !_loadingMore &&
        _hasMore &&
        !_loading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_activeUser == null || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    final oldMax = _scrollController.hasClients
        ? _scrollController.position.maxScrollExtent
        : 0.0;
    final oldOffset = _scrollController.hasClients
        ? _scrollController.position.pixels
        : 0.0;

    final nextPage = _page + 1;
    final detail = await ChatLocalDb.instance.getConversationDetail(
      pairId: widget.peer.pairId,
      activeUserId: _activeUser!.userId,
      page: nextPage,
      pageSize: 10,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _page = nextPage;
      _hasMore = detail.hasMore;
      _messages.insertAll(0, detail.messages);
      _loadingMore = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final newMax = _scrollController.position.maxScrollExtent;
      final delta = newMax - oldMax;
      _scrollController.jumpTo(oldOffset + delta);
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _activeUser == null) {
      return;
    }

    final now = DateTime.now();
    final msg = ConversationMessage(
      id: '${now.microsecondsSinceEpoch}_${_activeUser!.userId}',
      content: text,
      timestamp: now,
      isMine: true,
      status: 'sent',
    );

    setState(() {
      _messages.add(msg);
      _isFirstConversation = false;
    });

    _inputController.clear();

    await ChatLocalDb.instance.sendMessage(
      pairId: widget.peer.pairId,
      senderId: _activeUser!.userId,
      receiverId: widget.peer.peerId,
      content: text,
    );

    if (!mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openSafetySheet() async {
    final result = await showSafetyToolboxSheet(
      context,
      peerName: widget.peer.peerName,
      onUnmatchConfirmed: () =>
          ChatLocalDb.instance.removePairAndMessages(widget.peer.pairId),
      onBlockConfirmed: () =>
          ChatLocalDb.instance.removePairAndMessages(widget.peer.pairId),
    );

    if (!mounted) {
      return;
    }

    if (result == SafetySheetResult.unmatched ||
        result == SafetySheetResult.blocked) {
      Navigator.of(context).pop(true);
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

    if (_activeUser == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('请先登录后查看会话')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Container(height: 1, color: const Color(0xFFE3E5EC)),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                    itemCount: _messages.length + (_loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_loadingMore && index == 0) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 14),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final dataIndex = _loadingMore ? index - 1 : index;
                      final message = _messages[dataIndex];
                      final showTime =
                          dataIndex == 0 ||
                          _messages[dataIndex].timestamp
                                  .difference(
                                    _messages[dataIndex - 1].timestamp,
                                  )
                                  .inMinutes >
                              10;

                      return Column(
                        children: [
                          if (showTime)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                _formatDayTime(message.timestamp),
                                style: const TextStyle(
                                  color: Color(0xFF5F6270),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          Align(
                            alignment: message.isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: message.isMine
                                ? _mineBubble(message)
                                : _peerBubble(message),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                  if (_messages.isEmpty || _isFirstConversation)
                    Center(child: _firstConversationHint()),
                ],
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 10, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF242738),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_peerProfile == null) {
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserPage(userProfile: _peerProfile!),
                ),
              );
            },
            child: Row(
              children: [
                _smallAvatar(widget.peer.peerName, widget.peer.peerAvatar),
                const SizedBox(width: 10),
                Text(
                  widget.peer.peerName,
                  style: const TextStyle(
                    fontSize: 32 / 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _openSafetySheet,
            icon: const Icon(
              Icons.more_horiz,
              size: 30,
              color: Color(0xFF333748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstConversationHint() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '您已与 ${widget.peer.peerName} 配对',
          style: const TextStyle(color: Color(0xFF616573), fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          _formatMatchedAgo(widget.peer.matchedAt),
          style: const TextStyle(color: Color(0xFF9DA1AE), fontSize: 18),
        ),
        const SizedBox(height: 20),
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE8E9EF),
            image: widget.peer.peerAvatar.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.peer.peerAvatar),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  )
                : null,
          ),
          child: widget.peer.peerAvatar.isEmpty
              ? Center(
                  child: Text(
                    widget.peer.peerName.isEmpty
                        ? '?'
                        : widget.peer.peerName.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 58,
                      color: Color(0xFF4B4F5E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget _mineBubble(ConversationMessage msg) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.62,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0A5DE8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Text(
              msg.content,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '已发送',
            style: TextStyle(color: Color(0xFF5F6270), fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _peerBubble(ConversationMessage msg) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.62,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.content,
          style: const TextStyle(color: Color(0xFF252839), fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFF0A5DE8),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'GIF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB7BAC8), width: 1.5),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: '输入消息...',
                        hintStyle: TextStyle(
                          color: Color(0xFF777B8A),
                          fontSize: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _sendMessage,
                    child: const Text(
                      '发送',
                      style: TextStyle(
                        color: Color(0xFF262A3A),
                        fontSize: 38 / 2,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _smallAvatar(String name, String url) {
    if (url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _avatarFallback(name),
        ),
      );
    }
    return _avatarFallback(name);
  }

  Widget _avatarFallback(String name) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE6E8EF),
      ),
      child: Center(
        child: Text(
          name.isEmpty ? '?' : name.substring(0, 1),
          style: const TextStyle(
            color: Color(0xFF4A4D5D),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  String _formatDayTime(DateTime time) {
    final now = DateTime.now();
    final sameDay =
        now.year == time.year && now.month == time.month && now.day == time.day;
    final h = time.hour > 12 ? time.hour - 12 : time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    return sameDay
        ? '今天 下午${h == 0 ? 12 : h}:$m'
        : '${time.year}/${time.month}/${time.day} ${time.hour}:$m';
  }

  String _formatMatchedAgo(DateTime matchedAt) {
    final days = DateTime.now().difference(matchedAt).inDays;
    if (days <= 0) {
      return '今天';
    }
    return '$days天前';
  }
}
