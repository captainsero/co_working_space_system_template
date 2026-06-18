import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/items_categories_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/data/supabase_items_categories.dart';

part 'items_categories_state.dart';

class ItemsCategoriesCubit extends Cubit<ItemsCategoriesState> {
  ItemsCategoriesCubit() : super(ItemsCategoriesInitial());

  void getCategories() async {
    emit(ItemsCategoriesLoading());

    final categories = await SupabaseItemsCategories.getAll();

    emit(GetItemsCategories(categories: categories));
  }

  Future<bool> insertCategory(ItemsCategoryModel category) async {
    emit(ItemsCategoriesLoading());

    final inserted = await SupabaseItemsCategories.insert(category);

    getCategories();

    return inserted;
  }

  Future<bool> deleteCategory(String name) async {
    emit(ItemsCategoriesLoading());

    final deleted = await SupabaseItemsCategories.deleteByName(name);

    getCategories();

    return deleted;
  }

  Future<ItemsCategoryModel?> getCategoryByName(String name) async {
    return await SupabaseItemsCategories.getByName(name);
  }
}
