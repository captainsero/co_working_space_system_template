import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/items_categories_model.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/logic/cubit/items_categories_cubit.dart';
import 'package:toastification/toastification.dart';

class InsertCategory extends StatefulWidget {
  const InsertCategory({super.key});

  @override
  State<InsertCategory> createState() => _InsertCategoryState();
}

class _InsertCategoryState extends State<InsertCategory> {
  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.5,
      padding: EdgeInsets.all(AppPadding.p2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),

      child: Form(
        key: formKey,
        child: Column(
          spacing: AppSize.s5,
          children: [
            CustomTextField(
              controller: controller,
              hint: "Category Name",

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Required";
                }

                return null;
              },
            ),

            BlocBuilder<ItemsCategoriesCubit, ItemsCategoriesState>(
              builder: (context, state) {
                if (state is ItemsCategoriesLoading) {
                  return CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final inserted = await context
                        .read<ItemsCategoriesCubit>()
                        .insertCategory(
                          ItemsCategoryModel(name: controller.text),
                        );

                    if (inserted) {
                      controller.clear();

                      ModernToast.showToast(
                        context,
                        "Success",
                        "Category Added",
                        ToastificationType.success,
                      );
                    } else {
                      ModernToast.showToast(
                        context,
                        "Error",
                        "Already exists",
                        ToastificationType.error,
                      );
                    }
                  },

                  child: Text("Add Category"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
