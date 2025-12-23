import 'package:flutter/material.dart';
// import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class PartnershipFutureBuilder extends StatelessWidget {
  const PartnershipFutureBuilder({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TimeScreenLogic.getPartnerShipName(item['partnership_code']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Partnership: Loading...",
            style: Theme.of(context).textTheme.bodyMedium,
          );
        } else if (snapshot.hasError) {
          return Text(
            "Partnership: Error",
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else {
          return Text(
            "Partnership: ${snapshot.data}",
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }
      },
    );
  }
}
