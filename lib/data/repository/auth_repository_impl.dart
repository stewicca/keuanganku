import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/auth/signin.dart';
import '../../domain/entity/auth/signup.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, Signin>> login(String email, String password) async {
    try {
      final result = await authRemoteDataSource.login(email, password);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Signup>> register(
    String username,
    String password,
  ) async {
    try {
      final result = await authRemoteDataSource.register(username, password);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
