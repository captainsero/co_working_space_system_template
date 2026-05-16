import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/rooms_logic.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class RoomReservation extends StatelessWidget {
  const RoomReservation({
    super.key,
    required this.date,
    required this.dateFormate,
  });
  final DateTime date;
  final String dateFormate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconAndText(
                  text: "Rooms Reservation",
                  icon: Icons.connect_without_contact_sharp,
                ),
                Text(dateFormate, style: TextStyle(fontSize: FontSize.s7)),
              ],
            ),

            BlocBuilder<ReservationCubit, ReservationState>(
              builder: (context, state) {
                final reservations = state.filteredReservations;

                if (state.isLoading) {
                  return CircularProgressIndicator();
                }

                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableHeader("Name"),
                        TableHeader("Number"),
                        TableHeader("Room"),
                        Center(child: TableHeader("Time")),
                        Center(child: TableHeader("Action")),
                      ],
                    ),
                    for (var ele in reservations)
                      TableRow(
                        children: [
                          TableCell1(ele.name),
                          TableCell1(ele.number),
                          TableCell1(ele.room),
                          TableCell1(
                            StringExtensions.formatTimeRange(ele.from, ele.to),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  RoomsLogic.showReservationDetailsDialog(
                                    context,
                                    ele,
                                  );
                                },
                                child: Text("Show"),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final delete = await context
                                      .read<ReservationCubit>()
                                      .deleteRev(ele.id!, date);

                                  if (delete) {
                                    ModernToast.showToast(
                                      context,
                                      'Success',
                                      'Reservation Deleted successfully',
                                      ToastificationType.success,
                                    );
                                  } else {
                                    ModernToast.showToast(
                                      context,
                                      'Error',
                                      'Cannot delete the Reservation, try again',
                                      ToastificationType.error,
                                    );
                                  }
                                },
                                icon: Padding(
                                  padding: EdgeInsets.all(AppPadding.p2),
                                  child: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
