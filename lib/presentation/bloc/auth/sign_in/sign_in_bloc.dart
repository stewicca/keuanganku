import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/entity/auth/sign_in.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepositoryImpl;

  SignInBloc(this._authRepositoryImpl) : super(SignInInitial()) {
    on<FetchSignIn>((event, emit) async {
      emit(SignInLoading());

      final result = await _authRepositoryImpl.login(
        event.username,
        event.password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      result.fold((l) => emit(SignInError(message: l.message)), (r) {
        prefs.setString('token', r.token!);
        emit(SignInSuccess(signIn: r));
      });
    });
  }
}
