import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/add_subscription.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/plans_table.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/subscription_table.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';

class Subsciptions extends StatefulWidget {
  const Subsciptions({super.key});

  @override
  State<Subsciptions> createState() => _SubsciptionsState();
}

class _SubsciptionsState extends State<Subsciptions> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Subsciptions"),

          AddSubscription(),

          Container(
            height: ScreenSize.height / 2.5,
            padding: EdgeInsets.all(AppPadding.p4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(RadiusSize.r16),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.s3,
                children: [
                  IconAndText(
                    text: "Manage Subscriptions",
                    icon: Icons.manage_accounts,
                  ),

                  SubscriptionTable(),
                ],
              ),
            ),
          ),

          Container(
            height: ScreenSize.height / 2.5,
            padding: EdgeInsets.all(AppPadding.p4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(RadiusSize.r16),
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: AppSize.s3,
                children: [
                  IconAndText(text: "Mannage Plans", icon: Icons.edit_square),

                  PlansTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
