part of 'budgets_bloc.dart';

sealed class BudgetsEvent extends Equatable {
  const BudgetsEvent();
}

class FetchBudgets extends BudgetsEvent {
  final int year;
  final int month;

  const FetchBudgets({ required this.year, required this.month });

  @override
  List<Object?> get props => [year, month];
}
