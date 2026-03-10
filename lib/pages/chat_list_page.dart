import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/app_data_provider.dart';
import 'chat_room_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1976D2),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '主管回饋與溝通',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '即時交辦與主動回饋',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final rooms = provider.chatRooms;
          
          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '目前沒有對話',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              // 統計卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '對話群組',
                      '${rooms.length}',
                      Icons.forum,
                    ),
                    _buildStatItem(
                      '未讀訊息',
                      '${provider.totalUnreadMessages}',
                      Icons.mark_chat_unread,
                    ),
                    _buildStatItem(
                      '任務交辦',
                      '3',
                      Icons.assignment_turned_in,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 對話列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return _buildChatRoomCard(context, rooms[index], provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildChatRoomCard(BuildContext context, ChatRoom room, AppDataProvider provider) {
    final lastMessage = room.lastMessage;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: room.unreadCount > 0 ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: room.unreadCount > 0
            ? const BorderSide(color: Color(0xFF1976D2), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          provider.markRoomAsRead(room.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomDetailPage(room: room),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 群組圖示
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.forum,
                        color: Color(0xFF1976D2),
                        size: 28,
                      ),
                    ),
                    if (room.unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${room.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 對話內容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: room.unreadCount > 0 
                                  ? FontWeight.bold 
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(room.lastActivity),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    if (lastMessage != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // 訊息類型圖示
                          Icon(
                            lastMessage.getTypeIcon(),
                            size: 14,
                            color: lastMessage.type == MessageType.taskAssignment
                                ? Colors.orange
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          
                          // 發送者角色標籤
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: lastMessage.getRoleColor().withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lastMessage.getRoleText(),
                              style: TextStyle(
                                fontSize: 10,
                                color: lastMessage.getRoleColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 6),
                          
                          // 訊息預覽
                          Expanded(
                            child: Text(
                              '${lastMessage.senderName}: ${lastMessage.content}',
                              style: TextStyle(
                                fontSize: 13,
                                color: room.unreadCount > 0 
                                    ? Colors.black87 
                                    : Colors.grey[600],
                                fontWeight: room.unreadCount > 0 
                                    ? FontWeight.w500 
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分鐘前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 小時前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
