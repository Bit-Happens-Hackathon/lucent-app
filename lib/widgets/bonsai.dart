import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';

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

/// Helper: build weeks of DayData from list of timestamps
List<WeekData> generateWeekData(List<DateTime> visits, {required int year, required int month}) {
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final visitedSet = visits
      .where((dt) => dt.year == year && dt.month == month)
      .map((dt) => dt.day)
      .toSet();
  // First 28 days broken into 4 equal chunks of 7; any extra days (29th+) go to branches 1–N
  const int branches = 4;
  const int basePerBranch = 7;
  final extraDays = daysInMonth - basePerBranch * branches;
  List<WeekData> result = [];
  int cursor = 1;
  for (int i = 0; i < branches; i++) {
    // branch 0 always has basePerBranch days; branches 1.. get an extra day if extraDays >= index
    final additional = (i > 0 && (i <= extraDays)) ? 1 : 0;
    final count = basePerBranch + additional;
    List<DayData> days = [];
    for (int j = 0; j < count; j++) {
      days.add(DayData(visited: visitedSet.contains(cursor)));
      cursor++;
    }
    result.add(WeekData(days: days));
  }
  return result;
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
    this.branchLengthFactor = 0.2, // controls main branch length relative to container width
    this.leafBranchLengthFactor = 0.50, // controls leaf puff radius relative to container width
    this.leafStemLengthFactor = 0.32,  // shorter stems
    this.leafSizeFactor = 0.05,       // leaf circle radius relative to width
  }) : super(key: key);

  /// Create a BonsaiTree from a JSON string containing date timestamps
  /// Format expected: {"visits": ["YYYY-MM-DDThh:mm:ssZ", ...]}
  factory BonsaiTree.fromJson(
    String jsonString, {
    Key? key,
    int? year,
    int? month,
    double branchLengthFactor = 0.2,
    double leafBranchLengthFactor = 0.50,
    double leafStemLengthFactor = 0.32,
    double leafSizeFactor = 0.05,
  }) {
    final data = json.decode(jsonString);
    return BonsaiTree.fromMap(
      data,
      key: key,
      year: year,
      month: month,
      branchLengthFactor: branchLengthFactor,
      leafBranchLengthFactor: leafBranchLengthFactor,
      leafStemLengthFactor: leafStemLengthFactor,
      leafSizeFactor: leafSizeFactor,
    );
  }

  /// Create a BonsaiTree from a pre-parsed Map containing date timestamps
  /// Format expected: {"visits": ["YYYY-MM-DDThh:mm:ssZ", ...]}
  factory BonsaiTree.fromMap(
    Map<String, dynamic> data, {
    Key? key,
    int? year,
    int? month,
    double branchLengthFactor = 0.2,
    double leafBranchLengthFactor = 0.50,
    double leafStemLengthFactor = 0.32,
    double leafSizeFactor = 0.05,
  }) {
    final visitsList = data['visits'] as List<dynamic>;
    final visits = visitsList.map((e) => DateTime.parse(e as String)).toList();
    
    // Auto-detect year and month if not provided
    if (visits.isNotEmpty) {
      // Sort visits to find the most recent month data
      visits.sort((a, b) => b.compareTo(a)); // descending order
      
      // Use the most recent timestamp to determine month/year
      year ??= visits.first.year;
      month ??= visits.first.month;
    } else {
      // If no timestamps provided, use current month
      final now = DateTime.now();
      year ??= now.year;
      month ??= now.month;
    }
    
    final weeks = generateWeekData(visits, year: year, month: month);
    
    return BonsaiTree(
      key: key,
      weeks: weeks,
      branchLengthFactor: branchLengthFactor,
      leafBranchLengthFactor: leafBranchLengthFactor,
      leafStemLengthFactor: leafStemLengthFactor,
      leafSizeFactor: leafSizeFactor,
    );
  }

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