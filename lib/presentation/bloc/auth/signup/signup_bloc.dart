import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/entity/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/repository/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepositoryImpl;

  SignupBloc(this._authRepositoryImpl) : super(SignupInitial()) {
    on<FetchSignup>((event, emit) async {
      emit(SignupLoading());

      final result = await _authRepositoryImpl.register(
        event.username,
        event.password,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      result.fold((l) => emit(SignupError(message: l.message)), (r) {
        prefs.setString('token', r.token!);
        emit(SignupSuccess(signup: r));
      });
    });
  }
}
