import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/add_person_button.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/checkin_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/checkout_on_screen.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/customer_card.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/search_bar.dart';

class CustomerColumn extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final Function(String) onSearchChanged;

  const CustomerColumn({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<CustomerColumn> createState() => _CustomerColumnState();
}

class _CustomerColumnState extends State<CustomerColumn> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Row(
            children: [
              // Search Bar
              SearchByNumber(
                searchController: widget.searchController,
                onSearchChanged: widget.onSearchChanged,
              ),

              const Spacer(),

              Column(
                children: [
                  AddPersonButton(),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      CheckoutOnScreen(),
                      SizedBox(width: 10),
                      CheckinButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          Expanded(
            child: BlocBuilder<InTeamCubit, InTeamState>(
              builder: (context, state) {
                final teamData = state.users;
                final filteredData = widget.searchQuery.isEmpty
                    ? teamData
                    : teamData
                          .where(
                            (user) => user.number.contains(widget.searchQuery),
                          )
                          .toList();

                if (filteredData.isEmpty) {
                  return Center(
                    child: Text(
                      "There Is No One At The Work Space",
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final sortedData = filteredData.reversed.toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortedData.length,
                  itemBuilder: (context, index) {
                    final item = sortedData[index];
                    return CustomerCard(item: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
