import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/presentation/widgets/partnership_form.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/presentation/widgets/partnership_table.dart';

class PartnershipScreen extends StatefulWidget {
  const PartnershipScreen({super.key});

  @override
  State<PartnershipScreen> createState() => _PartnershipScreenState();
}

class _PartnershipScreenState extends State<PartnershipScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Partnerships"),

          /// Add Offer Form
          PartnershipForm(),

          /// Offers Table
          Container(
            height: ScreenSize.height / 2,
            padding: EdgeInsets.all(AppPadding.p4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocBuilder<PartnerShipCubit, PartnerShipState>(
              builder: (context, state) {
                if (state is PartnerShipLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PartnerShipLoadOffers) {
                  return PartnershipTable(offers: state.offers);
                } else {
                  return const Center(
                    child: Text("Press reload to fetch offers"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
