import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/entity/auth/refresh.dart';
import '../../../../domain/repository/auth_repository.dart';

part 'refresh_event.dart';
part 'refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  final AuthRepository _authRepositoryImpl;

  RefreshBloc(this._authRepositoryImpl) : super(RefreshInitial()) {
    on<FetchRefresh>((event, emit) async {
      emit(RefreshLoading());

      final result = await _authRepositoryImpl.refresh();

      SharedPreferences pref = await SharedPreferences.getInstance();

      result.fold((l) => emit(RefreshError(message: l.message)), (r) {
        pref.setString('token', r.token!);
        emit(RefreshSuccess(refresh: r));
      });
    });
  }
}
