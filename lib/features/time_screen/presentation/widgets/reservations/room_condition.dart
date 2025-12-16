import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class RoomCondition extends StatelessWidget {
  const RoomCondition({super.key, required this.from, required this.to});

  final TimeOfDay from;
  final TimeOfDay to;

  /// Convert TimeOfDay to minutes since midnight
  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.fromDateTime(DateTime.now());
    final nowMinutes = _toMinutes(now);
    final fromMinutes = _toMinutes(from);
    final toMinutes = _toMinutes(to);

    String label;
    Color color;
    IconData icon;

    if (nowMinutes >= fromMinutes && nowMinutes <= toMinutes) {
      // Active
      label = "Active";
      color = ColorManager.green;
      icon = Icons.check_circle;
    } else if (nowMinutes < fromMinutes) {
      // Upcoming
      label = "Upcoming";
      color = ColorManager.blue;
      icon = Icons.access_time;
    } else {
      // Ended
      label = "Ended";
      color = ColorManager.orange; // can swap with yellow if you prefer
      icon = Icons.stop_circle;
    }

    return Container(
      padding: EdgeInsets.all(AppPadding.p2),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        border: Border.all(color: color, width: AppSize.s0_5),
        borderRadius: BorderRadius.circular(RadiusSize.r12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSize.s1,
        children: [
          Icon(icon, color: color, size: AppSize.s5),
          Text(
            label,
            style: getSemiBoldStyle(
              color: color,
              fontFamily: FontConstants.libertinusFamily,
              fontSize: FontSize.s5,
            ),
          ),
        ],
      ),
    );
  }
}
