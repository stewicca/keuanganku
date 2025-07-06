import 'package:dio/dio.dart';
import '../../../common/exception.dart';
import '../../models/budget/budgets_model.dart';

abstract class BudgetsRemoteDataSource {
  Future<BudgetsModel> getBudgets(int year, int month);
}

class BudgetsRemoteDataSourceImpl implements BudgetsRemoteDataSource {
  final Dio dio;

  BudgetsRemoteDataSourceImpl({ required this.dio });

  @override
  Future<BudgetsModel> getBudgets(int year, int month) async {
    try {
      final response = await dio.get(
        'budgets',
        queryParameters: {
          'year': year,
          'month': month,
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return BudgetsModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Get budgets failed');
      }
    } on DioException catch (error) {
      throw ServerException(error.response?.data['message'] ?? 'Get budgets failed');
    }
  }
}
