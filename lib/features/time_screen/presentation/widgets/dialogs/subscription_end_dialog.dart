import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:toastification/toastification.dart';

class SubscriptionEndedDialog extends StatelessWidget {
  const SubscriptionEndedDialog({
    super.key,
    required this.sub,
    required this.number,
    required this.numberController,
  });

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "⚠ Subscription Ended",
              style: getBoldStyle(
                color: Theme.of(context).colorScheme.error,
                fontFamily: FontConstants.libertinusFamily,
                fontSize: FontSize.s8,
              ),
            ),
            Text(
              "End Date : ${StringExtensions.formatDate(sub.endDate)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              "Plan Time : ${sub.planHours} h",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              "Time Spent : ${StringExtensions.formatMinutesToHoursMinutes(sub.hours)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            await SupabaseSubscriptions.deleteSubscription(sub.number);
            final newUser = await SupabaseInTeam.insertInTeam(
              context: context,
              number: number,
              isSub: false,
            );
            if (newUser != null) {
              BlocProvider.of<InTeamCubit>(context).loadUsers();
              numberController.clear();
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
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: ColorManager.green),
          onPressed: () async {
            await SupabaseSubscriptions.deleteSubscription(sub.number);
            ModernToast.showToast(
              context,
              'Warning',
              "Update the user subscription from Dashboard",
              ToastificationType.warning,
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Update"),
        ),
      ],
    );
  }
}
