import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class ItemStatus extends StatelessWidget {
  const ItemStatus({super.key, required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    IconData icon;

    if (quantity > 5) {
      // Active
      label = "in Stock";
      color = ColorManager.green;
      icon = Icons.check;
    } else if (quantity <= 0) {
      // Upcoming
      label = "Critical";
      color = ColorManager.error;
      icon = Icons.remove;
    } else {
      // Ended
      label = "Low Stock";
      color = ColorManager.orange; // can swap with yellow if you prefer
      icon = Icons.notification_important_rounded;
    }

    return Container(
      // width: AppSize.s20,
      height: AppSize.s10,
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        border: Border.all(color: color, width: AppSize.s0_5),
        borderRadius: BorderRadius.circular(RadiusSize.r8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSize.s1,
        children: [
          Icon(icon, color: color, size: AppSize.s7),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
