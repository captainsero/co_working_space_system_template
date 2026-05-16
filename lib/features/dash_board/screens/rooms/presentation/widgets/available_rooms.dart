import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class AvailableRooms extends StatelessWidget {
  const AvailableRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height / 2,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSize.s3,
          children: [
            IconAndText(text: "Available Rooms", icon: Icons.room_preferences),

            BlocBuilder<RoomsCubit, RoomsState>(
              builder: (context, state) {
                List<RoomsModel> rooms = [];
                if (state is GetRooms) {
                  rooms = state.rooms;
                }

                if (state is RoomsLoading) {
                  return CircularProgressIndicator();
                } else {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          Center(child: TableHeader("Subscriptions")),
                          Center(child: TableHeader("Min-Avr-Max")),
                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in rooms)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1("${ele.price}"),
                            Center(child: TableCell1("${ele.reservationNum}")),
                            Center(
                              child: TableCell1(
                                "${ele.minHours} - ${ele.averageHours} - ${ele.maxHours}",
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    context
                                        .read<RoomsCubit>()
                                        .getRoomReservations(ele.name);
                                    await showRoomReservationsDialog(context);
                                    context.read<RoomsCubit>().getRooms();
                                  },
                                  child: Text("Show"),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final delete = await context
                                        .read<RoomsCubit>()
                                        .deleteRoom(ele.name);

                                    if (delete) {
                                      ModernToast.showToast(
                                        context,
                                        'Success',
                                        'Room Deleted successfully',
                                        ToastificationType.success,
                                      );
                                    } else {
                                      ModernToast.showToast(
                                        context,
                                        'Error',
                                        'Cannot delete the room, try again',
                                        ToastificationType.error,
                                      );
                                    }
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.all(AppPadding.p2),
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      size: AppSize.s7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showRoomReservationsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          if (state is RoomsLoading) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (state is! GetRoomReservations) {
            return const AlertDialog(
              content: Text("No reservation data found"),
            );
          }

          final reservationsState = state.reservations;

          return AlertDialog(
            title: Text(
              reservationsState.isNotEmpty
                  ? '${reservationsState.first.room} Reservations'
                  : 'Reservations',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            content: SizedBox(
              width: ScreenSize.width / 1.4,
              height: ScreenSize.height / 1.6,
              child: reservationsState.isEmpty
                  ? Center(
                      child: Text(
                        "No Reservations Yet",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,

                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                        },

                        children: [
                          TableRow(
                            children: [
                              TableHeader("Name"),
                              TableHeader("Number"),
                              TableHeader("Date"),
                              TableHeader("Time"),
                              TableHeader("Hours"),
                              TableHeader("People"),
                              TableHeader("Price"),
                            ],
                          ),

                          ...reservationsState.map((reservation) {
                            final duration = getDurationBetween(
                              reservation.from,
                              reservation.to,
                            );

                            return TableRow(
                              children: [
                                TableCell1(reservation.name),

                                TableCell1(reservation.number),

                                Center(
                                  child: TableCell1(
                                    StringExtensions.formatDate(
                                      reservation.date,
                                    ),
                                  ),
                                ),

                                TableCell1(
                                  StringExtensions.formatTimeRange(
                                    reservation.from,
                                    reservation.to,
                                  ),
                                ),

                                Center(
                                  child: TableCell1(
                                    duration.inHours.toString(),
                                  ),
                                ),

                                Center(
                                  child: TableCell1(
                                    reservation.people.toString(),
                                  ),
                                ),

                                TableCell1(
                                  reservation.price.toStringAsFixed(2),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      ),
    );
  }

  Duration getDurationBetween(TimeOfDay from, TimeOfDay to) {
    final fromMinutes = from.hour * 60 + from.minute;

    final toMinutes = to.hour * 60 + to.minute;

    return Duration(minutes: toMinutes - fromMinutes);
  }
}
