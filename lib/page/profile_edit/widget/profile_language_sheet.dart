import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// 个人资料 - 我会的语言选择弹窗
class ProfileLanguageSheet extends StatefulWidget {
  /// 初始已选中的用户语言列表（用于回显）
  final List<UserLanguage>? selectedLanguage;

  /// 完成按钮回调，返回选中的 UserLanguage 模型数组
  final Function(List<UserLanguage> selectedLanguages) onCompleted;

  /// 弹窗关闭回调
  final VoidCallback? onClose;

  /// 可选的自定义语言列表（基础 UserLanguage 类型）
  final List<UserLanguage>? languages;

  const ProfileLanguageSheet({
    super.key,
    this.selectedLanguage = const [],
    required this.onCompleted,
    this.onClose,
    this.languages,
  });

  /// 静态快捷方法：一键展示底部弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    List<UserLanguage>? selectedLanguage = const [],
    required Function(List<UserLanguage> selectedLanguages) onCompleted,
    VoidCallback? onClose,
    List<UserLanguage>? languages,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileLanguageSheet(
        selectedLanguage: selectedLanguage,
        onCompleted: onCompleted,
        onClose: onClose ?? () => Navigator.pop(context),
        languages: languages ?? const [],
      ),
    );
  }

  @override
  State<ProfileLanguageSheet> createState() => _ProfileLanguageSheetState();
}

class _ProfileLanguageSheetState extends State<ProfileLanguageSheet> {
  late List<String> _selectedIds; // 存储选中的语言ID（用于判断选中状态）
  late List<UserLanguage> _allLanguages;
  late List<UserLanguage> _filteredLanguages;
  final TextEditingController _searchController = TextEditingController();
  bool isMax = false;
  getAllLanguages() {
    if (widget.languages != null && widget.languages!.isNotEmpty) {
      return widget.languages!;
    }
    return const [
      UserLanguage(id: 'afrikaans', name: '南非语'),
      UserLanguage(id: 'albanian', name: '阿尔巴尼亚语'),
      UserLanguage(id: 'amharic', name: '阿姆哈拉语'),
      UserLanguage(id: 'arabic', name: '阿拉伯语'),
      UserLanguage(id: 'armenian', name: '亚美尼亚语'),
      UserLanguage(id: 'american_sign_language', name: '美国手语'),
      UserLanguage(id: 'assamese', name: '阿萨姆语'),
      UserLanguage(id: 'aymara', name: '艾马拉语'),
      UserLanguage(id: 'azerbaijani', name: '阿塞拜疆语'),
      UserLanguage(id: 'bambara', name: '班巴拉语'),
      UserLanguage(id: 'basque', name: '巴斯克语'),
      UserLanguage(id: 'belarusian', name: '白俄罗斯语'),
      UserLanguage(id: 'bengali', name: '孟加拉语'),
      UserLanguage(id: 'bhojpuri', name: '比哈尔语'),
      UserLanguage(id: 'bosnian', name: '波斯尼亚语'),
      UserLanguage(id: 'bulgarian', name: '保加利亚语'),
      UserLanguage(id: 'burmese', name: '缅甸语'),
      UserLanguage(id: 'cantonese', name: '粤语'),
      UserLanguage(id: 'catalan', name: '加泰罗尼亚语'),
      UserLanguage(id: 'cebuano', name: '宿雾语'),
      UserLanguage(id: 'quechua', name: '齐切瓦语'),
      UserLanguage(id: 'corsican', name: '科西嘉语'),
      UserLanguage(id: 'croatian', name: '克罗地亚语'),
      UserLanguage(id: 'czech', name: '捷克语'),
      UserLanguage(id: 'danish', name: '丹麦语'),
      UserLanguage(id: 'divi', name: '迪维希语'),
      UserLanguage(id: 'dogri', name: '多格拉语'),
      UserLanguage(id: 'dutch', name: '荷兰语'),
      UserLanguage(id: 'english', name: '英语'),
      UserLanguage(id: 'esperanto', name: '世界语'),
      UserLanguage(id: 'estonian', name: '爱沙尼亚语'),
      UserLanguage(id: 'ewe', name: '埃维语'),
      UserLanguage(id: 'filipino', name: '菲律宾语'),
      UserLanguage(id: 'finnish', name: '芬兰语'),
      UserLanguage(id: 'french', name: '法语'),
      UserLanguage(id: 'frisian', name: '弗里西亚语'),
      UserLanguage(id: 'galician', name: '加利西亚语'),
      UserLanguage(id: 'georgian', name: '格鲁吉亚语'),
      UserLanguage(id: 'german', name: '德语'),
      UserLanguage(id: 'greek', name: '希腊语'),
      UserLanguage(id: 'guarani', name: '瓜拉尼语'),
      UserLanguage(id: 'gujarati', name: '古吉拉特语'),
      UserLanguage(id: 'haitian_creole', name: '海地克里奥尔语'),
      UserLanguage(id: 'hausa', name: '豪萨语'),
      UserLanguage(id: 'hawaiian', name: '夏威夷语'),
      UserLanguage(id: 'hebrew', name: '希伯来语'),
      UserLanguage(id: 'hindi', name: '印地语'),
      UserLanguage(id: 'hmong', name: '苗语'),
      UserLanguage(id: 'hungarian', name: '匈牙利语'),
      UserLanguage(id: 'icelandic', name: '冰岛语'),
      UserLanguage(id: 'igbo', name: '伊博语'),
      UserLanguage(id: 'ilocano', name: '伊洛卡诺语'),
      UserLanguage(id: 'indonesian', name: '印度尼西亚语'),
      UserLanguage(id: 'irish', name: '爱尔兰语'),
      UserLanguage(id: 'italian', name: '意大利语'),
      UserLanguage(id: 'japanese', name: '日语'),
      UserLanguage(id: 'javanese', name: '爪哇语'),
      UserLanguage(id: 'kannada', name: '坎那达语'),
      UserLanguage(id: 'kazakh', name: '哈萨克语'),
      UserLanguage(id: 'khmer', name: '高棉语'),
    ];
  }

