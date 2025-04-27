import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Represents a single day leaf state
class DayData {
  final bool visited;
  DayData({required this.visited});
}

/// Represents a week branch containing a list of days
class WeekData {
  final List<DayData> days;
  WeekData({required this.days});
}

class BonsaiTree extends StatelessWidget {
  final List<WeekData> weeks;
  final double branchLengthFactor;
  final double leafBranchLengthFactor;
  final double leafStemLengthFactor;
  final double leafSizeFactor;

  const BonsaiTree({
    Key? key,
    required this.weeks,
    this.branchLengthFactor = 0.3,
    this.leafBranchLengthFactor = 0.4,
    this.leafStemLengthFactor = 0.5,
    this.leafSizeFactor = 0.03,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          size: size,
          painter: BonsaiTreePainter(
            weeks,
            branchLengthFactor,
            leafBranchLengthFactor,
            leafStemLengthFactor,
            leafSizeFactor,
          ),
        );
      },
    );
  }
}

class BonsaiTreePainter extends CustomPainter {
  final List<WeekData> weeks;
  final double branchLengthFactor;
  final double leafBranchLengthFactor;
  final double leafStemLengthFactor;
  final double leafSizeFactor;

  BonsaiTreePainter(
    this.weeks,
    this.branchLengthFactor,
    this.leafBranchLengthFactor,
    this.leafStemLengthFactor,
    this.leafSizeFactor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final potHeight = size.height * 0.1;
    final potWidth = size.width * 0.6;
    final potPaint = Paint()..color = Colors.brown.shade700;

    // Trunk paint
    final trunkPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    // Define S-curve trunk path
    final startPoint = Offset(size.width / 2, size.height - potHeight);
    final control1 = Offset(size.width * 0.2, size.height * 0.7);
    final control2 = Offset(size.width * 0.8, size.height * 0.5);
    final endPoint = Offset(size.width / 2, size.height * 0.35);
    final trunkPath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, endPoint.dx, endPoint.dy);
    // Draw tapered trunk by sampling path segments with varying stroke widths
    final trunkBaseWidth = size.width * 0.09;
    final trunkTipWidth = size.width * 0.04;
    final metrics = trunkPath.computeMetrics();
    for (final metric in metrics) {
      final totalLen = metric.length;
      const segments = 10;
      for (var s = 0; s < segments; s++) {
        final t1 = s / segments;
        final t2 = (s + 1) / segments;
        final start = metric.getTangentForOffset(totalLen * t1)!.position;
        final end = metric.getTangentForOffset(totalLen * t2)!.position;
        final width = trunkBaseWidth + (trunkTipWidth - trunkBaseWidth) * t1;
        final segmentPaint = Paint()
          ..color = Colors.brown
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, end, segmentPaint);
      }
    }

    // Branch parameters
    final centerX = size.width / 2;
    final branchLen = size.width * branchLengthFactor;
    final branchPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round;
    final leafPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    final leafBranchPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = branchPaint.strokeWidth * 0.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < weeks.length; i++) {
      // Compute branch endpoints
      Offset bStart, bEnd;
      if (i == 0) {
        // top branch: very short stub from trunk
        final smallLen = branchLen * 0.00;
        bStart = Offset(endPoint.dx, endPoint.dy);
        bEnd = Offset(endPoint.dx, endPoint.dy);
      } else if (i == 1) {
        final y = size.height * 0.5;
        bStart = Offset(centerX + size.width * 0.052, y);
        bEnd = Offset(centerX - branchLen, y + branchLen * 0.12);
      } else if (i == 2) {
        final y = size.height * 0.65;
        bStart = Offset(centerX - size.width * 0.036, y);
        bEnd = Offset(centerX - branchLen, y + branchLen * 0.4);
      } else {
        final y = size.height * 0.59;
        bStart = Offset(centerX + size.width * 0.016, y);
        bEnd = Offset(centerX + branchLen, y + branchLen * 0.2);
      }

      // Draw curved U-shaped branch
      final branchAngleForCurve = (bEnd - bStart).direction;
      final mid = Offset((bStart.dx + bEnd.dx) / 2, (bStart.dy + bEnd.dy) / 2);
      final perpAngleForBranch = (i == 1 || i == 2)
          ? branchAngleForCurve + math.pi / 2
          : branchAngleForCurve - math.pi / 2;
      final controlDist = branchLen * 0.3;
      // Flip curvature direction for U shape by negating offset
      final controlPoint = mid - Offset(math.cos(perpAngleForBranch), math.sin(perpAngleForBranch)) * controlDist;
      final branchPath = Path()
        ..moveTo(bStart.dx, bStart.dy)
        ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, bEnd.dx, bEnd.dy);
      // Draw tapered branch: thick at base, thin at tip
      final branchBaseWidth = branchPaint.strokeWidth * 1.4;
      final branchTipWidth = branchPaint.strokeWidth * 0.8;
      for (final metric in branchPath.computeMetrics()) {
        final totalLen = metric.length;
        const segments = 6;
        for (var s = 0; s < segments; s++) {
          final t1 = s / segments;
          final t2 = (s + 1) / segments;
          final p1 = metric.getTangentForOffset(totalLen * t1)!.position;
          final p2 = metric.getTangentForOffset(totalLen * t2)!.position;
          final width = branchBaseWidth + (branchTipWidth - branchBaseWidth) * t1;
          final segmentPaint = Paint()
            ..color = branchPaint.color
            ..style = branchPaint.style
            ..strokeWidth = width
            ..strokeCap = branchPaint.strokeCap;
          canvas.drawLine(p1, p2, segmentPaint);
        }
      }

      // Draw umbrella-shaped leaf puff at branch end
      final days = weeks[i].days;
      final count = days.length;
      final branchAngle = (bEnd - bStart).direction;
      // Choose side for leaf puff: left branches fan with +90°, top and right use -90°
      final perpAngle = (i == 1 || i == 2)
          ? branchAngle + math.pi / 2
          : branchAngle - math.pi / 2;
      final fanSpan = math.pi * 2 / 3; // 120deg spread
      final puffRadius = size.width * leafBranchLengthFactor;
      final stemLength = puffRadius * leafStemLengthFactor;
      final step = count > 1 ? fanSpan / (count - 1) : 0.0;
      final startAngle = perpAngle - fanSpan / 2;
      for (var j = 0; j < count; j++) {
        // only draw for visited days
        if (days[j].visited) {
          final leafAngle = startAngle + step * j;
          final pos = bEnd + Offset(math.cos(leafAngle), math.sin(leafAngle)) * stemLength;
          canvas.drawLine(bEnd, pos, leafBranchPaint);
          // draw leaf with size based on leafSizeFactor
          final leafRadius = size.width * leafSizeFactor;
          canvas.drawCircle(pos, leafRadius, leafPaint);
        }
      }
      
        // Draw pot at bottom

    final potRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height - potHeight / 2),
      width: potWidth,
      height: potHeight,
    );
    canvas.drawRect(potRect, potPaint);
    }

  }

  @override
  bool shouldRepaint(covariant BonsaiTreePainter old) =>
      old.weeks != weeks ||
      old.branchLengthFactor != branchLengthFactor ||
      old.leafBranchLengthFactor != leafBranchLengthFactor ||
      old.leafStemLengthFactor != leafStemLengthFactor ||
      old.leafSizeFactor != leafSizeFactor;
}