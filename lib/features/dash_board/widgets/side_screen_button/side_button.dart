import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class SideButton extends StatelessWidget {
  const SideButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onpressed,
    required this.isChanged,
  });

  final String label;
  final IconData icon;
  final VoidCallback onpressed;
  final bool isChanged;

  @override
  Widget build(BuildContext context) {
    return isChanged
        ? ElevatedButton.icon(
            onPressed: onpressed,
            icon: Icon(icon, size: AppSize.s6),
            label: Text(label, style: TextStyle(fontSize: FontSize.s7)),
          )
        : TextButton.icon(
            onPressed: onpressed,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}
