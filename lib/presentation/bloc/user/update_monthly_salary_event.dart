part of 'update_monthly_salary_bloc.dart';

sealed class UpdateMonthlySalaryEvent extends Equatable {
  const UpdateMonthlySalaryEvent();
}

class FetchUpdateMonthlySalary extends UpdateMonthlySalaryEvent {
  final int monthlySalary;

  const FetchUpdateMonthlySalary({ required this.monthlySalary });

  @override
  List<Object?> get props => [monthlySalary];
}
