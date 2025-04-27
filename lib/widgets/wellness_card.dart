import 'package:flutter/material.dart';
import '../themes.dart';
import '../services/wellness_service.dart';
import 'package:fl_chart/fl_chart.dart';

class WellnessCard extends StatefulWidget {
  final String category;
  final int percentage;
  final String userId;

  const WellnessCard({
    super.key,
    required this.category,
    required this.percentage,
    this.userId = "johndoe@example.com", // Default value
  });

  @override
  State<WellnessCard> createState() => _WellnessCardState();
}

class _WellnessCardState extends State<WellnessCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final WellnessService _wellnessService = WellnessService();
  List<FlSpot> _historicalData = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fetchHistoricalData();
  }

   Future<void> _fetchHistoricalData() async {
    try {
      final records = await _wellnessService.getUserWellnessRecords(
        userId: widget.userId,
        limit: 8, // Get last 8 records
      );

      // Sort records by date
      records.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        _historicalData = records.asMap().entries.map((entry) {
          // Get the appropriate value based on the category
          int value = 0;
          switch (widget.category.toLowerCase()) {
            case 'physical':
              value = entry.value.physical;
              break;
            case 'financial':
              value = entry.value.financial;
              break;
            case 'emotional':
              value = entry.value.emotional;
              break;
            case 'spiritual':
              value = entry.value.spiritual;
              break;
            case 'social':
              value = entry.value.social;
              break;
            case 'environmental':
              value = entry.value.environmental;
              break;
            case 'creative':
              value = entry.value.creative;
              break;
          }
          return FlSpot(entry.key.toDouble(), value.toDouble());
        }).toList();
        _isLoadingHistory = false;
      });
    } catch (e) {
      // Fallback to placeholder data
      setState(() {
        _historicalData = [
          const FlSpot(0, 40),
          const FlSpot(1, 50),
          const FlSpot(2, 45),
          const FlSpot(3, 60),
          const FlSpot(4, 65),
          const FlSpot(5, 55),
          const FlSpot(6, 70),
          const FlSpot(7, 80),
        ];
        _isLoadingHistory = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDetailsModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: AppColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          final double screenWidth = MediaQuery.of(context).size.width;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${widget.percentage}%",
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: screenWidth,
                    height: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _isLoadingHistory
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          )
                        : LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              minX: 0,
                              maxX: _historicalData.length - 1.0,
                              minY: 0,
                              maxY: 100,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _historicalData,
                                  color: AppColors.primaryBlue,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.primaryBlue.withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _showDetailsModal();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: 170,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.category,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.percentage}%",
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
