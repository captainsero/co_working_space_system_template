part of 'items_categories_cubit.dart';

sealed class ItemsCategoriesState extends Equatable {
  const ItemsCategoriesState();

  @override
  List<Object?> get props => [];
}

final class ItemsCategoriesInitial extends ItemsCategoriesState {}

final class ItemsCategoriesLoading extends ItemsCategoriesState {}

final class GetItemsCategories extends ItemsCategoriesState {
  final List<ItemsCategoryModel> categories;

  const GetItemsCategories({required this.categories});

  @override
  List<Object?> get props => [categories];
}
