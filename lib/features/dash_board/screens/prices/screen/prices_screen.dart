import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_expenses.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/edit_hour_fee.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_room.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_position.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_subscription_plan.dart';

class PricesScreen extends StatelessWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                spacing: AppSize.s5,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeadText(text: "Prices"),

                  Row(children: [AddRoom(), Spacer(), AddPosition()]),

                  Row(
                    children: [
                      AddSubscriptionPlan(),
                      Spacer(),
                      Column(
                        spacing: AppSize.s5,
                        children: [EditHourFee(), AddExpenses()],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
