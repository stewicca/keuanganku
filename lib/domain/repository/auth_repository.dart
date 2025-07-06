import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entity/auth/sign_in.dart';
import '../entity/auth/sign_up.dart';
import '../entity/user/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignIn>> login(String username, String password);

  Future<Either<Failure, SignUp>> register(String username, String password);

  Future<Either<Failure, User>> me();
}
