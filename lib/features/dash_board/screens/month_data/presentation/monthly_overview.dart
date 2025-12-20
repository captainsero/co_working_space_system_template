import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/month_data/logic/cubit/month_data_cubit.dart';

class MonthlyOverview extends StatefulWidget {
  const MonthlyOverview({super.key});

  @override
  State<MonthlyOverview> createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview>
    with WidgetsBindingObserver {
  late int selectedYear;
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    _loadYearData(selectedYear);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadYearData(selectedYear); // reload when screen resumes
    }
  }

  void _loadYearData(int year) {
    context.read<MonthDataCubit>().getMonthlyTotal(year);
  }

  @override
  Widget build(BuildContext context) {
    final int startYear = 2024;
    final int endYear = DateTime.now().year + 1;
    final List<int> years = List.generate(
      endYear - startYear + 1,
      (index) => startYear + index,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(AppPadding.p4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(RadiusSize.r16),
            ),
            child: DropdownButton<int>(
              value: selectedYear,
              dropdownColor: Theme.of(context).colorScheme.primary,
              style: Theme.of(context).textTheme.titleMedium,
              items: years
                  .map(
                    (year) => DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (int? newYear) {
                if (newYear != null && newYear != selectedYear) {
                  selectedYear = newYear;
                  _loadYearData(selectedYear); // reload data on year change
                  setState(() {});
                }
              },
            ),
          ),
        ),

        Expanded(
          child: BlocBuilder<MonthDataCubit, MonthDataState>(
            builder: (context, state) {
              if (state is GetMonthlyTotal) {
                final totals = state.total;
                final expensesTotals = state.expensesTotal;

                return ListView.builder(
                  // padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final total = totals.length > index ? totals[index] : 0.0;
                    final expensesTotal = expensesTotals.length > index
                        ? expensesTotals[index]
                        : 0.0;
                    final difference = total - expensesTotal;

                    return GestureDetector(
                      onTap: () async {
                        setState(() => selectedMonth = month);
                        await context.read<MonthDataCubit>().getMonthTotals(
                          selectedYear,
                          month,
                        );
                        _showMonthDetailsDialog(
                          context.read<MonthDataCubit>().state,
                          month,
                          selectedYear,
                        );
                      },
                      child: Container(
                        width: ScreenSize.width / 1.5,
                        height: ScreenSize.height / 2.5,
                        margin: EdgeInsets.all(AppMargin.m4),
                        padding: EdgeInsets.all(AppPadding.p4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(RadiusSize.r16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSize.s3,
                          children: [
                            Text(
                              '${_monthName(month)} $selectedYear',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            _buildRow('Total', total),
                            _buildRow('Expenses', expensesTotal),
                            Divider(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimary.withAlpha(150),
                            ),
                            _buildRow('Difference', difference),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              // Add special case for initial loading spinner
              if (state is Loading) {
                return Center(child: CircularProgressIndicator());
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _showMonthDetailsDialog(
    MonthDataState state,
    int month,
    int year,
  ) async {
    List<double> dailyTotals = [];
    List<ExpensesModel> expensesList = [];

    if (state is GetMonthTotals) {
      dailyTotals = state.total;
      expensesList = state.expensesTotal;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Details for ${_monthName(month)} $selectedYear'),
        content: SizedBox(
          width: ScreenSize.width / 1.5,
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildScrollView(
                  child: Column(
                    spacing: AppSize.s3,
                    children: [
                      Text(
                        'Daily Totals:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      ...dailyTotals.asMap().entries.map((e) {
                        int dayNum = e.key + 1;
                        double value = e.value;
                        return Text(
                          'Day $dayNum: ${value.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        );
                      }),
                    ],
                  ),
                ),

                SizedBox(width: AppSize.s5),

                Column(
                  spacing: AppSize.s3,
                  children: [
                    Text(
                      'Expenses:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    ...expensesList.map((expense) {
                      return Text(
                        '${expense.name}: ${expense.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    }),
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
      ),
    );
    context.read<MonthDataCubit>().getMonthlyTotal(year);
  }
}
