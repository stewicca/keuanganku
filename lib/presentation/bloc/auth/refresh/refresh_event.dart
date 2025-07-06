part of 'refresh_bloc.dart';

sealed class RefreshEvent extends Equatable {
  const RefreshEvent();
}

class FetchRefresh extends RefreshEvent {
  const FetchRefresh();

  @override
  List<Object?> get props => [];
}
