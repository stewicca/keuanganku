import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/budget/budgets.dart';

abstract class BudgetsRepository {
  Future<Either<Failure, Budgets>> getBudgets(int year, int month);
}
