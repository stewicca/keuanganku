import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widget/financial_overview_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const ROUTE_NAME = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;

  final List<Map<String, dynamic>> data = [
    {"label": "Makan", "value": 40.0, "color": Colors.blue},
    {"label": "Transport", "value": 30.0, "color": Colors.orange},
    {"label": "Hiburan", "value": 30.0, "color": Colors.green},
  ];

  List<PieChartSectionData> showingSections() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 90 : 70;

      return PieChartSectionData(
        color: data[i]["color"],
        value: data[i]["value"],
        title: data[i]["label"],
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
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
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
            InfoCard(title: "Balance", value: 10000000, color: Colors.green),
            InfoCard(title: "Expenses", value: 3000000, color: Colors.red),
            InfoCard(title: "Debt", value: 2000000, color: Colors.orange),
          ],
        ),
      )
    );
  }
}
