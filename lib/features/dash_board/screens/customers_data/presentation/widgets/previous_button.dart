import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key, required this.id});
  final bool id;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CustomersDataCubit>().previousPage(id);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      child: Text("Previous"),
    );
  }
}
