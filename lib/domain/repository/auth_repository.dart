import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entity/auth/signin.dart';
import '../entity/auth/signup.dart';

abstract class AuthRepository {
  Future<Either<Failure, Signin>> login(String username, String password);

  Future<Either<Failure, Signup>> register(String username, String password);
}
