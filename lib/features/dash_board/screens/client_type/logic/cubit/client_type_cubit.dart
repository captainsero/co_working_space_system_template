import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/data/supabase_client_type.dart';

part 'client_type_state.dart';

class ClientTypeCubit extends Cubit<ClientTypeState> {
  ClientTypeCubit() : super(ClientTypeInitial());

  void getClientTypes() async {
    emit(ClientTypeLoading());

    final types = await SupabaseClientType.getClientTypes();

    emit(ClientTypeGet(types: types));
  }

  Future<bool> insertClientType(ClientType type) async {
    final result = await SupabaseClientType.insertClientType(type);

    getClientTypes();

    return result;
  }

  Future<bool> deleteClientType(int id) async {
    final result = await SupabaseClientType.deleteClientType(id);

    getClientTypes();

    return result;
  }
}
