import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';

class PartnershipTable extends StatelessWidget {
  final List<OfferClass> offers;
  const PartnershipTable({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: Text(
          "No offers found",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return SingleChildScrollView(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(1.5),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            children: [
              TableHeader("Name"),
              TableHeader("Code"),
              TableHeader("Description"),
              Center(child: TableHeader("Type")),
              Center(child: TableHeader("Usage")),
              TableHeader("Actions"),
            ],
          ),
          ...offers.map(
            (offer) => TableRow(
              children: [
                TableCell1(offer.name),
                TableCell1(offer.code),
                TableCell1(offer.description),
                Center(child: TableCell1(offer.type)),
                Center(child: TableCell1(offer.usage)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<PartnerShipCubit>().deleteOffer(
                          offer.code,
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                        size: AppSize.s7,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<PartnerShipCubit>().toggleActive(
                          offer.code,
                        );
                      },
                      icon: Icon(
                        offer.active ? Icons.toggle_on : Icons.toggle_off,
                        color: offer.active
                            ? ColorManager.green
                            : ColorManager.grey,
                        size: AppSize.s7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
