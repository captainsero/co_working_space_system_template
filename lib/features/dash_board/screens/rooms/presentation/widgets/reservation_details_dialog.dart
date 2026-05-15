import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';

class ReservationDetailsDialog extends StatelessWidget {
  const ReservationDetailsDialog({super.key, required this.reservation});
  final ReservationModel reservation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reservation Details',
        style: Theme.of(context).textTheme.titleLarge,
      ),

      content: SizedBox(
        width: ScreenSize.width / 2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSize.s4,
            children: [
              _detailRow(context, title: 'Name', value: reservation.name),

              _detailRow(context, title: 'Number', value: reservation.number),

              _detailRow(context, title: 'Room', value: reservation.room),

              _detailRow(
                context,
                title: 'Date',
                value: StringExtensions.formatDate(reservation.date),
              ),

              _detailRow(
                context,
                title: 'Time',
                value:
                    '${reservation.from.format(context)}'
                    ' - '
                    '${reservation.to.format(context)}',
              ),

              _detailRow(
                context,
                title: 'Price',
                value: reservation.price.toStringAsFixed(2),
              ),

              _detailRow(
                context,
                title: 'People',
                value: reservation.people.toString(),
              ),

              _detailRow(
                context,
                title: 'Client Type',
                value: reservation.clientType,
              ),

              _detailRow(
                context,
                title: 'Description',
                value: reservation.description.trim().isEmpty
                    ? 'No Description'
                    : reservation.description,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tools', style: Theme.of(context).textTheme.titleMedium),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reservation.tools.isEmpty
                        ? [const Text('No Tools')]
                        : reservation.tools
                              .map((tool) => Chip(label: Text(tool.toString())))
                              .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

Widget _detailRow(
  BuildContext context, {
  required String title,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: AppSize.s40,
        child: Text('$title:', style: Theme.of(context).textTheme.titleMedium),
      ),

      Expanded(
        child: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    ],
  );
}
