import 'package:bloc/bloc.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/core/models/reservation_date_model.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_reservations.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(const ReservationState());

  /// ========================
  /// GET RESERVATIONS
  /// ========================
  void getResByDate({required DateTime date}) async {
    emit(state.copyWith(isLoading: true));

    final reservationsByDate = await SupabaseReservations.getRevByDate(date);

    emit(
      state.copyWith(isLoading: false, reservationsByDate: reservationsByDate),
    );
  }

  /// ========================
  /// INSERT
  /// ========================
  Future<bool> insertRev(ReservationModel newRev, DateTime date) async {
    emit(state.copyWith(isLoading: true));

    final rev = await SupabaseReservations.insertRev(newRev);

    getResByDate(date: date);

    emit(state.copyWith(isLoading: false));

    return rev;
  }

  /// ========================
  /// DELETE
  /// ========================
  Future<bool> deleteRev(int id, DateTime date) async {
    emit(state.copyWith(isLoading: true));

    final del = await SupabaseReservations.deleteRev(id);

    getResByDate(date: date);

    emit(state.copyWith(isLoading: false));

    return del;
  }

  /// ========================
  /// INIT FORM DATA
  /// ========================
  Future<void> initReservationForm() async {
    final tools = await SupabaseReservations.getTools();

    final clientTypes = await SupabaseReservations.getClientTypes();

    emit(
      state.copyWith(
        formState: state.formState.copyWith(
          tools: tools,
          clientTypes: clientTypes,
        ),
      ),
    );
  }

  /// ========================
  /// MULTI DATE PICKER
  /// ========================
  Future<void> pickMultiDates(BuildContext context) async {
    final dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.multi,
      ),
      dialogSize: const Size(500, 400),
      value: [],
    );

    if (dates == null) return;

    final selectedDates = dates
        .whereType<DateTime>()
        .map(
          (date) => ReservationDateModel(
            date: date,
            from: TimeOfDay.now(),
            to: TimeOfDay.now(),
          ),
        )
        .toList();

    emit(
      state.copyWith(
        formState: state.formState.copyWith(selectedDates: selectedDates),
      ),
    );
  }

  /// ========================
  /// TIME UPDATES
  /// ========================
  Future<void> updateFromTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: state.formState.selectedDates[index].from,
    );

    if (picked == null) return;

    final list = List<ReservationDateModel>.from(state.formState.selectedDates);

    list[index] = ReservationDateModel(
      date: list[index].date,
      from: picked,
      to: list[index].to,
    );

    emit(
      state.copyWith(formState: state.formState.copyWith(selectedDates: list)),
    );
  }

  Future<void> updateToTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: state.formState.selectedDates[index].to,
    );

    if (picked == null) return;

    final list = List<ReservationDateModel>.from(state.formState.selectedDates);

    list[index] = ReservationDateModel(
      date: list[index].date,
      from: list[index].from,
      to: picked,
    );

    emit(
      state.copyWith(formState: state.formState.copyWith(selectedDates: list)),
    );
  }

  /// ========================
  /// CLIENT TYPE
  /// ========================
  void selectClientType(ClientType type) {
    emit(
      state.copyWith(
        formState: state.formState.copyWith(selectedClientType: type),
      ),
    );
  }

  /// ========================
  /// TOOLS (MULTI SELECT)
  /// ========================
  void addTool(ToolsModel tool) {
    final tools = List<ToolsModel>.from(state.formState.selectedTools);

    if (!tools.any((e) => e.id == tool.id)) {
      tools.add(tool);
    }

    emit(
      state.copyWith(
        formState: state.formState.copyWith(
          selectedTools: tools,
          selectedTool: tool,
        ),
      ),
    );
  }

  void removeTool(ToolsModel tool) {
    final tools = List<ToolsModel>.from(state.formState.selectedTools);

    tools.removeWhere((e) => e.id == tool.id);

    emit(
      state.copyWith(formState: state.formState.copyWith(selectedTools: tools)),
    );
  }
}
