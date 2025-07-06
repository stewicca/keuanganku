import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../../domain/repository/users_repository.dart';

part 'update_monthly_salary_event.dart';
part 'update_monthly_salary_state.dart';

class UpdateMonthlySalaryBloc extends Bloc<UpdateMonthlySalaryEvent, UpdateMonthlySalaryState> {
  final UserRepository _repository;

  UpdateMonthlySalaryBloc(this._repository) : super(UpdateMonthlySalaryInitial()) {
    on<FetchUpdateMonthlySalary>((event, emit) async {
      emit(UpdateMonthlySalaryLoading());

      final result = await _repository.updateMonthlySalary(event.monthlySalary);

      result.fold(
            (l) => emit(UpdateMonthlySalaryError(message: l.message)),
            (r) => emit(UpdateMonthlySalarySuccess(user: r)),
      );
    });
  }
}
