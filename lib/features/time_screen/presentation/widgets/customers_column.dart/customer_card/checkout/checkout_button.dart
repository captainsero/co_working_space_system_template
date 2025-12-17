import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/delete_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/pay_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart'
    show TotalCheckoutColumn;

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({super.key, required this.timer, required this.user});
  final DateTime timer;
  final InTeamUsers user;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    ScreenSize.intial(context);
    return TextButton.icon(
      onPressed: () async {
        await Hive.openBox<CheckoutItems>(widget.user.number);
        final now = DateTime.now();
        final duration = now.difference(widget.timer);
        double hours = duration.inMinutes / 60;
        final shours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        final durationString = '$shours:$minutes:$seconds';
        final int timeSpent = duration.inMinutes;

        double baseTotal = (hours * Validators.hourFee).roundToDouble();
        if (baseTotal > 80) {
          baseTotal = 80;
        }

        if (widget.user.isSub) {
          final sub = await SupabaseSubscriptions.getSubscriptionByNumber(
            widget.user.number,
          );
          final int planMin = sub!.planHours * 60;

          if (timeSpent + sub.hours > planMin && planMin != 0) {
            final totalTime = (timeSpent + sub.hours) - planMin;
            baseTotal = totalTime / 60 * Validators.hourFee;
            hours = totalTime / 60;
          } else {
            baseTotal = 0;
            hours = 0;
          }
        }
        final offer = await SupabasePartnership.getOfferByCode(
          widget.user.partnershipCode,
        );
        final finalTotal = TimeScreenLogic.applyOffer(baseTotal, hours, offer);
        late String offerDis;
        if (widget.user.isSub && offer != null) {
          offerDis = "Subscribed And ${offer.description}";
        } else {
          offerDis = widget.user.isSub
              ? "Subscribed"
              : (offer != null ? offer.description : "No Offer");
        }

        context.read<TimeScreenCubit>().getTotal(Validators.choosenDay);

        showDialog(
          context: context,
          builder: (_) {
            return BlocBuilder<TimeScreenCubit, TimeScreenState>(
              builder: (context, state) {
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(50),
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
                          priceController: priceController,
                          user: widget.user,
                          time: durationString,
                          timespent: timeSpent,
                        ),

                        const Spacer(),

                        CancelButton(),

                        const SizedBox(width: 12),

                        DeleteButton(number: widget.user.number),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      icon: Icon(Icons.logout),
      label: Text("Checkout"),
    );
  }
}
