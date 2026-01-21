import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
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
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          Center(child: TableHeader("Subscriptions")),
                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in rooms)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1("${ele.price}"),
                            Center(child: TableCell1("${ele.reservationNum}")),

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
                                  color: Theme.of(context).colorScheme.error,
                                  size: AppSize.s7,
                                ),
                              ),
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
}
