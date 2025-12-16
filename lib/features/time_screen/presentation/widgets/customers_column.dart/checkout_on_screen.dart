import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class CheckoutOnScreen extends StatelessWidget {
  const CheckoutOnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s44,
      child: ElevatedButton.icon(
        onPressed: () => TimeScreenLogic.checkoutButtonUser(context),

        icon: Icon(Icons.outbox_rounded),
        label: Text(
          "Checkout",
          style: TextStyle(fontSize: FontSize.s6),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
