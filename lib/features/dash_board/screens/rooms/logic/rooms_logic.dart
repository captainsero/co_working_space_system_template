import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/reservation_details_dialog.dart';

class RoomsLogic {
  static Future<void> showReservationDetailsDialog(
    BuildContext context,
    ReservationModel reservation,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => ReservationDetailsDialog(reservation: reservation),
    );
  }
}
