import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class ChekcoutButtonDialog extends StatelessWidget {
  const ChekcoutButtonDialog({
    super.key,
    required this.numberController,
    required this.perantcontext,
    required this.dialogCtx,
  });
  final TextEditingController numberController;
  final BuildContext perantcontext;
  final BuildContext dialogCtx;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(AppPadding.p8),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSize.s1,
          children: [
            Icon(Icons.outbox, color: Theme.of(context).colorScheme.onPrimary),
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
          onSubmitted: (_) async {
            Navigator.pop(dialogCtx);
            await TimeScreenLogic.tryCheckoutUser(
              perantcontext,
              numberController,
            );
          },
          decoration: InputDecoration(hintText: "Enter Number"),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(perantcontext).pop(),
          child: Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogCtx);
            await TimeScreenLogic.tryCheckoutUser(
              perantcontext,
              numberController,
            );
          },

          child: const Text("Checkout"),
        ),
      ],
    );
  }
}
