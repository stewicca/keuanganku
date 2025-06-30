import 'package:dio/dio.dart';
import 'package:expensetracker/presentation/bloc/auth/signin/signin_bloc.dart';
import 'package:expensetracker/presentation/bloc/auth/signup/signup_bloc.dart';
import 'package:get_it/get_it.dart';

import 'common/interceptors.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/source/remote/auth_remote_data_source.dart';
import 'domain/repository/auth_repository.dart';

final locator = GetIt.instance;

void initializeDependencies() {
  final dio = Dio(BaseOptions(baseUrl: 'https://68f0-110-138-197-92.ngrok-free.app/api/'));

  dio.interceptors.add(LoggingInterceptor());

  locator.registerLazySingleton<Dio>(() => dio);

  //datasource //singleton
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: locator()));

  //repository //singleton
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authRemoteDataSource: locator()));

  //bloc //factory
  //auth
  locator.registerFactory<SigninBloc>(() => SigninBloc(locator()));
  locator.registerFactory<SignupBloc>(() => SignupBloc(locator()));
}
