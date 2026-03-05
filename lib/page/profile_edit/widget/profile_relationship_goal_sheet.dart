import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// 个人资料-交往目标选择底部弹窗
class ProfileRelationshipGoalSheet extends StatelessWidget {
  /// 当前选中的选项ID（用于回显选中状态）
  final UserRelationshipGoalItem? selectedItem;

  /// 选项选中回调，可直接拿到选中的文案、ID等完整数据
  final Function(UserRelationshipGoalItem? item) onItemSelected;

  /// 关闭按钮点击回调
  final VoidCallback? onClose;

  /// 自定义选项列表，默认使用截图中的6个选项
  final List<UserRelationshipGoalItem>? items;

  const ProfileRelationshipGoalSheet({
    super.key,
    this.selectedItem,
    required this.onItemSelected,
    this.onClose,
    this.items = const [
      UserRelationshipGoalItem(id: 0, title: '寻找长期的伴侣', emoji: '💘'),
      UserRelationshipGoalItem(id: 1, title: '长期交往，但不拒绝短期交往', emoji: '😍'),
      UserRelationshipGoalItem(id: 2, title: '短期交往，但不拒绝长期交往', emoji: '🥂'),
      UserRelationshipGoalItem(id: 3, title: '享受短期交往的乐趣', emoji: '🎉'),
      UserRelationshipGoalItem(id: 4, title: '结交新朋友', emoji: '👋'),
      UserRelationshipGoalItem(id: 5, title: '我还在思考', emoji: '🤔'),
    ],
  });

  /// 静态快捷方法：一键展示底部弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    UserRelationshipGoalItem? selectedItem,
    required Function(UserRelationshipGoalItem? item) onItemSelected,
    VoidCallback? onClose,
    List<UserRelationshipGoalItem>? items,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileRelationshipGoalSheet(
        selectedItem: selectedItem,
        onItemSelected: onItemSelected,
        onClose: onClose ?? () => Navigator.pop(context),
        items: items,
      ),
    );
  }

  getItems() {
    if (items != null) {
      return items!;
    }
    return [
      UserRelationshipGoalItem(id: 0, title: '寻找长期的伴侣', emoji: '💘'),
      UserRelationshipGoalItem(id: 1, title: '长期交往，但不拒绝短期交往', emoji: '😍'),
      UserRelationshipGoalItem(id: 2, title: '短期交往，但不拒绝长期交往', emoji: '🥂'),
      UserRelationshipGoalItem(id: 3, title: '享受短期交往的乐趣', emoji: '🎉'),
      UserRelationshipGoalItem(id: 4, title: '结交新朋友', emoji: '👋'),
      UserRelationshipGoalItem(id: 5, title: '我还在思考', emoji: '🤔'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部拖拽小横条
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 标题+关闭按钮区域
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '你想要查找什么？',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '你可以随时更改交往意向哦。每个人都可以在这里找到自己想要的人际交往。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              // 右上角关闭按钮
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 选项网格布局
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: getItems().length,
            itemBuilder: (context, i) {
              // ignore: unrelated_type_equality_checks
              final item = getItems()[i];
              final bool isSelected =
                  selectedItem != null && selectedItem!.id == item.id;
              return GestureDetector(
                onTap: () => onItemSelected(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    // 选中态红色边框，与截图完全一致
                    border: isSelected
                        ? Border.all(color: Colors.redAccent, width: 2)
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji图标
                      Text(item.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      // 选项文案
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // 底部安全区域适配
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
