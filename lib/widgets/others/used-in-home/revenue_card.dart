import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:storeedge/services/functions/revenue_service.dart';

class RevenueCard extends StatefulWidget {
  const RevenueCard({Key? key}) : super(key: key);

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard> {
  final RevenueService _revenueService = RevenueService();
  bool _isLoading = true;
  double _expense = 0;
  double _revenue = 0;
  double _profit = 0;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                SizedBox(
                  height: 240,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
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
                      centerSpaceRadius: 0,
                      sections: getSections(),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Total Profit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _profit >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: _profit >= 0
                          ? Colors.green.shade400
                          : Colors.red.shade400,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rs ${_profit.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            _profit >= 0 ? Colors.white : Colors.red.shade400,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLegend(),
              ],
            ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Expenses', Colors.red.shade400, _expense),
        const SizedBox(width: 20),
        _buildLegendItem('Revenue', Colors.green.shade400, _revenue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Rs ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
