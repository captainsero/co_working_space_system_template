import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/date_picker_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/add_reservation.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/room_reservation.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/search_bar.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ReservationCubit>().getResByDate(date: Validators.choosenDay);
    context.read<ReservationCubit>().initReservationForm();
    super.initState();
  }

  DateTime selectedDate = Validators.choosenDay;
  String dateFormat = StringExtensions.formatDate(Validators.choosenDay);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateFormat = StringExtensions.formatDate(selectedDate);
      });
      context.read<ReservationCubit>().getResByDate(date: selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Rooms"),

          AddReservation(date: selectedDate),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchByNumber(
                searchController: searchController,
                onSearchChanged: (value) {
                  context.read<ReservationCubit>().searchReservation(value);
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: DatePickerButton(onPick: _pickDate),
              ),
            ],
          ),

          RoomReservation(date: selectedDate, dateFormate: dateFormat),

          // AvailableRooms(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
