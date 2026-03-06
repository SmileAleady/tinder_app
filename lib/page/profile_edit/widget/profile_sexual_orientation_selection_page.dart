// 性向选择页面
import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/model/user_profile_model.dart';

class ProfileSexualOrientationSelectionPage extends StatefulWidget {
  // 初始选中的性向列表（用于回显）
  final List<SexualOrientationModel>? initialSelectedOrientations;
  // 确认选择后的回调（返回选中的性向模型数组）
  final Function(List<SexualOrientationModel>) onConfirm;

  const ProfileSexualOrientationSelectionPage({
    super.key,
    this.initialSelectedOrientations,
    required this.onConfirm,
  });

  @override
  State<ProfileSexualOrientationSelectionPage> createState() =>
      _ProfileSexualOrientationSelectionPageState();
}

class _ProfileSexualOrientationSelectionPageState
    extends State<ProfileSexualOrientationSelectionPage> {
  late List<SexualOrientationModel> _orientationList; // 所有性向选项
  late Set<String> _selectedOrientationIds; // 存储选中的性向ID

  @override
  void initState() {
    super.initState();
    // 初始化性向选项（与截图一致）
    _orientationList = OptionDataManager.sexualOrientations;

    // 初始化选中ID集合
    _selectedOrientationIds = <String>{};

    // 回显逻辑：从初始选中列表中提取ID和可见性状态
    if (widget.initialSelectedOrientations?.isNotEmpty == true) {
      for (var orientation in widget.initialSelectedOrientations!) {
        _selectedOrientationIds.add(orientation.id);
        // 回显可见性设置
        final index = _orientationList.indexWhere(
          (o) => o.id == orientation.id,
        );
        if (index != -1) {
          _orientationList[index] = _orientationList[index].copyWith(
            isVisible: orientation.isVisible,
          );
        }
      }
    }
  }

  // 切换性向选中状态（通过ID判断/更新）
  void _toggleOrientationSelection(String orientationId) {
    setState(() {
      if (_selectedOrientationIds.contains(orientationId)) {
        _selectedOrientationIds.remove(orientationId); // 取消选中
      } else {
        _selectedOrientationIds.add(orientationId); // 选中
      }
    });
  }

  // 判断某个性向是否被选中（通过ID）
  bool _isOrientationSelected(String orientationId) {
    return _selectedOrientationIds.contains(orientationId);
  }

  // 确认选择并返回结果
  void _confirmSelection() {
    // 根据选中的ID过滤出对应的性向模型数组
    final selectedOrientations = _orientationList
        .where((o) => _selectedOrientationIds.contains(o.id))
        .toList();
    // 执行回调，返回选中的数组
    widget.onConfirm(selectedOrientations);
    // 关闭当前页面
    Navigator.pop(context);
  }

  // 弹出编辑可见状态的弹窗
  void _showVisibilityEditDialog() {
    // 获取当前已选中的性向（创建副本用于弹窗内操作）
    List<SexualOrientationModel> tempSelectedOrientations = _orientationList
        .where((o) => _selectedOrientationIds.contains(o.id))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 弹窗标题
                  const Text(
                    '你想在个人资料上如何显示？',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '你选择不显示的选项仍然会被用于向其他用户推荐你。',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // 可见性选项（已选中的性向）
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: tempSelectedOrientations.map((orientation) {
                      return FilterChip(
                        label: Text(orientation.name),
                        selected: orientation.isVisible,
                        onSelected: (isSelected) {
                          setModalState(() {
                            // 1. 更新临时列表中的可见性状态
                            final index = tempSelectedOrientations.indexWhere(
                              (o) => o.id == orientation.id,
                            );
                            if (index != -1) {
                              tempSelectedOrientations[index] =
                                  tempSelectedOrientations[index].copyWith(
                                    isVisible: isSelected,
                                  );
                            }

                            // 2. 同步更新主页面的orientationList状态
                            final mainIndex = _orientationList.indexWhere(
                              (o) => o.id == orientation.id,
                            );
                            if (mainIndex != -1) {
                              _orientationList[mainIndex] =
                                  _orientationList[mainIndex].copyWith(
                                    isVisible: isSelected,
                                  );
                            }
                          });
                        },
                        selectedColor: Colors.pink,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: orientation.isVisible
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 安全约会提示
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shield, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              '安全约会',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '你的安全至关重要。请始终将自身的安全放在第一位，并仅在确保安全的情况下才分享你的性别和性向信息。',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 完成按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 关闭弹窗
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '完成',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context), // 关闭页面（不回调）
        ),
        title: const Text(
          '我的性向',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _confirmSelection,
            child: const Text(
              '完成',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文本
            const Text(
              '请选择所有适用选项，描述你的身份认同。',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // 性向选项列表
            Expanded(
              child: ListView.builder(
                itemCount: _orientationList.length,
                itemBuilder: (context, index) {
                  final orientation = _orientationList[index];
                  final isSelected = _isOrientationSelected(
                    orientation.id,
                  ); // 通过ID判断选中状态

                  return GestureDetector(
                    onTap: () =>
                        _toggleOrientationSelection(orientation.id), // 传递ID切换状态
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Colors.pink
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 性向名称
                          Text(
                            orientation.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.pink : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 性向描述
                          Text(
                            orientation.desc,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.pink
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 可见性提示
            const Center(
              child: Text(
                '你的性向在个人资料中已隐藏。',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // 编辑可见状态按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showVisibilityEditDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '编辑可见状态',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
