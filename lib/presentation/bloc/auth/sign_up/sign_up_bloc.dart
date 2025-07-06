import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/entity/auth/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepositoryImpl;

  SignUpBloc(this._authRepositoryImpl) : super(SignUpInitial()) {
    on<FetchSignUp>((event, emit) async {
      emit(SignUpLoading());

      final result = await _authRepositoryImpl.register(
        event.username,
        event.password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      result.fold((l) => emit(SignupError(message: l.message)), (r) {
        prefs.setString('token', r.token!);
        emit(SignUpSuccess(signUp: r));
      });
    });
  }
}
