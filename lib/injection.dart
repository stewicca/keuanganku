import 'package:dio/dio.dart';
import 'package:expensetracker/presentation/bloc/auth/sign_in/sign_in_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:expensetracker/presentation/bloc/budget/budgets_bloc.dart';
import 'package:get_it/get_it.dart';
import 'common/auth_interceptor.dart';
import 'common/logging_interceptor.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/repository/budgets_repository_impl.dart';
import 'data/source/remote/auth_remote_data_source.dart';
import 'data/source/remote/budgets_remote_data_source.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/repository/budgets_repository.dart';

final locator = GetIt.instance;

void initializeDependencies() {
  final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));

  dio.interceptors.add(AuthInterceptor(dio));
  dio.interceptors.add(LoggingInterceptor());

  locator.registerLazySingleton<Dio>(() => dio);

  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<BudgetsRemoteDataSource>(() => BudgetsRemoteDataSourceImpl(dio: locator()));

  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<BudgetsRepository>(() => BudgetsRepositoryImpl(remoteDataSource: locator()));

  locator.registerFactory<SignInBloc>(() => SignInBloc(locator()));
  locator.registerFactory<SignUpBloc>(() => SignUpBloc(locator()));
  locator.registerFactory<BudgetsBloc>(() => BudgetsBloc(locator()));
}
