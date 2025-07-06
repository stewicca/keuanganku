import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/budget/budgets.dart';
import '../../domain/repository/budgets_repository.dart';
import '../source/remote/budgets_remote_data_source.dart';

class BudgetsRepositoryImpl implements BudgetsRepository {
  final BudgetsRemoteDataSource remoteDataSource;

  BudgetsRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<Either<Failure, Budgets>> getBudgets(int year, int month) async {
    try {
      final result = await remoteDataSource.getBudgets(year, month);
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
