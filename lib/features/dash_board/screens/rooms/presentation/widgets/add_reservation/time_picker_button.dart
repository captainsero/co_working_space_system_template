import 'package:flutter/material.dart';

class TimePickerButton extends StatelessWidget {
  final VoidCallback onPick;
  final String title;

  const TimePickerButton({
    super.key,
    required this.onPick,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: Icon(Icons.watch_later_rounded),
      label: Text(title),
    );
  }
}
