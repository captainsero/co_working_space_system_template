import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  final VoidCallback onPick;

  const DatePickerButton({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: Icon(Icons.calendar_today),
      label: Text('Pick Date'),
    );
  }
}
