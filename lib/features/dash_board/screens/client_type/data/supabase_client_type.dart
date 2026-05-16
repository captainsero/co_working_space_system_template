import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';

class SupabaseClientType {
  static final supabase = Supabase.instance.client;

  /// Get all client types
  static Future<List<ClientType>> getClientTypes() async {
    try {
      final response = await supabase.from("client_type").select();

      return (response as List).map((e) => ClientType.fromJson(e)).toList();
    } catch (e) {
      print("Get client type error: $e");
      return [];
    }
  }

  /// Insert
  static Future<bool> insertClientType(ClientType type) async {
    try {
      final existing = await supabase
          .from("client_type")
          .select()
          .eq("type", type.type);

      if (existing.isNotEmpty) {
        return false;
      }

      await supabase.from("client_type").insert({"type": type.type});

      return true;
    } catch (e) {
      print("Insert client type error: $e");
      return false;
    }
  }

  /// Delete
  static Future<bool> deleteClientType(int id) async {
    try {
      await supabase.from("client_type").delete().eq("id", id);

      return true;
    } catch (e) {
      print("Delete client type error: $e");
      return false;
    }
  }
}
