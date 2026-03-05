/// 通用选项选择弹窗
import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';

class UniversalOptionSheet extends StatefulWidget {
  final SheetOptionType type;
  final String? initialSelectedId;
  final Function(OptionItem selectedItem) onCompleted;
  final VoidCallback? onClose;

  const UniversalOptionSheet({
    super.key,
    required this.type,
    this.initialSelectedId,
    required this.onCompleted,
    this.onClose,
  });

  /// 简化的静态调用方法（只需传枚举值）
  static Future<T?> show<T>(
    BuildContext context, {
    required SheetOptionType type,
    String? initialSelectedId,
    required Function(OptionItem selectedItem) onCompleted,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UniversalOptionSheet(
        type: type,
        initialSelectedId: initialSelectedId,
        onCompleted: onCompleted,
        onClose: onClose ?? () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<UniversalOptionSheet> createState() => _UniversalOptionSheetState();
}

class _UniversalOptionSheetState extends State<UniversalOptionSheet> {
  late OptionConfig _config;
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    // 根据枚举值获取配置
    _config = OptionDataManager.getConfig(widget.type);
    _selectedId = widget.initialSelectedId;
  }

  /// 切换选中状态
  void _toggleSelect(OptionItem item) {
    setState(() {
      _selectedId = item.id;
    });
  }

  /// 完成按钮点击
  void _handleComplete() {
    if (_selectedId == null) return;
    final selectedItem = _config.options.firstWhere(
      (item) => item.id == _selectedId,
    );
    widget.onCompleted(selectedItem);
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
          // 顶部拖拽条
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
          const SizedBox(height: 24),
          // 标题 + 完成按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _config.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton(
                onPressed: _handleComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  minimumSize: const Size(60, 32),
                ),
                child: const Text(
                  '完成',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 提示文案
          Text(
            _config.hintText,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          // 问题行
          Text(
            _config.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // 选项列表
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _config.options.map((item) {
              final isSelected = _selectedId == item.id;
              return GestureDetector(
                onTap: () => _toggleSelect(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.redAccent : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.redAccent : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // 底部安全区适配
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
