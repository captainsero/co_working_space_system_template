import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({super.key, required this.text, required this.icon});

  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSize.s2,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
