import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class PriceContainer extends StatelessWidget {
  const PriceContainer({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: AppSize.s0_5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: AppSize.s10,
                ),
                SizedBox(width: AppSize.s2),
                Text(
                  "Total Salary Today",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),

            SizedBox(height: AppSize.s5),

            Text("$total EGP", style: Theme.of(context).textTheme.titleMedium),

            SizedBox(height: AppSize.s5),

            Text(
              "From active sessions and room reservations",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }
}
