import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_expenses.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/presentation/widgets/checkin_checkout.dart';

class StuffScreen extends StatefulWidget {
  const StuffScreen({super.key});

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSize.s5,
      children: [
        HeadText(text: "Staff"),
        CheckinCheckout(),
        AddExpenses(),

        // OurStuff(),
      ],
    );
  }
}
