part of 'update_monthly_salary_bloc.dart';

sealed class UpdateMonthlySalaryState extends Equatable {
  const UpdateMonthlySalaryState();

  @override
  List<Object> get props => [];
}

class UpdateMonthlySalaryInitial extends UpdateMonthlySalaryState {}

class UpdateMonthlySalaryLoading extends UpdateMonthlySalaryState {}

class UpdateMonthlySalarySuccess extends UpdateMonthlySalaryState {
  final User user;

  const UpdateMonthlySalarySuccess({ required this.user });
}

class UpdateMonthlySalaryError extends UpdateMonthlySalaryState {
  final String message;

  const UpdateMonthlySalaryError({ required this.message });
}
