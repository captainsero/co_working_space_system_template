import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';

class PriceContainer extends StatelessWidget {
  const PriceContainer({
    super.key,
    required this.total,
    required this.isVisible,
  });

  final double total;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: AppSize.s10,
                ),
                SizedBox(width: AppSize.s2),
                Text(
                  "Total Salary Today",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<TimeScreenCubit>().toggleTotalVisibility();
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: AppSize.s10,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.s5),

            ImageFiltered(
              imageFilter: isVisible
                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                  : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Text(
                "$total EGP",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            SizedBox(height: AppSize.s5),

            Text(
              "From active sessions and room reservations",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
