import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/month_data/data/supabase_month_data.dart';

part 'month_data_state.dart';

class MonthDataCubit extends Cubit<MonthDataState> {
  MonthDataCubit() : super(MonthDataInitial());

  GetMonthlyTotal? _cachedYearlyState;

  Future<void> getMonthlyTotal(int year) async {
    emit(Loading());

    List<double> totals = List.filled(12, 0.0);
    List<double> expensesTotals = List.filled(12, 0.0);
    List<double> itemsTotals = List.filled(12, 0.0); // ✅ NEW
    List<double> roomsTotals = List.filled(12, 0.0); // ✅ NEW

    // ✅ All 12 months fetched in parallel, each month fetches 4 values
    final futures = List.generate(12, (index) async {
      final month = index + 1;

      final results = await Future.wait([
        SupabaseMonthData.getMonthTotalFromDailyTotals(year, month),
        SupabaseMonthData.expensesMonthlyTotal(year, month),
        SupabaseMonthData.getMonthlyItemsTotal(year, month), // ✅ NEW
        SupabaseMonthData.getMonthlyRoomsTotal(year, month), // ✅ NEW
      ]);

      totals[index] = results[0];
      expensesTotals[index] = results[1];
      itemsTotals[index] = results[2];
      roomsTotals[index] = results[3];
    });

    await Future.wait(futures);

    _cachedYearlyState = GetMonthlyTotal(
      total: totals,
      expensesTotal: expensesTotals,
      itemsTotal: itemsTotals,
      roomsTotal: roomsTotals,
    );

    emit(_cachedYearlyState!);
  }

  Future<void> getMonthTotals(int year, int month) async {
    // ✅ All detail fetches run in parallel
    final results = await Future.wait([
      SupabaseMonthData.getMonthlyTotalDetails(year, month),
      SupabaseMonthData.getMonthlyExpenses(year, month),
      SupabaseMonthData.getMonthlyItemsTotal(year, month), // ✅ NEW
      SupabaseMonthData.getMonthlyRoomsTotal(year, month), // ✅ NEW
    ]);

    emit(
      GetMonthTotals(
        year: year,
        month: month,
        total: results[0] as List<double>,
        expensesTotal: results[1] as List<ExpensesModel>,
        itemsTotal: results[2] as double,
        roomsTotal: results[3] as double,
      ),
    );
  }

  void restoreYearlyState() {
    if (_cachedYearlyState != null) {
      emit(_cachedYearlyState!);
    }
  }
}
