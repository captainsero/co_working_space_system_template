import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/data/supabase_tools.dart';

part 'tools_state.dart';

class ToolsCubit extends Cubit<ToolsState> {
  ToolsCubit() : super(ToolsInitial());

  void getTools() async {
    emit(ToolsLoading());

    final tools = await SupabaseTools.getTools();

    emit(ToolsGet(tools: tools));
  }

  Future<bool> insertTool(ToolsModel tool) async {
    final result = await SupabaseTools.insertTool(tool);

    getTools();

    return result;
  }

  Future<bool> deleteTool(int id) async {
    final result = await SupabaseTools.deleteTool(id);

    getTools();

    return result;
  }
}
