import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/budget/budgets_bloc.dart';
import '../../widget/financial_overview_card.dart';
import '../../../domain/entity/budget/budget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const ROUTE_NAME = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int touchedIndex = -1;

  final List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<BudgetsBloc>().add(
      FetchBudgets(year: now.year, month: now.month),
    );
  }

  List<PieChartSectionData> showingSections(List<Budget> budgets) {
    return List.generate(budgets.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 90 : 70;

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: budgets[i].percentage,
        title: budgets[i].label,
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
      body: BlocBuilder<BudgetsBloc, BudgetsState>(
        builder: (context, state) {
          if (state is BudgetsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BudgetsSuccess) {
            final budgets = state.budgets.budgets;
            return SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(budgets),
                      ),
                    ),
                  ),
                  for (int i = 0; i < budgets.length; i++)
                    InfoCard(
                      title: budgets[i].label,
                      budgetAmount: budgets[i].budgetAmount,
                      currentAmount: budgets[i].currentAmount,
                      color: colors[i % colors.length],
                    ),
                ],
              ),
            );
          }

          if (state is BudgetsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
