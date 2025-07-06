part of 'budgets_bloc.dart';

sealed class BudgetsState extends Equatable {
  const BudgetsState();

  @override
  List<Object> get props => [];
}

class BudgetsInitial extends BudgetsState {}

class BudgetsLoading extends BudgetsState {}

class BudgetsSuccess extends BudgetsState {
  final Budgets budgets;

  const BudgetsSuccess({ required this.budgets });
}

class BudgetsError extends BudgetsState {
  final String message;

  const BudgetsError({ required this.message });
}
