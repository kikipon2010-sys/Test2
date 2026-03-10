import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/knowledge_item.dart';
import '../providers/app_data_provider.dart';

class KnowledgeWallPage extends StatefulWidget {
  const KnowledgeWallPage({super.key});

  @override
  State<KnowledgeWallPage> createState() => _KnowledgeWallPageState();
}

class _KnowledgeWallPageState extends State<KnowledgeWallPage> {
  KnowledgeCategory? _selectedCategory;
  
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
              '知識傳承公告牆',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '隨時學習,自主成長',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('搜尋知識庫')),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          var items = provider.knowledgeItems;
          
          // 過濾分類
          if (_selectedCategory != null) {
            items = items.where((item) => item.category == _selectedCategory).toList();
          }
          
          // 分離置頂和非置頂項目
          final pinnedItems = items.where((item) => item.isPinned).toList();
          final regularItems = items.where((item) => !item.isPinned).toList();
          
          return Column(
            children: [
              // 分類篩選器
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildCategoryChip('全部', null),
                      const SizedBox(width: 8),
                      _buildCategoryChip('SOP', KnowledgeCategory.sop),
                      const SizedBox(width: 8),
                      _buildCategoryChip('培訓', KnowledgeCategory.training),
                      const SizedBox(width: 8),
                      _buildCategoryChip('公告', KnowledgeCategory.announcement),
                      const SizedBox(width: 8),
                      _buildCategoryChip('政策', KnowledgeCategory.policy),
                      const SizedBox(width: 8),
                      _buildCategoryChip('FAQ', KnowledgeCategory.faq),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 知識項目列表
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // 新人專區提示
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[700]!, Colors.blue[500]!],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.white, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '新人學習專區',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '歡迎加入!透過知識庫快速上手,取代傳統口頭教導',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 置頂項目
                    if (pinnedItems.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.push_pin, size: 16, color: Colors.red[700]),
                          const SizedBox(width: 4),
                          Text(
                            '置頂內容',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...pinnedItems.map((item) => _buildKnowledgeCard(context, item, true)),
                      const SizedBox(height: 16),
                    ],
                    
                    // 一般項目
                    if (regularItems.isNotEmpty) ...[
                      if (pinnedItems.isNotEmpty)
                        Text(
                          '所有內容',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      if (pinnedItems.isNotEmpty) const SizedBox(height: 8),
                      ...regularItems.map((item) => _buildKnowledgeCard(context, item, false)),
                    ],
                    
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('發佈新內容')),
          );
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add),
        label: const Text('發佈'),
      ),
    );
  }

  Widget _buildCategoryChip(String label, KnowledgeCategory? category) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      selectedColor: Colors.white,
      checkmarkColor: const Color(0xFF1976D2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1976D2) : Colors.white,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildKnowledgeCard(BuildContext context, KnowledgeItem item, bool isPinned) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isPinned ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPinned
            ? BorderSide(color: Colors.orange[300]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showKnowledgeDetailDialog(context, item);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 分類標籤
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: item.getCategoryColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.getCategoryIcon(),
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.getCategoryText(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 標籤
                  ...item.tags.take(2).map((tag) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      )),
                  
                  const Spacer(),
                  
                  // 置頂圖示
                  if (isPinned)
                    Icon(Icons.push_pin, size: 16, color: Colors.red[700]),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 標題
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 內容預覽
              Text(
                item.content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              // 底部資訊
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    item.author,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(item.publishedDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.visibility, size: 14, color: Colors.blue[700]),
                  const SizedBox(width: 4),
                  Text(
                    '${item.viewCount}',
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ],
              ),
              
              if (item.attachmentUrl != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_file, size: 14, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        '附件',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  void _showKnowledgeDetailDialog(BuildContext context, KnowledgeItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 頂部分類和標籤
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: item.getCategoryColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.getCategoryIcon(),
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.getCategoryText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (item.isPinned)
                      Icon(Icons.push_pin, color: Colors.red[700]),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 標題
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 元資訊
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          item.author,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${item.publishedDate.year}/${item.publishedDate.month}/${item.publishedDate.day}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          '${item.viewCount} 次瀏覽',
                          style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 標籤
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      )).toList(),
                ),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // 內容
                Text(
                  item.content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // SOP 示意
                if (item.category == KnowledgeCategory.sop) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              '標準作業步驟',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSOPStep('1', '開啟系統並確認設備正常'),
                        _buildSOPStep('2', '檢查所有項目並記錄'),
                        _buildSOPStep('3', '完成後提交回報'),
                        _buildSOPStep('4', '等待主管確認'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // 附件
                if (item.attachmentUrl != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: Colors.grey[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '相關附件文件.pdf',
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Icon(Icons.download, color: Colors.blue[700]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // 操作按鈕
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已加入收藏')),
                          );
                        },
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('收藏'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('關閉'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSOPStep(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
