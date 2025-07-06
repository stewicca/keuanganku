import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user/update_monthly_salary_bloc.dart';
import '../../bloc/auth/me/me_bloc.dart';
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

  bool _isDialogShowing = false;

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
    context.read<MeBloc>().add(const FetchMe());
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

  void _showUpdateSalaryDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    final formKey = GlobalKey<FormBuilderState>();
    final salaryController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<UpdateMonthlySalaryBloc>(),
          child:
              BlocListener<UpdateMonthlySalaryBloc, UpdateMonthlySalaryState>(
                listener: (context, state) {
                  if (state is UpdateMonthlySalarySuccess) {
                    Navigator.pop(dialogContext);
                    final now = DateTime.now();
                    context.read<BudgetsBloc>().add(
                      FetchBudgets(year: now.year, month: now.month),
                    );
                    context.read<MeBloc>().add(const FetchMe());
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Monthly salary updated',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.lightGreen,
                      ),
                    );
                  }

                  if (state is UpdateMonthlySalaryError) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child:
                    BlocBuilder<
                      UpdateMonthlySalaryBloc,
                      UpdateMonthlySalaryState
                    >(
                      builder: (context, state) {
                        if (state is UpdateMonthlySalaryLoading) {
                          return const Dialog(
                            child: SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        }
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          insetPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FormBuilder(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Update Monthly Salary',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FormBuilderTextField(
                                    name: 'salary',
                                    controller: salaryController,
                                    decoration: const InputDecoration(
                                      labelText: 'Monthly Salary',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.numeric(),
                                      FormBuilderValidators.min(1),
                                    ]),
                                  ),
                                  const SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.saveAndValidate() ??
                                              false) {
                                            final salary =
                                                int.tryParse(
                                                  salaryController.text,
                                                ) ??
                                                0;
                                            context
                                                .read<UpdateMonthlySalaryBloc>()
                                                .add(
                                                  FetchUpdateMonthlySalary(
                                                    monthlySalary: salary,
                                                  ),
                                                );
                                          }
                                        },
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
        );
      },
    ).whenComplete(() => _isDialogShowing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Budgets Page',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<BudgetsBloc, BudgetsState>(
        listener: (context, state) {
          if (state is BudgetsError && state.message == 'No monthly salary') {
            _showUpdateSalaryDialog();
          }
        },
        child: BlocBuilder<BudgetsBloc, BudgetsState>(
          builder: (context, state) {
            if (state is BudgetsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BudgetsSuccess) {
              final budgets = state.budgets.budgets;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        DateFormat('dd MMMM yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BlocBuilder<MeBloc, MeState>(
                      builder: (context, meState) {
                        if (meState is MeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (meState is MeSuccess) {
                          final salary = meState.me.monthlySalary ?? 0;
                          return Text(
                            'Monthly Salary: Rp $salary',
                            style: const TextStyle(fontSize: 16),
                          );
                        }

                        if (meState is MeError) {
                          return Text(meState.message);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    AspectRatio(
                      aspectRatio: 1.5,
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
      ),
    );
  }
}
