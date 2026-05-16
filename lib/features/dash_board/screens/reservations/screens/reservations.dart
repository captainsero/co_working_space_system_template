import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/available_rooms.dart';

class Reservations extends StatefulWidget {
  const Reservations({super.key});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Rooms"),

          AvailableRooms(),
        ],
      ),
    );
  }
}
