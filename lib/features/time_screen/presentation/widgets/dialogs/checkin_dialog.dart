import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class CheckinDialog extends StatelessWidget {
  const CheckinDialog({super.key, required this.numberController});
  final TextEditingController numberController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(AppPadding.p8),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSize.s1,
          children: [
            Icon(
              Icons.move_to_inbox,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text("Enter Customer Number"),
          ],
        ),
      ),

      content: SizedBox(
        width: ScreenSize.width / 5,
        child: TextField(
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          controller: numberController,
          autofocus: true,
          onSubmitted: (_) =>
              TimeScreenLogic.tryInsertUser(context, numberController, true),
          decoration: InputDecoration(hintText: "Enter Number"),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel", style: Theme.of(context).textTheme.bodyLarge),
        ),

        ElevatedButton(
          onPressed: () =>
              TimeScreenLogic.tryInsertUser(context, numberController, true),
          child: Text("Add"),
        ),
      ],
    );
  }
}
