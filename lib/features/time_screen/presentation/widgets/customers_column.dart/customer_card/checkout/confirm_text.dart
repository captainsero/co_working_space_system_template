import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class ConfirmText extends StatelessWidget {
  const ConfirmText({super.key, required this.priceController});

  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width / 5,
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        controller: priceController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        decoration: InputDecoration(hintText: "Confirm The Price"),
      ),
    );
  }
}
