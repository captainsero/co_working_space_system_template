import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/oreded_items_column.dart';

class TotalCheckoutColumn extends StatelessWidget {
  const TotalCheckoutColumn({
    super.key,
    required this.priceController,
    required this.hoursFee,
    required this.number,
  });

  final TextEditingController priceController;
  final double hoursFee;
  final String number;

  @override
  Widget build(BuildContext context) {
    final totalBox = Hive.box<double>('itemsTotal');
    return Column(
      children: [
        OrderedItemsColumn(user: number),

        SizedBox(
          width: ScreenSize.width / 5,
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
            thickness: AppSize.s0_5,
          ),
        ),

        Spacer(flex: 2),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hours Fee:", style: Theme.of(context).textTheme.titleSmall),
            Text("\$$hoursFee", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),

        Spacer(flex: 1),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Items Fee:", style: Theme.of(context).textTheme.titleSmall),

            ValueListenableBuilder<Box<double>>(
              valueListenable: totalBox.listenable(),
              builder: (context, box, _) {
                final itemsTotal = box.get('${number}total');
                return Text(
                  "\$$itemsTotal",
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
          ],
        ),

        SizedBox(
          width: ScreenSize.width / 5,
          child: Divider(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
            thickness: AppSize.s0_5,
          ),
        ),

        Spacer(flex: 1),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total:", style: Theme.of(context).textTheme.titleMedium),

            ValueListenableBuilder<Box<double>>(
              valueListenable: totalBox.listenable(),
              builder: (context, box, _) {
                final itemsTotal = box.get('${number}total');
                double? total;

                if (itemsTotal == null) {
                  total = 0.0;
                } else {
                  total = itemsTotal + hoursFee;
                }
                return Text(
                  "\$$total",
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
          ],
        ),

        Spacer(flex: 2),
        
        ConfirmText(priceController: priceController),
      ],
    );
  }
}
