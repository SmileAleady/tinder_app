// 性别选择页面
import 'package:flutter/material.dart';
import 'package:tinder_app/data/app_data.dart';
import 'package:tinder_app/model/user_profile_model.dart';

class ProfileGenderSelectionPage extends StatefulWidget {
  // 初始选中的性别列表（用于回显）
  final List<GenderModel>? initialSelectedGenders;
  // 确认选择后的回调（返回选中的性别模型数组）
  final Function(List<GenderModel>) onConfirm;

  const ProfileGenderSelectionPage({
    super.key,
    this.initialSelectedGenders,
    required this.onConfirm,
  });

  @override
  State<ProfileGenderSelectionPage> createState() =>
      _ProfileGenderSelectionPageState();
}

class _ProfileGenderSelectionPageState
    extends State<ProfileGenderSelectionPage> {
  late List<GenderModel> _genderList; // 所有性别选项
  late Set<String> _selectedGenderIds; // 存储选中的性别ID（替代isSelected）

  @override
  void initState() {
    super.initState();
    // 初始化性别选项（与参考图一致）
    _genderList = OptionDataManager.genders;

    // 初始化选中ID集合
    _selectedGenderIds = <String>{};

    // 回显逻辑：从初始选中列表中提取ID，加入选中集合
    if (widget.initialSelectedGenders?.isNotEmpty == true) {
      for (var gender in widget.initialSelectedGenders!) {
        _selectedGenderIds.add(gender.id);
        // 回显可见性设置
        final index = _genderList.indexWhere((g) => g.id == gender.id);
        if (index != -1) {
          _genderList[index] = _genderList[index].copyWith(
            isVisible: gender.isVisible,
          );
        }
      }
    }
  }

  // 切换性别选中状态（通过ID判断/更新）
  void _toggleGenderSelection(String genderId) {
    setState(() {
      if (_selectedGenderIds.contains(genderId)) {
        _selectedGenderIds.remove(genderId); // 取消选中
      } else {
        _selectedGenderIds.add(genderId); // 选中
      }
    });
  }

  // 判断某个性别是否被选中（通过ID）
  bool _isGenderSelected(String genderId) {
    return _selectedGenderIds.contains(genderId);
  }

  // 确认选择并返回结果
  void _confirmSelection() {
    // 根据选中的ID过滤出对应的性别模型数组
    final selectedGenders = _genderList
        .where((g) => _selectedGenderIds.contains(g.id))
        .toList();
    // 执行回调，返回选中的数组
    widget.onConfirm(selectedGenders);
    // 关闭当前页面
    Navigator.pop(context);
  }

  // 弹出编辑可见状态的弹窗（修复核心逻辑）
  void _showVisibilityEditDialog() {
    // 获取当前已选中的性别（创建副本用于弹窗内操作）
    List<GenderModel> tempSelectedGenders = _genderList
        .where((g) => _selectedGenderIds.contains(g.id))
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

                  // 可见性选项（已选中的性别）- 修复选中状态更新逻辑
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: tempSelectedGenders.map((gender) {
                      return FilterChip(
                        label: Text(gender.name),
                        // 直接使用临时列表中的isVisible状态
                        selected: gender.isVisible,
                        onSelected: (isSelected) {
                          setModalState(() {
                            // 1. 更新临时列表中的可见性状态
                            final index = tempSelectedGenders.indexWhere(
                              (g) => g.id == gender.id,
                            );
                            if (index != -1) {
                              tempSelectedGenders[index] =
                                  tempSelectedGenders[index].copyWith(
                                    isVisible: isSelected,
                                  );
                            }

                            // 2. 同步更新主页面的genderList状态
                            final mainIndex = _genderList.indexWhere(
                              (g) => g.id == gender.id,
                            );
                            if (mainIndex != -1) {
                              _genderList[mainIndex] = _genderList[mainIndex]
                                  .copyWith(isVisible: isSelected);
                            }
                          });
                        },
                        selectedColor: Colors.pink,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: gender.isVisible ? Colors.white : Colors.black,
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
          '我的性别',
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
              '请选择所有适用选项，确保目标用户更容易看到你的个人资料。你当然也可以添加更多信息。',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 性别选项列表
            Expanded(
              child: ListView.builder(
                itemCount: _genderList.length,
                itemBuilder: (context, index) {
                  final gender = _genderList[index];
                  final isSelected = _isGenderSelected(gender.id); // 通过ID判断选中状态

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _toggleGenderSelection(gender.id), // 传递ID切换状态
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                gender.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.pink
                                      : Colors.black,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.pink),
                            ],
                          ),
                        ),
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '请添加有关你的性别的更多信息（可选项）',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // 可见性提示
            const Center(
              child: Text(
                '你的性别在个人资料中可见。',
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
