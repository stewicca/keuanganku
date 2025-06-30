import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/entity/auth/signin.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthRepository _authRepositoryImpl;

  SigninBloc(this._authRepositoryImpl) : super(SigninInitial()) {
    on<FetchSignin>((event, emit) async {
      emit(SigninLoading());

      final result = await _authRepositoryImpl.login(
        event.username,
        event.password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      result.fold((l) => emit(SigninError(message: l.message)), (r) {
        prefs.setString('token', r.token!);
        emit(SigninSuccess(signin: r));
      });
    });
  }
}
