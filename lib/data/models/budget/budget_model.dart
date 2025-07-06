import 'package:equatable/equatable.dart';
import '../../../domain/entity/budget/budget.dart';

class BudgetModel extends Equatable {
  final String id;
  final String name;
  final String label;
  final int year;
  final int month;
  final int budgetAmount;
  final int currentAmount;
  final double percentage;

  const BudgetModel({
    required this.id,
    required this.name,
    required this.label,
    required this.year,
    required this.month,
    required this.budgetAmount,
    required this.currentAmount,
    required this.percentage,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    label: json['label'] ?? '',
    year: json['year'] ?? 0,
    month: json['month'] ?? 0,
    budgetAmount: json['budget_amount'] ?? 0,
    currentAmount: json['current_amount'] ?? 0,
    percentage: (json['percentage'] is int)
        ? (json['percentage'] as int).toDouble()
        : (json['percentage'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'label': label,
    'year': year,
    'month': month,
    'budget_amount': budgetAmount,
    'current_amount': currentAmount,
    'percentage': percentage,
  };

  Budget toEntity() => Budget(
    id: id,
    name: name,
    label: label,
    year: year,
    month: month,
    budgetAmount: budgetAmount,
    currentAmount: currentAmount,
    percentage: percentage,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    label,
    year,
    month,
    budgetAmount,
    currentAmount,
    percentage
  ];
}
