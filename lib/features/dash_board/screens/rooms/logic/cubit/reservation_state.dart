part of 'reservation_cubit.dart';

@immutable
class ReservationState {
  final bool isLoading;
  final List<ReservationModel> reservationsByDate;
  final ReservationFormState formState;

  final String searchQuery;

  final String? errorMessage;
  final String? successMessage;

  const ReservationState({
    this.isLoading = false,
    this.reservationsByDate = const [],
    this.formState = const ReservationFormState(),
    this.searchQuery = '',
    this.errorMessage,
    this.successMessage,
  });

  /// filtered reservations
  List<ReservationModel> get filteredReservations {
    if (searchQuery.trim().isEmpty) {
      return reservationsByDate;
    }

    return reservationsByDate.where((reservation) {
      return reservation.number.contains(searchQuery);
    }).toList();
  }

  ReservationState copyWith({
    bool? isLoading,
    List<ReservationModel>? reservationsByDate,
    ReservationFormState? formState,
    String? searchQuery,
    String? errorMessage,
    String? successMessage,
  }) {
    return ReservationState(
      isLoading: isLoading ?? this.isLoading,
      reservationsByDate: reservationsByDate ?? this.reservationsByDate,
      formState: formState ?? this.formState,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ReservationFormState {
  final List<ReservationDateModel> selectedDates;
  final List<ToolsModel> selectedTools;
  final List<ToolsModel> tools;
  final List<ClientType> clientTypes;
  final ClientType? selectedClientType;
  final RoomsModel? selectedRoom;
  final bool isLoading;
  final ToolsModel? selectedTool;

  const ReservationFormState({
    this.selectedDates = const [],
    this.selectedTools = const [],
    this.tools = const [],
    this.clientTypes = const [],
    this.selectedClientType,
    this.selectedRoom,
    this.isLoading = false,
    this.selectedTool,
  });

  ReservationFormState copyWith({
    List<ReservationDateModel>? selectedDates,
    List<ToolsModel>? selectedTools,
    List<ToolsModel>? tools,
    List<ClientType>? clientTypes,
    ClientType? selectedClientType,
    RoomsModel? selectedRoom,
    bool? isLoading,
    ToolsModel? selectedTool,
  }) {
    return ReservationFormState(
      selectedDates: selectedDates ?? this.selectedDates,
      selectedTools: selectedTools ?? this.selectedTools,
      tools: tools ?? this.tools,
      clientTypes: clientTypes ?? this.clientTypes,
      selectedClientType: selectedClientType ?? this.selectedClientType,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      isLoading: isLoading ?? this.isLoading,
      selectedTool: selectedTool ?? this.selectedTool,
    );
  }
}
