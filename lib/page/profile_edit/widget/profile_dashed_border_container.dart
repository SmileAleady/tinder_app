import 'dart:ui';

import 'package:flutter/material.dart';

/// 可自定义的虚线边框容器
class ProfileDashedBorderContainer extends StatelessWidget {
  /// 容器宽度
  final double? width;

  /// 容器高度
  final double? height;

  /// 圆角大小
  final double borderRadius;

  /// 边框颜色
  final Color borderColor;

  /// 边框粗细
  final double borderWidth;

  /// 虚线每段的长度
  final double dashWidth;

  /// 虚线之间的间隔
  final double dashSpace;

  /// 子组件
  final Widget? child;

  /// 内边距
  final EdgeInsetsGeometry padding;

  const ProfileDashedBorderContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.child,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width ?? double.infinity, height ?? double.infinity),
      painter: DashedBorderPainter(
        borderRadius: borderRadius,
        borderColor: borderColor,
        borderWidth: borderWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

/// 虚线边框绘制器（支持圆角）
class DashedBorderPainter extends CustomPainter {
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 配置画笔
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 计算绘制区域（留出边框宽度，避免边框被裁切）
    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    // 创建带圆角的路径
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    // 生成虚线路径
    final dashedPath = _createDashedPath(
      path,
      dashWidth: dashWidth,
      dashSpace: dashSpace,
    );

    // 绘制虚线边框
    canvas.drawPath(dashedPath, paint);
  }

  /// 生成虚线路径
  Path _createDashedPath(
    Path path, {
    required double dashWidth,
    required double dashSpace,
  }) {
    final Path dashedPath = Path();
    final List<PathMetric> metrics = path.computeMetrics().toList();

    for (final PathMetric metric in metrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + dashWidth),
            Offset.zero,
          );
        }
        distance += dashWidth + dashSpace;
        draw = !draw;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
