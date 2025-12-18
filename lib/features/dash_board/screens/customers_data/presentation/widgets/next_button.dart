import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CustomersDataCubit>().nextPage();
      },
      child: Text("Next"),
    );
  }
}
