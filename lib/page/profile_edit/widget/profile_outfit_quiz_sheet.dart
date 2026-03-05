import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder_app/data/app_data.dart';

/// 枚举：定义外出问答的各个步骤
enum OutfitQuizStep {
  action, // 你会做什么? (跳舞/社交)
  style, // 我喜欢... (盛装/随意)
  timing, // 我倾向于... (早一些/晚一会儿)
  departure, // 离场策略 (嘘--不要说/先说再见)
  result, // 最终结果展示
}

/// 选项数据模型
class QuizOption {
  final String id;
  final String title;
  final String? assetImage; // 可选：图标资源路径

  const QuizOption({required this.id, required this.title, this.assetImage});
}

/// 外出问答结果模型
class OutfitResult {
  final String action;
  final String style;
  final String timing;
  final String departure;

  const OutfitResult({
    required this.action,
    required this.style,
    required this.timing,
    required this.departure,
  });

  // 拼接成展示的文案
  String get combinedText => "$action,$style,$timing,$departure";
}

class ProfileOutfitQuizSheet extends StatefulWidget {
  final SheetOptionType optionType;

  /// 初始选中的结果（用于回显）
  final OutfitResult? initialResult;

  /// 完成回调，返回最终结果
  final Function(OutfitResult) onCompleted;

  /// 删除问答回调
  final VoidCallback? onDelete;

  const ProfileOutfitQuizSheet({
    super.key,
    required this.optionType,
    this.initialResult,
    required this.onCompleted,
    this.onDelete,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required SheetOptionType optionType,
    OutfitResult? initialResult,
    required Function(OutfitResult) onCompleted,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProfileOutfitQuizSheet(
        optionType: optionType,
        initialResult: initialResult,
        onCompleted: onCompleted,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<ProfileOutfitQuizSheet> createState() => _OutfitQuizSheetState();
}

class _OutfitQuizSheetState extends State<ProfileOutfitQuizSheet> {
  late OutfitQuizStep _currentStep;
  late Map<String, String> _selectedAnswers;
  late final List<QuizOption> _actionOptions;
  late final List<QuizOption> _styleOptions;
  late final List<QuizOption> _timingOptions;
  late final List<QuizOption> _departureOptions;

  @override
  void initState() {
    super.initState();
    // 初始化步骤
    _currentStep = widget.initialResult != null
        ? OutfitQuizStep.result
        : OutfitQuizStep.action;

    // 初始化数据
    _initData();
    _selectedAnswers = {};
    // 如果有初始结果，自动填充
    if (widget.initialResult != null) {
      print('初始结果：${widget.initialResult!.combinedText}'); // 调试输出
      _selectedAnswers = {
        'action': widget.initialResult!.action,
        'style': widget.initialResult!.style,
        'timing': widget.initialResult!.timing,
        'departure': widget.initialResult!.departure,
      };
    }
  }

  void _initData() {
    // 1. 动作选项
    if (widget.optionType == SheetOptionType.goOut) {
      _actionOptions = [
        const QuizOption(
          id: 'dancing',
          title: '正在跳舞',
          assetImage: 'assets/ic_dancing.png',
        ),
        const QuizOption(
          id: 'social',
          title: '正在社交',
          assetImage: 'assets/ic_social.png',
        ),
      ];
    } else if (widget.optionType == SheetOptionType.weekend) {
      _actionOptions = [
        const QuizOption(
          title: '充电',
          id: 'recharge',
          assetImage: 'assets/ic_dress.png',
        ),
        const QuizOption(
          title: '社交',
          id: 'social',
          assetImage: 'assets/ic_cap.png',
        ),
      ];
    } else if (widget.optionType == SheetOptionType.phoneUsage) {
      _actionOptions = [
        const QuizOption(
          title: '充电',
          id: 'recharge',
          assetImage: 'assets/ic_dress.png',
        ),
        const QuizOption(
          title: '社交',
          id: 'social',
          assetImage: 'assets/ic_cap.png',
        ),
      ];
    }

    // 2. 风格选项
    if (widget.optionType == SheetOptionType.goOut) {
      _styleOptions = [
        const QuizOption(
          id: 'glam',
          title: '盛装打扮',
          assetImage: 'assets/ic_dress.png',
        ),
        const QuizOption(
          id: 'casual',
          title: '随意打扮',
          assetImage: 'assets/ic_cap.png',
        ),
      ];
    } else if (widget.optionType == SheetOptionType.weekend) {
      _styleOptions = [
        const QuizOption(
          title: '舒服的待在家里',
          id: 'comfortable',
          assetImage: 'assets/ic_dress.png',
        ),
        const QuizOption(
          title: '夜晚外出嗨玩',
          id: 'night_out',
          assetImage: 'assets/ic_cap.png',
        ),
      ];
    } else if (widget.optionType == SheetOptionType.phoneUsage) {
      _styleOptions = [
        const QuizOption(
          title: '舒服的待在家里',
          id: 'comfortable',
          assetImage: 'assets/ic_dress.png',
        ),
        const QuizOption(
          title: '夜晚外出嗨玩',
          id: 'night_out',
          assetImage: 'assets/ic_cap.png',
        ),
      ];
    }

    // 3. 时间选项
    if (widget.optionType == SheetOptionType.goOut) {
      _timingOptions = [
        const QuizOption(id: 'early', title: '早一些'),
        const QuizOption(id: 'late', title: '故意迟一会儿'),
      ];
    } else if (widget.optionType == SheetOptionType.weekend) {
      _timingOptions = [
        const QuizOption(id: 'alone', title: '关起自己'),
        const QuizOption(id: 'fun', title: '玩个痛快'),
      ];
    } else if (widget.optionType == SheetOptionType.phoneUsage) {}

    // 4. 离场选项
    if (widget.optionType == SheetOptionType.goOut) {
      _departureOptions = [
        const QuizOption(id: 'shh', title: '嘘 -- 不要说'),
        const QuizOption(id: 'bye', title: '先说再见'),
      ];
    } else if (widget.optionType == SheetOptionType.weekend) {
      _departureOptions = [
        const QuizOption(id: 'shh', title: '嘘 -- 不要说'),
        const QuizOption(id: 'bye', title: '先说再见'),
      ];
    } else if (widget.optionType == SheetOptionType.phoneUsage) {
      _departureOptions = [
        const QuizOption(id: 'shh', title: '嘘 -- 不要说'),
        const QuizOption(id: 'bye', title: '先说再见'),
      ];
    }
  }

  /// 处理选项选择
  void _selectOption(String id, String title) {
    setState(() {
      _selectedAnswers[_currentStep.name] = title;

      // 根据当前步骤自动导航到下一步
      switch (_currentStep) {
        case OutfitQuizStep.action:
          _currentStep = OutfitQuizStep.style;
          break;
        case OutfitQuizStep.style:
          _currentStep = OutfitQuizStep.timing;
          break;
        case OutfitQuizStep.timing:
          _currentStep = OutfitQuizStep.departure;
          break;
        case OutfitQuizStep.departure:
          // _currentStep = OutfitQuizStep.result;
          // 结果页选中后直接回调
          _handleResult();
          break;
        case OutfitQuizStep.result:
          break;
      }
    });
  }

  /// 返回到上一步
  void _goBack() {
    setState(() {
      switch (_currentStep) {
        case OutfitQuizStep.action:
          Navigator.pop(context);
          break;
        case OutfitQuizStep.style:
          _currentStep = OutfitQuizStep.action;
          break;
        case OutfitQuizStep.timing:
          _currentStep = OutfitQuizStep.style;
          break;
        case OutfitQuizStep.departure:
          _currentStep = OutfitQuizStep.timing;
          break;
        case OutfitQuizStep.result:
          _currentStep = OutfitQuizStep.departure;
          break;
      }
    });
  }

  /// 处理结果确认
  void _handleResult() {
    final result = OutfitResult(
      action: _selectedAnswers['action'] ?? '',
      style: _selectedAnswers['style'] ?? '',
      timing: _selectedAnswers['timing'] ?? '',
      departure: _selectedAnswers['departure'] ?? '',
    );
    widget.onCompleted(result);
    // 延迟关闭，让用户看到结果
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  /// 根据ID获取选项标题
  String _getOptionTitle(List<QuizOption> options, String title) {
    return options
        .firstWhere(
          (o) => o.title == title,
          orElse: () => const QuizOption(id: '', title: ''),
        )
        .title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部关闭/返回按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep != OutfitQuizStep.action)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: _goBack,
                )
              else
                const SizedBox(width: 48), // 占位保持居中
              Text(
                '外出',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 根据不同步骤展示不同内容
          if (_currentStep == OutfitQuizStep.result)
            _buildResultPage()
          else
            _buildQuestionPage(),
        ],
      ),
    );
  }

