import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class PlansTable extends StatelessWidget {
  const PlansTable({super.key});

  @override
  Widget build(BuildContext context) {
    List<SubscriptionPlanModel> plans = [];
    return BlocBuilder<PlansCubit, PlansState>(
      builder: (context, state) {
        if (state is PlansInitial || state is PlansLoading) {
          return CircularProgressIndicator();
        } else if (state is GetPlans) {
          plans = state.plans;
        }
        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(3),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                TableHeader("Name"),
                TableHeader("Price"),
                TableHeader("Days"),
                Center(child: TableHeader("Subscriptions")),
                TableHeader("Hours"),
                Center(child: TableHeader("Actions")),
              ],
            ),
            for (var ele in plans)
              TableRow(
                children: [
                  TableCell1(ele.name),
                  TableCell1("${ele.price}"),
                  TableCell1("${ele.days}"),
                  Center(child: TableCell1(ele.subscriptionsNum)),
                  TableCell1(ele.hours == 0 ? 'Unlimited' : ele.hours),
                  BlocBuilder<PlansCubit, PlansState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          context.read<PlansCubit>().deletePlan(ele.name);
                          ModernToast.showToast(
                            context,
                            'Success',
                            "Plan deleted successfully",
                            ToastificationType.success,
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(AppPadding.p2),
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                            size: AppSize.s7,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
