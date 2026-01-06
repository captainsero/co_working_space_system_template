import 'package:flutter_bloc/flutter_bloc.dart';

// State holds whether to sort by ID (true) or Total Hours (false)
class SortingState {
  final bool sortById;
  const SortingState(this.sortById);
}

class SortingCubit extends Cubit<SortingState> {
  // Default to sorting by ID
  SortingCubit() : super(const SortingState(true));

  void sortById() {
    emit(const SortingState(true));
  }

  void sortByTotalHours() {
    emit(const SortingState(false));
  }
}
