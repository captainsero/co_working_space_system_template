import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class CustomersTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const CustomersTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width,
      height: ScreenSize.height / 2,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: SingleChildScrollView(
        child: State is DaysDataLoading || State is DaysDataInitial
            ? CircularProgressIndicator()
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                  6: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      TableHeader("Name"),
                      TableHeader("Number"),
                      TableHeader("Collage"),
                      TableHeader("Price"),
                      TableHeader("Partnership"),
                      Center(child: TableHeader("Time")),
                      TableHeader("Note"),
                    ],
                  ),
                  for (var row in data) ...[
                    TableRow(
                      children: [
                        TableCell1(row["name"]),
                        TableCell1(row["number"]),
                        TableCell1(row["collage"]),
                        TableCell1(row["price"]),
                        TableCell1(row["partnership_code"]),
                        Center(child: TableCell1(row["time"])),
                        TableCell1(row["note"]),
                      ],
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
