part of 'rooms_cubit.dart';

@immutable
sealed class RoomsState {}

final class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class InsertRoom extends RoomsState {}

class DeleteRoom extends RoomsState {}

class RoomsError extends RoomsState {
  final String message;

  RoomsError({required this.message});
}

class GetRooms extends RoomsState {
  final List<RoomsModel> rooms;

  GetRooms({required this.rooms});
}

class GetRoomReservations extends RoomsState {
  final List<ReservationModel> reservations;

  GetRoomReservations({required this.reservations});
}

class FilteredRoomReservations extends RoomsState {
  final List<ReservationModel> allReservations;
  final List<ReservationModel> filteredReservations;
  final DateTime? fromDate;
  final DateTime? toDate;

  FilteredRoomReservations({
    required this.allReservations,
    required this.filteredReservations,
    this.fromDate,
    this.toDate,
  });
}
