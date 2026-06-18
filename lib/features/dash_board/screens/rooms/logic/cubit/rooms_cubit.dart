import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_rooms.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());

  void getRooms() async {
    final rooms = await SupabaseRooms.getRooms();
    emit(GetRooms(rooms: rooms));
  }

  void getRoomReservations(String room) async {
    emit(RoomsLoading());
    final reservation = await SupabaseRooms.getRoomReservations(room);
    emit(GetRoomReservations(reservations: reservation));
  }

  void filterReservationsByDate({
    required DateTime? fromDate,
    required DateTime? toDate,
  }) {
    // grab the full list from whichever state we're currently in
    final List<ReservationModel> allReservations = switch (state) {
      GetRoomReservations s => s.reservations,
      FilteredRoomReservations s => s.allReservations,
      _ => [],
    };

    if (fromDate == null && toDate == null) {
      // no filter active — show everything
      emit(
        FilteredRoomReservations(
          allReservations: allReservations,
          filteredReservations: allReservations,
          fromDate: null,
          toDate: null,
        ),
      );
      return;
    }

    final filtered = allReservations.where((r) {
      // r.date is the reservation's DateTime — adjust field name to yours
      final reservationDate = DateTime(r.date.year, r.date.month, r.date.day);

      final from = fromDate != null
          ? DateTime(fromDate.year, fromDate.month, fromDate.day)
          : null;

      final to = toDate != null
          ? DateTime(toDate.year, toDate.month, toDate.day)
          : null;

      final afterFrom = from == null || !reservationDate.isBefore(from);
      final beforeTo = to == null || !reservationDate.isAfter(to);

      return afterFrom && beforeTo;
    }).toList();

    emit(
      FilteredRoomReservations(
        allReservations: allReservations,
        filteredReservations: filtered,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  Future<bool> insertRoom(RoomsModel room) async {
    emit(RoomsLoading());
    if (!await SupabaseRooms.insertRoom(room)) {
      getRooms();
      return false;
    } else {
      getRooms();
      return true;
    }
  }

  Future<bool> deleteRoom(String name) async {
    emit(RoomsLoading());
    final delete = await SupabaseRooms.deleteRoom(name);
    if (delete) {
      getRooms();
      return true;
    } else {
      getRooms();
      return false;
    }
  }
}
