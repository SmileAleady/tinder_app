import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// 个人资料-身高编辑底部弹窗
class ProfileHeightEditSheet extends StatefulWidget {
  /// 初始选中的单位
  final HeightUnit? initialUnit;

  /// 初始厘米值（cm模式下）
  final double? initialCm;

  /// 初始英尺值（英尺/英寸模式下）
  final int? initialFeet;

  /// 初始英寸值（英尺/英寸模式下）
  final int? initialInch;

  /// 完成按钮点击回调，返回选中的单位、对应数值
  /// cm模式：返回cm值，feet和inch为null
  /// 英尺/英寸模式：返回feet和inch值，cm为null
  final Function(UserHeightModel? model) onCompleted;

  /// 删除身高按钮点击回调
  final VoidCallback? onDelete;

  /// 弹窗关闭回调
  final VoidCallback? onClose;

  const ProfileHeightEditSheet({
    super.key,
    this.initialUnit = HeightUnit.cm,
    this.initialCm,
    this.initialFeet,
    this.initialInch,
    required this.onCompleted,
    this.onDelete,
    this.onClose,
  });

  /// 静态快捷方法：一键展示底部弹窗
  static Future<T?> show<T>(
    BuildContext context, {
    HeightUnit? initialUnit = HeightUnit.cm,
    double? initialCm,
    int? initialFeet,
    int? initialInch,
    required Function(UserHeightModel? model) onCompleted,
    VoidCallback? onDelete,
    VoidCallback? onClose,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileHeightEditSheet(
        initialUnit: initialUnit,
        initialCm: initialCm,
        initialFeet: initialFeet,
        initialInch: initialInch,
        onCompleted: onCompleted,
        onDelete: onDelete,
        onClose: onClose ?? () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<ProfileHeightEditSheet> createState() => _ProfileHeightEditSheetState();
}

class _ProfileHeightEditSheetState extends State<ProfileHeightEditSheet> {
  late HeightUnit _selectedUnit;
  late final TextEditingController _feetController;
  late final TextEditingController _inchController;
  late final TextEditingController _cmController;

  @override
  void initState() {
    super.initState();
    // 初始化选中单位
    _selectedUnit = widget?.initialUnit ?? HeightUnit.cm;
    // 初始化输入控制器&初始值
    _feetController = TextEditingController(
      text: widget.initialFeet?.toString() ?? '',
    );
    _inchController = TextEditingController(
      text: widget.initialInch?.toString() ?? '',
    );
    _cmController = TextEditingController(
      text: widget.initialCm?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchController.dispose();
    _cmController.dispose();
    super.dispose();
  }

  /// 完成按钮点击处理
  void _handleComplete() {
    if (_selectedUnit == HeightUnit.cm) {
      final cmValue = double.tryParse(_cmController.text.trim());
      UserHeightModel model = UserHeightModel(
        unit: _selectedUnit,
        cm: cmValue,
        feet: null,
        inch: null,
      );
      widget.onCompleted(model);
    } else {
      final feetValue = int.tryParse(_feetController.text.trim());
      final inchValue = int.tryParse(_inchController.text.trim());
      UserHeightModel model = UserHeightModel(
        unit: _selectedUnit,
        cm: null,
        feet: feetValue,
        inch: inchValue,
      );
      widget.onCompleted(model);
    }
    Navigator.pop(context);
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
          const SizedBox(height: 24),
          // 标题+完成按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '身高',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // 完成按钮
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
            '现在你可以在个人资料中添加身高哦。',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // 输入区域-单位切换展示
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _selectedUnit == HeightUnit.feetInch
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _buildFeetInchInput(),
            secondChild: _buildCmInput(),
          ),
          const SizedBox(height: 24),
          // 分割线
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 16),
          // 单位切换区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '身高单位',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // 单位切换分段按钮
              _buildUnitSegment(),
            ],
          ),
          const SizedBox(height: 16),
          // 分割线
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 32),
          // 删除身高按钮
          Center(
            child: OutlinedButton(
              onPressed: () {
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                '删除身高',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // 底部安全区域适配
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }

  /// 构建英尺/英寸双输入框
  Widget _buildFeetInchInput() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '英尺',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _feetController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '英寸',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _inchController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建厘米单输入框
  Widget _buildCmInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '厘米',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _cmController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// 构建单位切换分段按钮
  Widget _buildUnitSegment() {
    return SegmentedButton<HeightUnit>(
      segments: const [
        ButtonSegment(value: HeightUnit.feetInch, label: Text('英尺/英寸')),
        ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
      ],
      selected: {_selectedUnit},
      onSelectionChanged: (Set<HeightUnit> newSelection) {
        setState(() {
          _selectedUnit = newSelection.first;
        });
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.white,
        selectedBackgroundColor: Colors.grey[800],
        selectedForegroundColor: Colors.white,
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