  /// 构建问题页面（双列选项）
  Widget _buildQuestionPage() {
    List<QuizOption> currentOptions = [];
    String questionText = '';

    switch (_currentStep) {
      case OutfitQuizStep.action:
        currentOptions = _actionOptions;
        questionText = '你会发现我...';
        break;
      case OutfitQuizStep.style:
        currentOptions = _styleOptions;
        questionText = '我喜欢...';
        break;
      case OutfitQuizStep.timing:
        currentOptions = _timingOptions;
        questionText = '我倾向于到得...';
        break;
      case OutfitQuizStep.departure:
        currentOptions = _departureOptions;
        questionText = '我的离场策略是...';
        break;
      default:
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 30),

        // 双列选项布局
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: currentOptions.map((option) {
            // 调试输出
            return GestureDetector(
              onTap: () => _selectOption(option.id, option.title),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (option.assetImage != null)
                      Image.asset(option.assetImage!, width: 48, height: 48),
                    if (option.assetImage != null) const SizedBox(height: 8),
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  /// 构建结果页面
  Widget _buildResultPage() {
    final String actionText = _getOptionTitle(
      _actionOptions,
      _selectedAnswers['action'] ?? '',
    );
    final String styleText = _getOptionTitle(
      _styleOptions,
      _selectedAnswers['style'] ?? '',
    );
    final String timingText = _getOptionTitle(
      _timingOptions,
      _selectedAnswers['timing'] ?? '',
    );
    final String departureText = _getOptionTitle(
      _departureOptions,
      _selectedAnswers['departure'] ?? '',
    );

    return Column(
      children: [
        const Text(
          '你的结果是...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                actionText,
                style: const TextStyle(fontSize: 16, height: 1.8),
              ),
              Text(
                styleText,
                style: const TextStyle(fontSize: 16, height: 1.8),
              ),
              Text(
                timingText,
                style: const TextStyle(fontSize: 16, height: 1.8),
              ),
              Text(
                departureText,
                style: const TextStyle(fontSize: 16, height: 1.8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // 重做问答 & 删除问答 按钮
        if (widget.onDelete != null)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 重置状态，回到第一步
                    setState(() {
                      _currentStep = OutfitQuizStep.action;
                      _selectedAnswers.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('重做问答'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
                    _selectedAnswers.clear();
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('删除问答'),
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
