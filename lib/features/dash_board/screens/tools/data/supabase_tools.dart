import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_reservations.dart';

class SupabaseTools {
  static final supabase = Supabase.instance.client;

  /// Insert tool
  static Future<bool> insertTool(ToolsModel tool) async {
    try {
      final existing = await supabase
          .from("rooms_tools")
          .select()
          .eq("name", tool.name);

      if (existing.isNotEmpty) {
        return false;
      }

      await supabase.from("rooms_tools").insert({"name": tool.name});

      return true;
    } catch (e) {
      print("Insert tool error: $e");
      return false;
    }
  }

  /// Delete tool
  static Future<bool> deleteTool(int id) async {
    try {
      await supabase.from("rooms_tools").delete().eq("id", id);

      return true;
    } catch (e) {
      print("Delete tool error: $e");
      return false;
    }
  }

  /// Get all tools
  static Future<List<ToolsModel>> getTools() async {
    try {
      return await SupabaseReservations.getTools();
    } catch (e) {
      print("Get tools error: $e");
      return [];
    }
  }
}
