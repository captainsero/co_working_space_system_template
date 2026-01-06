import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/sorting_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/customer_card_dashboard.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/error_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/next_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/page_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/press_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/previous_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/search_person_button.dart';

class CustomersData extends StatefulWidget {
  const CustomersData({
    super.key,
    required this.isLoading,
    required this.error,
    required this.teamData,
  });

  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> teamData;

  @override
  State<CustomersData> createState() => _CustomersDataState();
}

class _CustomersDataState extends State<CustomersData> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortingCubit, SortingState>(
      builder: (context, sortingState) {
        return Column(
          children: [
            HeadText(text: "Customers Data"),

            SizedBox(height: AppSize.s5),

            Align(
              alignment: Alignment.topLeft,
              child: Row(
                spacing: AppSize.s10,
                children: [
                  PreviousButton(id: Validators.sortById),

                  PageText(),

                  NextButton(id: Validators.sortById),

                  // Sort by ID Button
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sortingState.sortById
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.transparent,
                        ),
                        onPressed: () {
                          context.read<SortingCubit>().sortById();
                          context.read<CustomersDataCubit>().loadPage(0, true);
                          Validators.sortById = true;
                        },
                        child: Text(
                          "Sort by ID",
                          style: sortingState.sortById
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !sortingState.sortById
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.transparent,
                        ),
                        onPressed: () {
                          context.read<SortingCubit>().sortByTotalHours();
                          context.read<CustomersDataCubit>().loadPage(0, false);
                          Validators.sortById = false;
                        },
                        child: Text(
                          "Sort by Total Hours",
                          style: !sortingState.sortById
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),

                  // Sort by Total Hours Button
                  const Spacer(),

                  SearchPersonButton(),
                ],
              ),
            ),

            SizedBox(height: AppSize.s5),

            if (widget.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (widget.error != null) ErrorText(error: widget.error),

            if (!widget.isLoading &&
                widget.error == null &&
                widget.teamData.isEmpty)
              PressText(),

            if (!widget.isLoading &&
                widget.error == null &&
                widget.teamData.isNotEmpty)
              CustomerCardDashboard(teamData: widget.teamData),
          ],
        );
      },
    );
  }
}
