import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/delete_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/pay_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart';

// ignore: must_be_immutable
class CheckoutDialog extends StatefulWidget {
  CheckoutDialog({
    super.key,
    required this.baseTotal,
    required this.offerDis,
    required this.finalTotal,
    required this.priceController,
    required this.durationString,
    required this.timeSpent,
    required this.user,
    required this.hours,
  });

  final double baseTotal;
  String offerDis;
  double finalTotal;
  final TextEditingController priceController;
  final String durationString;
  final int timeSpent;
  final InTeamUsers user;
  final double hours;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  String? selectedOfferId;
  List<OfferClass> offers = [];

  @override
  void initState() {
    super.initState();
    applyOffers();
  }

  Future<void> applyOffers() async {
    final result = await SupabasePartnership.getAllActiveOffers();
    setState(() {
      offers = result;
    });
  }

  void applyOfferToState(OfferClass offer2) {
    final newTotal = TimeScreenLogic.applyOffer(
      widget.baseTotal,
      widget.hours,
      offer2,
    );

    setState(() {
      widget.finalTotal = newTotal;
      if (widget.user.isSub) {
        widget.offerDis = "Subscribed And ${offer2.description}";
      } else {
        widget.offerDis = offer2.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price: ${widget.baseTotal} EGP",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Text(
                "Offer: ${widget.offerDis}",
                style: getRegularStyle(
                  color: ColorManager.green,
                  fontFamily: FontConstants.libertinusFamily,
                  fontSize: FontSize.s8,
                ),
              ),
            ],
          ),

          Spacer(),
          SizedBox(
            width: ScreenSize.width / 5.5,
            child: DropdownButtonFormField<String>(
              initialValue: selectedOfferId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              hint: const Text("Select Offer"),
              items: offers
                  .map(
                    (offer) => DropdownMenuItem<String>(
                      value: offer.code, // or offer.name
                      child: Text(offer.name), // visible text
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                final selected = offers.firstWhere(
                  (o) => o.code == value,
                ); // same key as above
                selectedOfferId = value;
                applyOfferToState(selected);
              },
              validator: (value) {
                // if you want it required:
                // if (value == null || value.isEmpty) return 'Please select an offer';
                return null;
              },
            ),
          ),
          Spacer(),

          Text(
            "Price After Offer = ${widget.finalTotal} EGP",
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
                widget.user.name,
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
                    priceController: widget.priceController,
                    hoursFee: widget.finalTotal,
                    number: widget.user.number,
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
                ItemsContainer(user: widget.user.number),
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
              priceController: widget.priceController,
              user: widget.user,
              time: widget.durationString,
              timespent: widget.timeSpent,
            ),

            const Spacer(),

            CancelButton(),

            const SizedBox(width: 12),

            DeleteButton(number: widget.user.number),
          ],
        ),
      ],
    );
  }
}
