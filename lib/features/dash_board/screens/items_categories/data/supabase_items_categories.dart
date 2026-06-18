import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/items_categories_model.dart';

class SupabaseItemsCategories {
  static final _supabase = Supabase.instance.client.from('items_categories');

  /// Insert category
  static Future<bool> insert(ItemsCategoryModel category) async {
    try {
      // Check duplicate name
      final existing = await _supabase
          .select()
          .eq('name', category.name)
          .maybeSingle();

      if (existing != null) {
        print("Category with name '${category.name}' already exists.");
        return false;
      }

      await _supabase.insert(category.toJson());

      return true;
    } catch (e) {
      print("Error inserting category: $e");
      return false;
    }
  }

  /// Get all categories
  static Future<List<ItemsCategoryModel>> getAll() async {
    try {
      final response = await _supabase.select();

      final categories = (response as List)
          .map((e) => ItemsCategoryModel.fromJson(e))
          .toList();

      // Sort A → Z
      categories.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return categories;
    } catch (e) {
      print("Error getting categories: $e");
      return [];
    }
  }

  /// Get category by name
  static Future<ItemsCategoryModel?> getByName(String name) async {
    try {
      final response = await _supabase.select().eq('name', name).maybeSingle();

      if (response == null) return null;

      return ItemsCategoryModel.fromJson(response);
    } catch (e) {
      print("Error getting category: $e");
      return null;
    }
  }

  /// Delete category
  static Future<bool> deleteByName(String name) async {
    try {
      await _supabase.delete().eq('name', name);

      return true;
    } catch (e) {
      print("Error deleting category: $e");
      return false;
    }
  }
}
