import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/core/models/reservation_date_model.dart';
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
  const AddReservation({super.key, required this.date});
  final DateTime date;

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController peopleController = TextEditingController();

  String dateFormat = '';
  List<ReservationDateModel> selectedReservations = [];
  RoomsModel? selectedRoom;
  List<RoomsModel> rooms = [];
  final _formKey = GlobalKey<FormState>();
  ClientType? selectedClientType;

  @override
  initState() {
    super.initState();
  }

  Future<void> _pickMultiDates() async {
    final dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.multi,
      ),
      dialogSize: const Size(500, 400),
      value: [],
      borderRadius: BorderRadius.circular(15),
    );

    if (dates != null && dates.isNotEmpty) {
      setState(() {
        selectedReservations = dates
            .whereType<DateTime>()
            .map(
              (date) => ReservationDateModel(
                date: date,
                from: TimeOfDay.now(),
                to: TimeOfDay.now(),
              ),
            )
            .toList();
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
              bool hasError = false;
              final peaoleNumber = int.parse(peopleController.text);

              for (final item in selectedReservations) {
                final price = StringExtensions.calculateTotal(
                  item.from,
                  item.to,
                  selectedRoom!.price,
                );

                ReservationModel rev = ReservationModel(
                  name: nameController.text,
                  number: numberController.text,
                  room: selectedRoom!.name,
                  date: item.date,
                  from: item.from,
                  to: item.to,
                  price: price,
                  people: peaoleNumber,
                  description: descriptionController.text,
                  tools: context
                      .read<ReservationCubit>()
                      .state
                      .formState
                      .selectedTools
                      .map((e) => e.name)
                      .toList(),
                  clientType:
                      context
                          .read<ReservationCubit>()
                          .state
                          .formState
                          .selectedClientType
                          ?.type ??
                      '',
                );

                final isInsert = await context
                    .read<ReservationCubit>()
                    .insertRev(rev, widget.date);

                if (!isInsert) {
                  hasError = true;
                }
              }

              if (!hasError) {
                ModernToast.showToast(
                  context,
                  'Success',
                  'Reservations inserted successfully',
                  ToastificationType.success,
                );

                nameController.clear();
                numberController.clear();

                setState(() {
                  selectedReservations.clear();
                });
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'Some reservations conflict with existing times',
                  ToastificationType.error,
                );
              }
            }
          }

          if (state.isLoading) {
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: ScreenSize.width / 5.5,
                        child: CustomTextField(
                          controller: descriptionController,
                          hint: "Description",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Description cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width / 7,
                        child: CustomTextField(
                          controller: peopleController,
                          hint: "People number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Paople cannot be empty";
                            }

                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return "People must contain only numbers";
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width / 7,
                        child: BlocBuilder<ReservationCubit, ReservationState>(
                          builder: (context, state) {
                            final cubit = context.read<ReservationCubit>();

                            return CustomDropdownField(
                              value: cubit.state.formState.selectedTool?.name,

                              items: cubit.state.formState.tools
                                  .map((e) => e.name)
                                  .toList(),

                              hint: "Select Tool",

                              onChanged: (value) {
                                final tool = cubit.state.formState.tools
                                    .firstWhere((e) => e.name == value);

                                cubit.addTool(tool);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width / 5.5,
                        child: CustomDropdownField(
                          value: context
                              .read<ReservationCubit>()
                              .state
                              .formState
                              .selectedClientType
                              ?.type,

                          items: context
                              .read<ReservationCubit>()
                              .state
                              .formState
                              .clientTypes
                              .map((e) => e.type)
                              .toList(),

                          hint: "Client Type",

                          onChanged: (value) {
                            final selected = context
                                .read<ReservationCubit>()
                                .state
                                .formState
                                .clientTypes
                                .firstWhere((e) => e.type == value);

                            context.read<ReservationCubit>().selectClientType(
                              selected,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: context
                        .read<ReservationCubit>()
                        .state
                        .formState
                        .selectedTools
                        .map(
                          (tool) => Chip(
                            label: Text(tool.name),
                            backgroundColor: ColorManager.orange,
                            deleteIconColor: ColorManager.error,
                            deleteIcon: Icon(Icons.close),
                            onDeleted: () {
                              context.read<ReservationCubit>().removeTool(tool);
                            },
                          ),
                        )
                        .toList(),
                  ),

                  /// Date + Time pickers
                  Column(
                    children: [
                      DatePickerButton(onPick: _pickMultiDates),

                      const SizedBox(height: 20),

                      if (selectedReservations.isNotEmpty)
                        SizedBox(
                          height: ScreenSize.height / 2,
                          child: ListView.builder(
                            itemCount: selectedReservations.length,
                            itemBuilder: (context, index) {
                              final item = selectedReservations[index];

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        StringExtensions.formatDate(item.date),
                                      ),

                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              TimePickerButton(
                                                title: "From",
                                                onPick: () async {
                                                  final picked =
                                                      await showTimePicker(
                                                        context: context,
                                                        initialTime: item.from,
                                                      );

                                                  if (picked != null) {
                                                    setState(() {
                                                      selectedReservations[index] =
                                                          ReservationDateModel(
                                                            date: item.date,
                                                            from: picked,
                                                            to: item.to,
                                                          );
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(_formatTime(item.from)),
                                            ],
                                          ),

                                          const SizedBox(width: 20),

                                          Column(
                                            children: [
                                              TimePickerButton(
                                                title: "To",
                                                onPick: () async {
                                                  final picked =
                                                      await showTimePicker(
                                                        context: context,
                                                        initialTime: item.to,
                                                      );

                                                  if (picked != null) {
                                                    setState(() {
                                                      selectedReservations[index] =
                                                          ReservationDateModel(
                                                            date: item.date,
                                                            from: item.from,
                                                            to: picked,
                                                          );
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(_formatTime(item.to)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
