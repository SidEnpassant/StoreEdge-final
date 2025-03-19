import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:storeedge/services/functions/revenue_service.dart';
import 'dart:math' as math;

class RevenueCard extends StatefulWidget {
  const RevenueCard({Key? key}) : super(key: key);

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard>
    with SingleTickerProviderStateMixin {
  final RevenueService _revenueService = RevenueService();
  bool _isLoading = true;
  double _expense = 0;
  double _revenue = 0;
  double _profit = 0;
  int touchedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _revenueService.getRevenueAndExpense();
      setState(() {
        _expense = data['expense'].toDouble();
        _revenue = data['revenue'].toDouble();
        _profit = _revenue - _expense;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        color: Colors.red.shade400,
        value: _expense,
        title:
            'Expenses\n${(_expense / (_revenue + _expense) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 0 ? 110 : 100,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(
          'Expenses',
          Colors.red.shade400,
          touchedIndex == 0,
        ),
        badgePositionPercentageOffset: 1.2,
        showTitle: true,
      ),
      PieChartSectionData(
        color: Colors.green.shade400,
        value: _revenue,
        title:
            'Revenue\n${(_revenue / (_revenue + _expense) * 100).toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 110 : 100,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(
          'Revenue',
          Colors.green.shade400,
          touchedIndex == 1,
        ),
        badgePositionPercentageOffset: 1.2,
        showTitle: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF5044FC),
              const Color(0xFF5044FC).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5044FC).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(height: 34),
                  SizedBox(
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _rotateAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: (1 - _rotateAnimation.value) * 2 * math.pi,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: getSections(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Profit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _profit >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: _profit >= 0
                                  ? Colors.green.shade400
                                  : Colors.red.shade400,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rs ${_profit.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: _profit >= 0
                                    ? Colors.white
                                    : Colors.red.shade400,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        'Revenue',
                        _revenue,
                        Colors.green.shade400,
                        Icons.trending_up,
                        _rotateAnimation,
                      ),
                      _buildStatCard(
                        'Expenses',
                        _expense,
                        Colors.red.shade400,
                        Icons.trending_down,
                        _rotateAnimation,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(String label, double value, Color color, IconData icon,
      Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.35,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Rs ${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: animation.value,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 9,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isTouched;

  const _Badge(this.text, this.color, this.isTouched);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
