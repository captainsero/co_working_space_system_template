import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/reservation_states_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';

class SupabaseRooms {
  static final supabase = Supabase.instance.client;

  /// Insert a new room
  static Future<bool> insertRoom(RoomsModel room) async {
    try {
      // Check if room already exists with same name
      final existing = await supabase
          .from("rooms")
          .select()
          .eq("name", room.name);

      if (existing.isNotEmpty) {
        print("Room with the same name already exists");
        return false; // don't insert
      }

      // Insert new room
      await supabase.from("rooms").insert({
        'name': room.name,
        'price': room.price,
        'reservation_num': room.reservationNum,
      });

      return true;
    } catch (e) {
      print("Insert room error: $e");
      return false;
    }
  }

  /// Get all rooms
  static Future<List<RoomsModel>> getRooms() async {
    try {
      final response = await supabase.from("rooms").select();

      final rooms = (response as List<dynamic>)
          .map((json) => RoomsModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return rooms;
    } catch (e) {
      print("Get rooms error: $e");
      return [];
    }
  }

  static Future<bool> incrementReservationNum(String name) async {
    try {
      // 1. Get current reservation_num
      final room = await supabase
          .from("rooms")
          .select("reservation_num")
          .eq("name", name)
          .maybeSingle();

      if (room == null) return false;

      final currentNum = room["reservation_num"] as int? ?? 0;

      // 2. Update with +1
      await supabase
          .from("rooms")
          .update({'reservation_num': currentNum + 1})
          .eq("name", name);

      return true;
    } catch (e) {
      print("Increment reservation_num error: $e");
      return false;
    }
  }

  /// Delete room by name (or use id if you have one)
  static Future<bool> deleteRoom(String name) async {
    try {
      await supabase.from("rooms").delete().eq('name', name);
      return true;
    } catch (e) {
      print("Delete room error: $e");
      return false;
    }
  }

  static Future<bool> addReservationToRoom(ReservationModel reservation) async {
    try {
      /// 1. Get current reservations
      final room = await supabase
          .from("rooms")
          .select("reservations")
          .eq("name", reservation.room)
          .maybeSingle();

      if (room == null) {
        print("Room not found");
        return false;
      }

      /// 2. Get current jsonb array
      List<dynamic> currentReservations = room["reservations"] ?? [];

      /// 3. Add new reservation
      currentReservations.add(reservation.toJson());

      /// 4. Update room
      await supabase
          .from("rooms")
          .update({"reservations": currentReservations})
          .eq("name", reservation.room);

      return true;
    } catch (e) {
      print("Add reservation to room error: $e");
      return false;
    }
  }

  static Future<List<ReservationModel>> getRoomReservations(
    String roomName,
  ) async {
    try {
      /// get room
      final room = await supabase
          .from("rooms")
          .select("reservations")
          .eq("name", roomName)
          .maybeSingle();

      if (room == null) {
        return [];
      }

      final reservationsJson = room["reservations"];

      /// no reservations
      if (reservationsJson == null ||
          reservationsJson is! List ||
          reservationsJson.isEmpty) {
        return [];
      }

      /// convert json -> model
      final reservations = reservationsJson
          .map<ReservationModel>(
            (e) => ReservationModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();

      /// optional: sort by date newest first
      reservations.sort((a, b) => b.date.compareTo(a.date));

      return reservations;
    } catch (e) {
      print("Get room reservations error: $e");
      return [];
    }
  }

  static Future<ReservationStatsModel?> getRoomReservationStats(
    String roomName,
  ) async {
    try {
      /// get room reservations
      final room = await supabase
          .from("rooms")
          .select("reservations")
          .eq("name", roomName)
          .maybeSingle();

      if (room == null) return null;

      final reservationsJson = room["reservations"];

      if (reservationsJson == null ||
          reservationsJson is! List ||
          reservationsJson.isEmpty) {
        return ReservationStatsModel(maxHours: 0, minHours: 0, averageHours: 0);
      }

      /// convert json -> ReservationModel
      final reservations = reservationsJson
          .map((e) => ReservationModel.fromJson(e))
          .toList();

      /// calculate durations in hours
      final durations = reservations.map((res) {
        final fromMinutes = (res.from.hour * 60) + res.from.minute;

        final toMinutes = (res.to.hour * 60) + res.to.minute;

        return ((toMinutes - fromMinutes) / 60).round();
      }).toList();

      /// stats
      final maxHours = durations.reduce((a, b) => a > b ? a : b);

      final minHours = durations.reduce((a, b) => a < b ? a : b);

      final averageHours =
          (durations.reduce((a, b) => a + b) / durations.length).round();

      return ReservationStatsModel(
        maxHours: maxHours,
        minHours: minHours,
        averageHours: averageHours,
      );
    } catch (e) {
      print("Get room reservation stats error: $e");
      return null;
    }
  }
}
