import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entity/auth/me.dart';
import '../../domain/entity/auth/sign_in.dart';
import '../../domain/entity/auth/sign_up.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<Either<Failure, SignIn>> login(String username, String password) async {
    try {
      final result = await remoteDataSource.login(username, password);
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, SignUp>> register(String username, String password) async {
    try {
      final result = await remoteDataSource.register(username, password);
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Me>> me() async {
    try {
      final result = await remoteDataSource.me();
      return Right(result.toEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (error) {
      return Left(ServerFailure('Unexpected Error'));
    }
  }
}
