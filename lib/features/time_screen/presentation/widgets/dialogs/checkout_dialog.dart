import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/delete_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/pay_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({
    super.key,
    required this.baseTotal,
    required this.offerDis,
    required this.finalTotal,
    required this.priceController,
    required this.durationString,
    required this.timeSpent,
    required this.user,
  });

  final double baseTotal;
  final String offerDis;
  final double finalTotal;
  final TextEditingController priceController;
  final String durationString;
  final int timeSpent;
  final InTeamUsers user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price: $baseTotal EGP",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                "Offer: $offerDis",
                style: getRegularStyle(
                  color: ColorManager.green,
                  fontFamily: FontConstants.libertinusFamily,
                  fontSize: FontSize.s8,
                ),
              ),
            ],
          ),

          Spacer(),

          Text(
            "Price After Offer = $finalTotal EGP",
            style: Theme.of(context).textTheme.headlineLarge,
          ),

          Spacer(),

          Column(
            spacing: AppSize.s1,
            children: [
              Icon(
                Icons.shopping_cart_checkout,
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSize.s12,
              ),

              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ],
      ),

      content: SizedBox(
        width: ScreenSize.width / 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
              thickness: AppSize.s0_5,
            ),

            SizedBox(height: AppSize.s4),

            Row(
              children: [
                SizedBox(
                  width: ScreenSize.width / 5,
                  height: ScreenSize.height / 1.8,
                  child: TotalCheckoutColumn(
                    priceController: priceController,
                    hoursFee: finalTotal,
                    number: user.number,
                  ),
                ),

                SizedBox(
                  height: ScreenSize.height / 1.8,
                  child: VerticalDivider(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withAlpha(50),
                    thickness: AppSize.s0_5,
                  ),
                ),

                Spacer(),
                ItemsContainer(user: user.number),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.only(
        top: AppPadding.p0,
        left: AppPadding.p12,
        bottom: AppPadding.p4,
        right: AppPadding.p12,
      ),
      actions: [
        Row(
          children: [
            PayButton(
              priceController: priceController,
              user: user,
              time: durationString,
              timespent: timeSpent,
            ),

            const Spacer(),

            CancelButton(),

            const SizedBox(width: 12),

            DeleteButton(number: user.number),
          ],
        ),
      ],
    );
  }
}
