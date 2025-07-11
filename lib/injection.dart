import 'package:dio/dio.dart';
import 'package:expensetracker/presentation/bloc/auth/me/me_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/sign_in/sign_in_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:expensetracker/presentation/bloc/budget/budgets_bloc.dart';
import 'package:expensetracker/presentation/bloc/category/categories_bloc.dart';
import 'package:expensetracker/presentation/bloc/expense/expenses_bloc.dart';
import 'package:expensetracker/presentation/bloc/user/update_monthly_salary_bloc.dart';
import 'package:get_it/get_it.dart';
import 'common/auth_interceptor.dart';
import 'common/logging_interceptor.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/repository/budgets_repository_impl.dart';
import 'data/repository/categories_repository_impl.dart';
import 'data/repository/expenses_repository_impl.dart';
import 'data/repository/users_repository_impl.dart';
import 'data/source/remote/auth_remote_data_source.dart';
import 'data/source/remote/budgets_remote_data_source.dart';
import 'data/source/remote/categories_remote_data_source.dart';
import 'data/source/remote/expenses_remote_data_source.dart';
import 'data/source/remote/users_remote_data_source.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/repository/budgets_repository.dart';
import 'domain/repository/categories_repository.dart';
import 'domain/repository/expenses_repository.dart';
import 'domain/repository/users_repository.dart';

final locator = GetIt.instance;

void initializeDependencies() {
  final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));

  dio.interceptors.add(AuthInterceptor(dio));
  dio.interceptors.add(LoggingInterceptor());

  locator.registerLazySingleton<Dio>(() => dio);

  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<BudgetsRemoteDataSource>(() => BudgetsRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<CategoriesRemoteDataSource>(() => CategoriesRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<ExpensesRemoteDataSource>(() => ExpensesRemoteDataSourceImpl(dio: locator()));

  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<BudgetsRepository>(() => BudgetsRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<CategoriesRepository>(() => CategoriesRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<ExpensesRepository>(() => ExpensesRepositoryImpl(remoteDataSource: locator()));

  locator.registerFactory<MeBloc>(() => MeBloc(locator()));
  locator.registerFactory<SignInBloc>(() => SignInBloc(locator()));
  locator.registerFactory<SignUpBloc>(() => SignUpBloc(locator()));
  locator.registerFactory<BudgetsBloc>(() => BudgetsBloc(locator()));
  locator.registerFactory<CategoriesBloc>(() => CategoriesBloc(locator()));
  locator.registerFactory<UpdateMonthlySalaryBloc>(() => UpdateMonthlySalaryBloc(locator()));
  locator.registerFactory<ExpensesBloc>(() => ExpensesBloc(locator()));
}
