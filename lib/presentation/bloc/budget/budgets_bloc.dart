import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/budget/budgets.dart';
import '../../../domain/repository/budgets_repository.dart';

part 'budgets_event.dart';
part 'budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetsRepository _repository;

  BudgetsBloc(this._repository) : super(BudgetsInitial()) {
    on<FetchBudgets>((event, emit) async {
      emit(BudgetsLoading());

      final result = await _repository.getBudgets(event.year, event.month);

      result.fold(
            (l) => emit(BudgetsError(message: l.message)),
            (r) => emit(BudgetsSuccess(budgets: r)),
      );
    });
  }
}
