import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart'
    show TotalCheckoutColumn;
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/reservations/checkout/reservation_pay_button.dart';

class ReservationCheckout extends StatefulWidget {
  const ReservationCheckout({super.key, required this.res});
  final ReservationModel res;

  @override
  State<ReservationCheckout> createState() => _ReservationCheckoutState();
}

class _ReservationCheckoutState extends State<ReservationCheckout> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    ScreenSize.intial(context);
    return TextButton.icon(
      onPressed: () async {
        await Hive.openBox<CheckoutItems>(widget.res.id!.toString());
        showDialog(
          context: context,
          builder: (_) {
            return BlocBuilder<TimeScreenCubit, TimeScreenState>(
              builder: (context, state) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Text(
                        "Price: ${widget.res.price} EGP",
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
                            widget.res.name,
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
                                hoursFee: widget.res.price,
                                number: widget.res.id!.toString(),
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

                            ItemsContainer(user: widget.res.id!.toString()),
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
                        ReservationPayButton(
                          priceController: priceController,
                          res: widget.res,
                        ),

                        const Spacer(),

                        CancelButton(),
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
