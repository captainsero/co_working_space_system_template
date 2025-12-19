import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class TableHeader extends StatelessWidget {
  final String text;

  const TableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p2),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
