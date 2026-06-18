part of 'month_data_cubit.dart';

sealed class MonthDataState extends Equatable {
  const MonthDataState();

  @override
  List<Object> get props => [];
}

final class MonthDataInitial extends MonthDataState {}

class GetMonthlyTotal extends MonthDataState {
  final List<double> total;
  final List<double> expensesTotal;
  final List<double> itemsTotal;
  final List<double> roomsTotal;

  const GetMonthlyTotal({
    required this.total,
    required this.expensesTotal,
    required this.itemsTotal,
    required this.roomsTotal,
  });
  @override
  List<Object> get props => [total, expensesTotal, itemsTotal, roomsTotal];
}

class GetMonthTotals extends MonthDataState {
  final int year;
  final int month;
  final List<double> total;
  final List<ExpensesModel> expensesTotal;
  final double itemsTotal;
  final double roomsTotal;

  const GetMonthTotals({
    required this.year,
    required this.month,
    required this.total,
    required this.expensesTotal,
    required this.itemsTotal,
    required this.roomsTotal,
  });

  @override
  List<Object> get props => [
    year,
    month,
    total,
    expensesTotal,
    itemsTotal,
    roomsTotal,
  ];
}

class YearlyTotalsLoaded extends MonthDataState {
  final int year;
  final List<double> monthlyTotals;

  const YearlyTotalsLoaded({required this.year, required this.monthlyTotals});

  @override
  List<Object> get props => [year, monthlyTotals];
}

class Loading extends MonthDataState {}
