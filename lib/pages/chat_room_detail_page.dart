import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/app_data_provider.dart';

class ChatRoomDetailPage extends StatefulWidget {
  final ChatRoom room;
  
  const ChatRoomDetailPage({super.key, required this.room});

  @override
  State<ChatRoomDetailPage> createState() => _ChatRoomDetailPageState();
}

class _ChatRoomDetailPageState extends State<ChatRoomDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1976D2),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.room.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${widget.room.participantIds.length} 位成員',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showRoomInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 訊息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.room.messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(widget.room.messages[index]);
              },
            ),
          ),
          
          // 輸入框
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // 快速操作按鈕
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: const Color(0xFF1976D2),
                    onPressed: () {
                      _showQuickActions();
                    },
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 輸入框
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: '輸入訊息...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 發送按鈕
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF1976D2),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isCurrentUser = message.senderRole == UserRole.manager; // 假設當前用戶是店長
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isCurrentUser 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          // 發送者資訊
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: message.getRoleColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.getRoleText(),
                      style: TextStyle(
                        fontSize: 10,
                        color: message.getRoleColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // 訊息氣泡
          Row(
            mainAxisAlignment: isCurrentUser 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getMessageBubbleColor(message, isCurrentUser),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isCurrentUser 
                        ? const Radius.circular(20) 
                        : const Radius.circular(4),
                    bottomRight: isCurrentUser 
                        ? const Radius.circular(4) 
                        : const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 訊息類型標籤
                    if (message.type != MessageType.text)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getMessageTypeColor(message.type).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              message.getTypeIcon(),
                              size: 14,
                              color: _getMessageTypeColor(message.type),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getMessageTypeText(message.type),
                              style: TextStyle(
                                fontSize: 11,
                                color: _getMessageTypeColor(message.type),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // 訊息內容
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        color: isCurrentUser ? Colors.white : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // 時間戳
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: isCurrentUser 
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMessageBubbleColor(ChatMessage message, bool isCurrentUser) {
    if (isCurrentUser) {
      return const Color(0xFF1976D2);
    }
    
    switch (message.type) {
      case MessageType.taskAssignment:
        return Colors.orange[50]!;
      case MessageType.feedback:
        return Colors.purple[50]!;
      case MessageType.systemNotice:
        return Colors.grey[200]!;
      default:
        return Colors.white;
    }
  }

  Color _getMessageTypeColor(MessageType type) {
    switch (type) {
      case MessageType.taskAssignment:
        return Colors.orange;
      case MessageType.feedback:
        return Colors.purple;
      case MessageType.systemNotice:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getMessageTypeText(MessageType type) {
    switch (type) {
      case MessageType.taskAssignment:
        return '任務交辦';
      case MessageType.feedback:
        return '主管回饋';
      case MessageType.systemNotice:
        return '系統通知';
      default:
        return '訊息';
    }
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return '剛剛';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分鐘前';
    } else if (difference.inHours < 24) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'manager_001',
      senderName: '李店長',
      senderRole: UserRole.manager,
      content: _messageController.text.trim(),
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    provider.sendMessage(widget.room.id, message);
    _messageController.clear();
    
    // 滾動到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('訊息已發送'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '快速操作',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickActionButton(
              Icons.assignment_turned_in,
              '任務交辦',
              Colors.orange,
              () {
                Navigator.pop(context);
                _showTaskAssignmentDialog();
              },
            ),
            _buildQuickActionButton(
              Icons.feedback,
              '主管回饋',
              Colors.purple,
              () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
            _buildQuickActionButton(
              Icons.attach_file,
              '發送附件',
              Colors.blue,
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('附件功能開發中')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showTaskAssignmentDialog() {
    final taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in, color: Colors.orange),
            SizedBox(width: 8),
            Text('任務交辦'),
          ],
        ),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(
            hintText: '輸入任務內容...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.trim().isNotEmpty) {
                final provider = Provider.of<AppDataProvider>(context, listen: false);
                final message = ChatMessage(
                  id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
                  senderId: 'manager_001',
                  senderName: '李店長',
                  senderRole: UserRole.manager,
                  content: taskController.text.trim(),
                  type: MessageType.taskAssignment,
                  timestamp: DateTime.now(),
                  isRead: false,
                );
                provider.sendMessage(widget.room.id, message);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ 任務已交辦')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('發送'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.feedback, color: Colors.purple),
            SizedBox(width: 8),
            Text('主管回饋'),
          ],
        ),
        content: TextField(
          controller: feedbackController,
          decoration: const InputDecoration(
            hintText: '輸入回饋內容...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.trim().isNotEmpty) {
                final provider = Provider.of<AppDataProvider>(context, listen: false);
                final message = ChatMessage(
                  id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
                  senderId: 'manager_001',
                  senderName: '李店長',
                  senderRole: UserRole.manager,
                  content: feedbackController.text.trim(),
                  type: MessageType.feedback,
                  timestamp: DateTime.now(),
                  isRead: false,
                );
                provider.sendMessage(widget.room.id, message);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ 回饋已發送')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: const Text('發送'),
          ),
        ],
      ),
    );
  }

  void _showRoomInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('群組資訊'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('群組名稱: ${widget.room.title}'),
            const SizedBox(height: 8),
            Text('成員數量: ${widget.room.participantIds.length}'),
            const SizedBox(height: 8),
            Text('訊息數量: ${widget.room.messages.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }
}
