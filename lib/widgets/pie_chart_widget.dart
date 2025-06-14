import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (sum, e) => sum + e);
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.brown,
    ];

    int colorIndex = 0;

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: _buildPieChart(total, colors),
        ),
        SizedBox(height: 16),
        ...data.entries.map((entry) {
          final color = colors[colorIndex++ % colors.length];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                CircleAvatar(radius: 6, backgroundColor: color),
                SizedBox(width: 8),
                Expanded(
                  child: Text('${entry.key}: ${entry.value.toStringAsFixed(2)}₸'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPieChart(double total, List<Color> colors) {
    int colorIndex = 0;

    return PieChart(
      PieChartData(
        sections: data.entries.map((entry) {
          final percent = (entry.value / total) * 100;
          final color = colors[colorIndex++ % colors.length];
          return PieChartSectionData(
            color: color,
            value: entry.value,
            title: '${percent.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
