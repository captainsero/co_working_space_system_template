import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/items_categories_model.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/logic/cubit/items_categories_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class OurCategories extends StatelessWidget {
  const OurCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height / 2.5,

      padding: EdgeInsets.all(AppPadding.p4),

      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,

        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),

      child: Column(
        spacing: AppSize.s4,

        children: [
          IconAndText(text: "Our Categories", icon: Icons.category),

          BlocBuilder<ItemsCategoriesCubit, ItemsCategoriesState>(
            builder: (context, state) {
              List<ItemsCategoryModel> categories = [];

              if (state is GetItemsCategories) {
                categories = state.categories;
              }

              if (state is ItemsCategoriesLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Table(
                children: [
                  TableRow(
                    children: [
                      TableHeader("Category"),

                      Center(child: TableHeader("Actions")),
                    ],
                  ),

                  for (final category in categories)
                    TableRow(
                      children: [
                        TableCell1(category.name),

                        Center(
                          child: IconButton(
                            onPressed: () async {
                              final deleted = await context
                                  .read<ItemsCategoriesCubit>()
                                  .deleteCategory(category.name);

                              if (deleted) {
                                ModernToast.showToast(
                                  context,
                                  "Success",
                                  "Deleted",
                                  ToastificationType.success,
                                );
                              }
                            },

                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
