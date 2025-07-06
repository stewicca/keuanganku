part of 'refresh_bloc.dart';

sealed class RefreshState extends Equatable {
  const RefreshState();

  @override
  List<Object> get props => [];
}

class RefreshInitial extends RefreshState {}

class RefreshLoading extends RefreshState {}

class RefreshSuccess extends RefreshState {
  final Refresh refresh;

  const RefreshSuccess({ required this.refresh });
}

class RefreshError extends RefreshState {
  final String message;

  const RefreshError({ required this.message });
}
