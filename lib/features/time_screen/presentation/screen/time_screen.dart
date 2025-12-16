import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/screen/app_bar_main.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customers_column.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/price_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/reservations/today_rev_container.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTotal();
  }

  void _loadTotal() async {
    total = await SupabaseInTeam.getTotal(Validators.choosenDay);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.p12),
        child: Row(
          children: [
            // Customers
            CustomerColumn(
              searchController: _searchController,
              searchQuery: searchQuery,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(left: AppPadding.p12),
                child: Column(
                  children: [
                    BlocBuilder<TimeScreenCubit, TimeScreenState>(
                      builder: (context, state) {
                        final total = (state is GetTotal)
                            ? state.total
                            : this.total;

                        return PriceContainer(total: total);
                      },
                    ),

                    SizedBox(height: AppSize.s10),
                    TodayRevContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
