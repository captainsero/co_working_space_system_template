part of 'time_screen_cubit.dart';

@immutable
sealed class TimeScreenState {}

final class TimeScreenInitial extends TimeScreenState {}

class GetTotal extends TimeScreenState {
  final double total;
  final bool isTotalVisible;

  GetTotal({required this.total, this.isTotalVisible = false});
}

class RoomsDataLoaded extends TimeScreenState {
  final List<Map<String, dynamic>> roomsData;
  RoomsDataLoaded(this.roomsData);
}

class RoomUpserted extends TimeScreenState {
  final Map<String, dynamic> room;
  RoomUpserted(this.room);
}
