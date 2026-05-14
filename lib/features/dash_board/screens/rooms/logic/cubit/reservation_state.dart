part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class InsertReservationLoading extends ReservationState {}

class InsertReservationSuccess extends ReservationState {
  final String message;

  InsertReservationSuccess({required this.message});
}

class InsertReservationError extends ReservationState {
  final String message;

  InsertReservationError({required this.message});
}

class DeleteReservationLoading extends ReservationState {}

class DeleteReservationSuccess extends ReservationState {
  final String message;

  DeleteReservationSuccess({required this.message});
}

class DeleteReservationError extends ReservationState {
  final String message;

  DeleteReservationError({required this.message});
}

class GetReservationLoading extends ReservationState {}

class GetReservationSuccess extends ReservationState {
  final String message;

  GetReservationSuccess({required this.message});
}

class GetReservationError extends ReservationState {
  final String message;

  GetReservationError({required this.message});
}

class ReservationGet extends ReservationState {
  final List<ReservationModel> reservations;
  final List<ReservationModel> reservationsByDate;

  ReservationGet({
    required this.reservations,
    required this.reservationsByDate,
  });
}

class ReservationFormUpdated extends ReservationState {
  final ReservationFormState form;

  ReservationFormUpdated(this.form);
}

class ReservationFormState {
  final List<ReservationDateModel> selectedDates;
  final List<ToolsModel> selectedTools;
  final List<ToolsModel> tools;
  final List<ClientType> clientTypes;
  final ClientType? selectedClientType;
  final RoomsModel? selectedRoom;
  final bool isLoading;
  final ToolsModel? selectedTool;

  ReservationFormState({
    this.selectedDates = const [],
    this.selectedTools = const [],
    this.tools = const [],
    this.clientTypes = const [],
    this.selectedClientType,
    this.selectedRoom,
    this.isLoading = false,
    this.selectedTool,
  });

  ReservationFormState copyWith({
    List<ReservationDateModel>? selectedDates,
    List<ToolsModel>? selectedTools,
    List<ToolsModel>? tools,
    List<ClientType>? clientTypes,
    ClientType? selectedClientType,
    RoomsModel? selectedRoom,
    bool? isLoading,
    ToolsModel? selectedTool,
  }) {
    return ReservationFormState(
      selectedDates: selectedDates ?? this.selectedDates,
      selectedTools: selectedTools ?? this.selectedTools,
      tools: tools ?? this.tools,
      clientTypes: clientTypes ?? this.clientTypes,
      selectedClientType: selectedClientType ?? this.selectedClientType,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      isLoading: isLoading ?? this.isLoading,
      selectedTool: selectedTool ?? this.selectedTool,
    );
  }
}
