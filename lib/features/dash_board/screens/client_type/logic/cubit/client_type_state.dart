part of 'client_type_cubit.dart';

sealed class ClientTypeState extends Equatable {
  const ClientTypeState();

  @override
  List<Object> get props => [];
}

final class ClientTypeInitial extends ClientTypeState {}

final class ClientTypeLoading extends ClientTypeState {}

final class ClientTypeGet extends ClientTypeState {
  final List<ClientType> types;

  const ClientTypeGet({required this.types});

  @override
  List<Object> get props => [types];
}
