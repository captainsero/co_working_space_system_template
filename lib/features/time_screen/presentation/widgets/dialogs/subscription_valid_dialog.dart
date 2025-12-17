import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:toastification/toastification.dart';

class SubscriptionValidDialog extends StatelessWidget {
  const SubscriptionValidDialog({
    super.key,
    required this.remaining,
    required this.remText,
    required this.sub,
    required this.number,
    required this.numberController,
  });

  final Duration remaining;
  final String remText;
  final SubscriptionModel sub;
  final String number;
  final TextEditingController numberController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${sub.plan} Subscription", textAlign: TextAlign.center),
      content: SizedBox(
        height: ScreenSize.height / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "End Date : ${StringExtensions.formatDate(sub.endDate)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              "Days remaining : ${remaining.inDays} days",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              sub.planHours == 0
                  ? "Unlimited Time"
                  : "Time remaining: $remText",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final newUser = await SupabaseInTeam.insertInTeam(
              context: context,
              number: number,
              isSub: true,
            );
            if (newUser != null) {
              BlocProvider.of<InTeamCubit>(context).loadUsers();
              numberController.clear();
              ModernToast.showToast(
                context,
                'Success',
                'User added successfully',
                ToastificationType.success,
              );
              await Hive.openBox<CheckoutItems>(number);
            } else {
              ModernToast.showToast(
                context,
                'Error',
                'User not found',
                ToastificationType.error,
              );
            }
            Navigator.pop(context);
          },
          child: Text("Add User"),
        ),
      ],
    );
  }
}
