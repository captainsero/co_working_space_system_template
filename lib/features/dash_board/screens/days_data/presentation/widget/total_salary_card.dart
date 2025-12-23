import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class TotalSalaryCard extends StatelessWidget {
  final double total;
  final double expenses;
  final double revenues;
  final String dateFormat;
  final double itemsTotal;

  const TotalSalaryCard({
    super.key,
    required this.total,
    required this.dateFormat,
    required this.expenses,
    required this.revenues,
    required this.itemsTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: AppSize.s0_5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: AppSize.s1,
            children: [
              Icon(
                Icons.attach_money_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSize.s7,
              ),

              Text(
                "Total Salary For $dateFormat",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Revenues: $revenues EGP",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                "Expenses: $expenses EGP",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                "Total: $total EGP",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),

          Text(
            "Items Revenues: $itemsTotal EGP",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
