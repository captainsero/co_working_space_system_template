import 'package:bloc/bloc.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/core/models/reservation_date_model.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_reservations.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationInitial());

  ReservationFormState formState = ReservationFormState();

  void getAllRev() async {
    emit(GetReservationLoading());
    final reservations = await SupabaseReservations.getAllRev();
    final reservationsByDate = await SupabaseReservations.getRevByDate(
      Validators.choosenDay,
    );

    emit(
      ReservationGet(
        reservations: reservations,
        reservationsByDate: reservationsByDate,
      ),
    );
  }

  Future<bool> insertRev(ReservationModel newRev) async {
    emit(InsertReservationLoading());
    final rev = await SupabaseReservations.insertRev(newRev);
    if (rev == true) {
      getAllRev();
      return true;
      // Do NOT call getAllRev() here
    } else {
      getAllRev();
      return false;
      // Do NOT call getAllRev() here
    }
  }

  Future<bool> deleteRev(int id) async {
    emit(DeleteReservationLoading());
    final del = await SupabaseReservations.deleteRev(id);

    if (del == false) {
      getAllRev();
      return false;
      // Do NOT call getAllRev() here
    } else {
      getAllRev();
      return true;
      // Do NOT call getAllRev() here
    }
  }

  Future<void> initReservationForm() async {
    final tools = await SupabaseReservations.getTools();

    final clientTypes = await SupabaseReservations.getClientTypes();

    formState = formState.copyWith(tools: tools, clientTypes: clientTypes);

    emit(ReservationFormUpdated(formState));
  }

  Future<void> pickMultiDates(BuildContext context) async {
    final dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.multi,
      ),
      dialogSize: const Size(500, 400),
      value: [],
    );

    if (dates != null) {
      formState = formState.copyWith(
        selectedDates: dates
            .whereType<DateTime>()
            .map(
              (date) => ReservationDateModel(
                date: date,
                from: TimeOfDay.now(),
                to: TimeOfDay.now(),
              ),
            )
            .toList(),
      );

      emit(ReservationFormUpdated(formState));
    }
  }

  Future<void> updateFromTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: formState.selectedDates[index].from,
    );

    if (picked == null) return;

    final list = List<ReservationDateModel>.from(formState.selectedDates);

    list[index] = ReservationDateModel(
      date: list[index].date,
      from: picked,
      to: list[index].to,
    );

    formState = formState.copyWith(selectedDates: list);

    emit(ReservationFormUpdated(formState));
  }

  Future<void> updateToTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: formState.selectedDates[index].to,
    );

    if (picked == null) return;

    final list = List<ReservationDateModel>.from(formState.selectedDates);

    list[index] = ReservationDateModel(
      date: list[index].date,
      from: list[index].from,
      to: picked,
    );

    formState = formState.copyWith(selectedDates: list);

    emit(ReservationFormUpdated(formState));
  }

  void selectClientType(ClientType type) {
    formState = formState.copyWith(selectedClientType: type);

    emit(ReservationFormUpdated(formState));
  }

  void addTool(ToolsModel tool) {
    final tools = List<ToolsModel>.from(formState.selectedTools);

    if (!tools.contains(tool)) {
      tools.add(tool);
    }

    formState = formState.copyWith(selectedTools: tools);

    emit(ReservationFormUpdated(formState));
  }

  void removeTool(ToolsModel tool) {
    final tools = List<ToolsModel>.from(formState.selectedTools);

    tools.remove(tool);

    formState = formState.copyWith(selectedTools: tools);

    emit(ReservationFormUpdated(formState));
  }

  void selectTool(ToolsModel tool) {
    final tools = List<ToolsModel>.from(formState.selectedTools);

    if (!tools.any((e) => e.id == tool.id)) {
      tools.add(tool);
    }

    formState = formState.copyWith(selectedTool: tool, selectedTools: tools);

    emit(ReservationFormUpdated(formState));
  }
}
