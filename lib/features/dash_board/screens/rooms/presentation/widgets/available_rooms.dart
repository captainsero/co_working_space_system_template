import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/rooms_logic.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class AvailableRooms extends StatelessWidget {
  const AvailableRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height / 1.3,
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
      builder: (_) => BlocProvider.value(
        // ✅ reuse the same cubit instance from the parent tree
        value: context.read<RoomsCubit>(),
        child: BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            // ─── Loading ───────────────────────────────────────────
            if (state is RoomsLoading) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            // ─── Resolve active list & filter dates ───────────────
            final List<ReservationModel> reservationsToShow;
            DateTime? fromDate;
            DateTime? toDate;

            if (state is FilteredRoomReservations) {
              reservationsToShow = state.filteredReservations;
              fromDate = state.fromDate;
              toDate = state.toDate;
            } else if (state is GetRoomReservations) {
              reservationsToShow = state.reservations;
            } else {
              return const AlertDialog(
                content: Text("No reservation data found"),
              );
            }

            // title room name — works for both states
            final allReservations = state is FilteredRoomReservations
                ? state.allReservations
                : (state as GetRoomReservations).reservations;

            final roomName = allReservations.isNotEmpty
                ? allReservations.first.room
                : 'Reservations';

            // ─── Dialog ────────────────────────────────────────────
            return AlertDialog(
              title: Text(
                '$roomName Reservations',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              content: SizedBox(
                width: ScreenSize.width,
                height: ScreenSize.height / 1.6,
                child: Column(
                  children: [
                    // ── Date filter row ──────────────────────────
                    Row(
                      children: [
                        // FROM date picker
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              fromDate != null
                                  ? '${fromDate.day}/${fromDate.month}/${fromDate.year}'
                                  : 'From date',
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: fromDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                context
                                    .read<RoomsCubit>()
                                    .filterReservationsByDate(
                                      fromDate: picked,
                                      toDate: toDate,
                                    );
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // TO date picker
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              toDate != null
                                  ? '${toDate.day}/${toDate.month}/${toDate.year}'
                                  : 'To date',
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: toDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                context
                                    .read<RoomsCubit>()
                                    .filterReservationsByDate(
                                      fromDate: fromDate,
                                      toDate: picked,
                                    );
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Clear filter button — only shown when a filter is active
                        if (fromDate != null || toDate != null)
                          IconButton(
                            tooltip: 'Clear filter',
                            icon: const Icon(Icons.filter_alt_off),
                            onPressed: () {
                              context
                                  .read<RoomsCubit>()
                                  .filterReservationsByDate(
                                    fromDate: null,
                                    toDate: null,
                                  );
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ── Table or empty state ─────────────────────
                    Expanded(
                      child: reservationsToShow.isEmpty
                          ? Center(
                              child: Text(
                                fromDate != null || toDate != null
                                    ? "No reservations in this date range"
                                    : "No Reservations Yet",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      TableHeader("Name"),
                                      TableHeader("Number"),
                                      TableHeader("Description"),
                                      TableHeader("Hours"),
                                      TableHeader("People"),
                                      TableHeader("Price"),
                                      Center(child: TableHeader("Actions")),
                                    ],
                                  ),
                                  ...reservationsToShow.map((reservation) {
                                    final duration = getDurationBetween(
                                      reservation.from,
                                      reservation.to,
                                    );
                                    return TableRow(
                                      children: [
                                        TableCell1(reservation.name),
                                        TableCell1(reservation.number),
                                        TableCell1(reservation.description),
                                        TableCell1(duration.inHours.toString()),
                                        TableCell1(
                                          reservation.people.toString(),
                                        ),
                                        TableCell1(
                                          reservation.price.toStringAsFixed(2),
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              RoomsLogic.showReservationDetailsDialog(
                                                context,
                                                reservation,
                                              );
                                            },
                                            child: const Text("Show"),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                    ),
                  ],
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
      ),
    );
  }

  Duration getDurationBetween(TimeOfDay from, TimeOfDay to) {
    final fromMinutes = from.hour * 60 + from.minute;

    final toMinutes = to.hour * 60 + to.minute;

    return Duration(minutes: toMinutes - fromMinutes);
  }
}
