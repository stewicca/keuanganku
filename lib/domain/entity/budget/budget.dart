import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String name;
  final String label;
  final int year;
  final int month;
  final int budgetAmount;
  final int currentAmount;
  final double percentage;

  const Budget({
    required this.id,
    required this.name,
    required this.label,
    required this.year,
    required this.month,
    required this.budgetAmount,
    required this.currentAmount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [id, name, label, year, month, budgetAmount, currentAmount, percentage];
}
