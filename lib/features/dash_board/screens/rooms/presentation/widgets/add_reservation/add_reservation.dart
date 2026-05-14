import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/date_picker_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/time_picker_button.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class AddReservation extends StatefulWidget {
  const AddReservation({super.key});

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String dateFormat = '';
  TimeOfDay selectedFromTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  RoomsModel? selectedRoom;
  List<RoomsModel> rooms = [];
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFromTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedFromTime = picked;
      });
    }
  }

  Future<void> _pickToTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedToTime = picked;
      });
    }
  }

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
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          void addRes() async {
            if (_formKey.currentState!.validate()) {
              final price = StringExtensions.calculateTotal(
                selectedFromTime,
                selectedToTime,
                selectedRoom!.price,
              );
              ReservationModel rev = ReservationModel(
                name: nameController.text,
                number: numberController.text,
                room: selectedRoom!.name,
                date: selectedDate,
                from: selectedFromTime,
                to: selectedToTime,
                price: price,
                //TODO: add variables
                people: 0,
                description: '',
                tools: [],
                clientType: '',
              );

              final isInsert = await context.read<ReservationCubit>().insertRev(
                rev,
              );
              if (isInsert) {
                ModernToast.showToast(
                  context,
                  'Success',
                  'Reservation Inserted successfully',
                  ToastificationType.success,
                );
                nameController.clear();
                numberController.clear();
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'There is a reservation with the same time or number',
                  ToastificationType.error,
                );
              }
            }
          }

          if (state is InsertReservationLoading) {
            return CircularProgressIndicator();
          } else {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.s3,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndText(
                        text: "Add Reservation",
                        icon: Icons.ring_volume_rounded,
                      ),

                      ElevatedButton.icon(
                        onPressed: addRes,
                        icon: Icon(Icons.add_box),
                        label: Text("Add"),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Name field
                      SizedBox(
                        width: ScreenSize.width / 5.5,
                        child: CustomTextField(
                          controller: nameController,
                          hint: "Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name cannot be empty";
                            }
                            if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                              return "Name must contain only letters and numbers";
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(
                        width: ScreenSize.width / 5.5,
                        child: CustomTextField(
                          controller: numberController,
                          hint: "Number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Number cannot be empty";
                            }
                            if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                              return "Number must contain only numbers and must be 11";
                            }
                            return null;
                          },
                        ),
                      ),

                      BlocBuilder<RoomsCubit, RoomsState>(
                        builder: (context, state) {
                          if (state is GetRooms) {
                            rooms = state.rooms;
                          }
                          return SizedBox(
                            width: ScreenSize.width / 5.5,
                            child: CustomDropdownField(
                              value: selectedRoom?.name,
                              items: rooms.map((p) => p.name).toList(),
                              hint: "Select Room",
                              onChanged: (value) {
                                setState(() {
                                  selectedRoom = rooms.firstWhere(
                                    (p) => p.name == value,
                                  );
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a Room";
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  /// Date + Time pickers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSize.s3,
                    children: [
                      Column(
                        children: [
                          DatePickerButton(onPick: _pickDate),
                          Text(
                            dateFormat.isEmpty ? "No date" : dateFormat,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          TimePickerButton(
                            onPick: _pickFromTime,
                            title: "From",
                          ),
                          Text(
                            _formatTime(selectedFromTime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          TimePickerButton(onPick: _pickToTime, title: "To"),
                          Text(
                            _formatTime(selectedToTime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
