import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class RoomsReservationCard extends StatelessWidget {
  final String dateFormat;

  const RoomsReservationCard({super.key, required this.dateFormat});

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
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Rooms Reservation - $dateFormat",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              SizedBox(height: AppSize.s3),

              BlocBuilder<DaysDataCubit, DaysDataState>(
                builder: (context, state) {
                  List<ReservationModel> reservation = [];
                  if (state is DayCustomersLoad) {
                    reservation = state.reservations;
                  }
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Number"),
                          TableHeader("Room"),
                          TableHeader("Date"),
                          Center(child: TableHeader("Time")),
                          TableHeader("Price"),
                        ],
                      ),
                      for (var ele in reservation)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.number),
                            TableCell1(ele.room),
                            TableCell1(StringExtensions.formatDate(ele.date)),
                            Center(
                              child: TableCell1(
                                StringExtensions.formatTimeRange(
                                  ele.from,
                                  ele.to,
                                ),
                              ),
                            ),
                            TableCell1(ele.price),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
