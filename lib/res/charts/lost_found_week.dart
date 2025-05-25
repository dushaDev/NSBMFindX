import 'package:find_x/res/font_profile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LostFoundWeek extends StatelessWidget {
  final Color foundItemsColor;
  final Color lostItemsColor;
  final List<FlSpot> lostItemsData;
  final List<FlSpot> foundItemsData;
  final int yAxisMax;

  LostFoundWeek({
    super.key,
    this.foundItemsColor = Colors.black26,
    this.lostItemsColor = Colors.black12,
    required this.lostItemsData,
    required this.foundItemsData,
    required this.yAxisMax,
  });

  // Helper method to get the last 7 days as day numbers
  List<int> getLast7DaysAsDayNumbers() {
    List<int> last7Days = [];
    DateTime now = DateTime.now();
    // Iterate over the last 7 days
    for (int i = 0; i < 7; i++) {
      // Calculate the date for each day
      DateTime date = now.subtract(Duration(days: i));
      // Extract the day part of the date
      int day = date.day;
      // Add the day to the list
      last7Days.add(day);
    }
    // Reverse the list to have the oldest day first
    return last7Days.reversed.toList();
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: FontProfile.small,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onSurface,
    );

    // Get the last 7 days as day numbers
    List<int> last7Days = getLast7DaysAsDayNumbers();

    // Ensure the value is within the range of the last 7 days
    if (value >= 1 && value <= 7) {
      int day = last7Days[value.toInt() - 1];
      return SideTitleWidget(
        meta: meta,
        space: 4,
        child: Text('D $day', style: style),
      );
    }

    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: FontProfile.small,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for the last 7 days

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 24,
              top: 12,
              bottom: 12,
            ),
            child: LineChart(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorder: BorderSide(color: Colors.grey),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final text = spot.barIndex == 0
                            ? 'Found: ${spot.y.toInt()}'
                            : 'Lost: ${spot.y.toInt()}';
                        return LineTooltipItem(
                          text,
                          TextStyle(
                            color: spot.barIndex == 0
                                ? foundItemsColor
                                : lostItemsColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: foundItemsData,
                    isCurved: true,
                    color: foundItemsColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: lostItemsData,
                    isCurved: true,
                    color: lostItemsColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minY: 0,
                maxY: yAxisMax.toDouble(),
                minX: 1,
                maxX: 7, // 1-7 = 7 days
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) =>
                          bottomTitleWidgets(value, meta, context),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) =>
                          leftTitleWidgets(value, meta, context),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withAlpha(50),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withAlpha(100),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withAlpha(100),
                        width: 1,
                      ),
                    )),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Legend to describe the data
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(foundItemsColor, 'Found', context: context),
            const SizedBox(width: 16),
            _buildLegendItem(lostItemsColor, 'Lost', context: context),
          ],
        ),
      ],
    );
  }

  // Helper method to build legend items
  Widget _buildLegendItem(Color color, String text,
      {required BuildContext context}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
          ),
        ),
      ],
    );
  }
}
