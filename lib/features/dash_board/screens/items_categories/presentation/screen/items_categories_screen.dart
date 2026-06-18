import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/presentation/widgets/insert_category.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/presentation/widgets/out_categories.dart';

class ItemsCategoriesScreen extends StatelessWidget {
  const ItemsCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSize.s5,
      children: [
        HeadText(text: "Items Categories"),

        InsertCategory(),

        OurCategories(),
      ],
    );
  }
}
