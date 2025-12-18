import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/custom_barcode.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/card_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/partnership_future_builder.dart';

class CustomerCardDashboard extends StatelessWidget {
  const CustomerCardDashboard({super.key, required this.teamData});

  final List<Map<String, dynamic>> teamData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        physics: const BouncingScrollPhysics(),
        itemCount: teamData.length,
        itemBuilder: (context, index) {
          final item = teamData[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: AppMargin.m4),
            child: Padding(
              padding: EdgeInsets.all(AppPadding.p4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        item["name"] ?? "",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: AppSize.s2),

                      CardText(text: "Number", itemText: item['number'] ?? ''),

                      CardText(
                        text: "collage",
                        itemText: item['collage'] ?? '',
                      ),

                      CardText(
                        text: "Total Time",
                        itemText: StringExtensions.formatTime(
                          item["total_time"],
                        ),
                      ),

                      PartnershipFutureBuilder(item: item),
                    ],
                  ),

                  CustomBarcode(number: item['number'].toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