  @override
  void initState() {
    super.initState();
    // 从传入的 selectedLanguage 中提取ID，用于回显选中状态
    _selectedIds =
        widget.selectedLanguage?.map((lang) => lang.id).toList() ?? [];
    _allLanguages = getAllLanguages();
    _filteredLanguages = _allLanguages;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 切换语言选中状态
  void _toggleLanguage(UserLanguage language) {
    if (_selectedIds.contains(language.id)) {
      if (isMax) {
        setState(() {
          isMax = false;
        });
      }
      // 取消选中
      setState(() {
        _selectedIds.remove(language.id);
      });
    } else {
      // 限制最多选5种
      if (_selectedIds.length >= 5) {
        setState(() {
          isMax = true;
        });
        return;
      } else {
        setState(() {
          isMax = false;
        });
      }
      // 选中语言
      setState(() {
        _selectedIds.add(language.id);
      });
    }
  }

  /// 搜索过滤语言列表
  void _filterLanguages(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _filteredLanguages = _allLanguages;
      });
      return;
    }
    final lowerKeyword = keyword.toLowerCase();
    setState(() {
      _filteredLanguages = _allLanguages
          .where((lang) => lang.name.toLowerCase().contains(lowerKeyword))
          .toList();
    });
  }

  /// 完成按钮点击 - 转换为 UserLanguage 回调
  void _handleComplete() {
    // 筛选出选中的基础 UserLanguage 模型
    final selectedBaseLanguages = _allLanguages
        .where((lang) => _selectedIds.contains(lang.id))
        .toList();
    // 转换为 UserLanguage 模型（适配你的业务类型）
    final selectedUserLanguages = selectedBaseLanguages
        .map((lang) => UserLanguage(id: lang.id, name: lang.name))
        .toList();
    // 回调返回 UserLanguage 数组
    widget.onCompleted(selectedUserLanguages);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 计算选中数量（用于回显计数）
    final selectedCount = _selectedIds.length;

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
              const Text(
                '我会的语言',
                style: TextStyle(
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
          // 提示文案 + 选中计数回显
          Text(
            '请至多选择 5 种你会的语言并添加到你的个人资料中',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$selectedCount/5',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isMax == true) const SizedBox(width: 4),
              if (isMax == true)
                Text(
                  '（最多选择5种语言）',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // 搜索框
          TextField(
            controller: _searchController,
            onChanged: _filterLanguages,
            decoration: InputDecoration(
              hintText: '搜索语言',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 语言列表（可滑动 + 选中状态回显）
          SizedBox(
            height: 300, // 固定列表高度，保证滑动
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filteredLanguages.map((lang) {
                  // 关键：判断当前语言是否在选中列表中（回显核心逻辑）
                  final isSelected = _selectedIds.contains(lang.id);
                  return GestureDetector(
                    onTap: () => _toggleLanguage(lang),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.redAccent
                              : Colors.grey[300]!,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        lang.name,
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
            ),
          ),
          // 底部安全区适配
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
