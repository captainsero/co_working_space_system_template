import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class ExpensesTable extends StatelessWidget {
  const ExpensesTable({
    super.key,
    required this.dateFormat,
    required this.date,
  });
  final DateTime date;
  final String dateFormat;

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
          alignment: Alignment.center,
          child: BlocBuilder<DaysDataCubit, DaysDataState>(
            builder: (context, state) {
              double total = 0.0;
              List<ExpensesModel> expenses = [];
              if (state is DayCustomersLoad) {
                total = state.expensesTotal;
                expenses = state.expenses;
              }
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      spacing: AppSize.s20,
                      children: [
                        Text(
                          "Expenses - $dateFormat",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "Total: $total",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.s3),

                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in expenses)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.price),
                            IconButton(
                              onPressed: () async {
                                final delete = await context
                                    .read<DaysDataCubit>()
                                    .deleteExpense(date, ele.name);

                                if (delete) {
                                  ModernToast.showToast(
                                    context,
                                    'Success',
                                    'Reservation Deleted successfully',
                                    ToastificationType.success,
                                  );
                                  context
                                      .read<DaysDataCubit>()
                                      .dayCustomersLoad(date);
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
        ),
      ),
    );
  }
}
