import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/checkout_button.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/note_button/note_button.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.item});

  final InTeamUsers item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p4),
        child: Row(
          // 🔥 Main row: left info + right buttons
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT SIDE (all texts)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.s2,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  // Phone & collage row
                  Row(
                    spacing: AppSize.s5,
                    children: [
                      IconAndText(
                        icon: Icons.phone_outlined,
                        text: item.number,
                      ),
                      Row(
                        spacing: AppSize.s2,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(
                            width: AppSize.s55,
                            child: Text(
                              item.collage,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Timer text
                  Row(
                    spacing: AppSize.s5,
                    children: [
                      Text(
                        StringExtensions.getElapsedTime(item.timer),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      FutureBuilder<String>(
                        future: TimeScreenLogic.getPartnerShipName(
                          item.partnershipCode,
                        ),
                        builder: (context, snapshot) {
                          return IconAndText(
                            icon: Icons.group,
                            text: snapshot.data ?? "No Partnership",
                          );
                        },
                      ),
                    ],
                  ),

                  Text(
                    "Time Active",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),

            // RIGHT SIDE (Note + Checkout buttons stacked vertically)
            Column(
              children: [
                NoteButton(
                  name: item.name,
                  number: item.number,
                  collage: item.collage,
                  parntershipCode: item.partnershipCode,
                ),

                SizedBox(height: AppSize.s20),

                CheckoutButton(user: item, timer: item.timer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
