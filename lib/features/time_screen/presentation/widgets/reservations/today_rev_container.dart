import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/rooms_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/reservations/checkout/reservation_checkout.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/reservations/room_condition.dart';

class TodayRevContainer extends StatelessWidget {
  const TodayRevContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSize.s5,
        children: [
          /// Header
          Row(
            spacing: AppSize.s0_5,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Text(
                "Today's Reservations",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),

          /// Reservations List
          Expanded(
            child: BlocBuilder<ReservationCubit, ReservationState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reservations = state.reservationsByDate;

                if (reservations.isEmpty) {
                  return Center(
                    child: Text(
                      "No reservations today",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final res = reservations[index];
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppPadding.p4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: AppSize.s2,
                          children: [
                            /// Name + Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  res.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),

                                /// Number
                                IconAndText(
                                  text: res.number,
                                  icon: Icons.phone_outlined,
                                ),

                                /// Room
                                IconAndText(
                                  text: res.room,
                                  icon: Icons.room_outlined,
                                ),
                                IconAndText(
                                  text: StringExtensions.formatTimeRange(
                                    res.from,
                                    res.to,
                                  ),
                                  icon: Icons.watch_later_outlined,
                                ),
                              ],
                            ),

                            /// Time + Checkout
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: AppSize.s5,
                              children: [
                                RoomCondition(from: res.from, to: res.to),
                                ElevatedButton(
                                  onPressed: () {
                                    RoomsLogic.showReservationDetailsDialog(
                                      context,
                                      res,
                                    );
                                  },
                                  child: Text("Show"),
                                ),

                                ReservationCheckout(res: res),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
