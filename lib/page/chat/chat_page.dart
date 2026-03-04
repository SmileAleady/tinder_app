import 'package:flutter/material.dart';
import '../../model/message_model.dart';

class ChatPage extends StatefulWidget {
  final ChatSession chatSession;

  const ChatPage({
    required this.chatSession,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;
  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messages = List.from(widget.chatSession.messages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isSent: true,
      status: 'sent',
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _formatTime(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 配对信息
          _buildMatchInfo(),
          
          // 消息列表
          Expanded(
            child: _buildMessageList(),
          ),

          // 输入框
          _buildInputBox(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF1a1a1a),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.chatSession.userAvatar,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[700],
                  ),
                  child: Icon(Icons.person, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Text(
            widget.chatSession.userName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildMatchInfo() {
    final matchedDate = _formatDate(widget.chatSession.matchedDate);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      color: Color(0xFF0A0E27),
      child: Center(
        child: Text(
          '你已于 $matchedDate 与 ${widget.chatSession.userName} 配对',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        
        // 显示时间戳
        Widget? timeSeparator;
        if (index == 0 || _shouldShowTimeSeparator(index)) {
          timeSeparator = Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            if (timeSeparator != null) timeSeparator,
            Align(
              alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: message.isSent ? Color(0xFF5B7EFF) : Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    if (message.isSent && message.status == 'sent')
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '已发送',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }

  bool _shouldShowTimeSeparator(int index) {
    if (index == 0) return false;
    final current = _messages[index].timestamp;
    final previous = _messages[index - 1].timestamp;
    final difference = current.difference(previous).inMinutes;
    return difference > 5;
  }

  Widget _buildInputBox() {
    return Container(
      color: Color(0xFF0A0E27),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '键入一条消息',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFF5B7EFF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '发送',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
