import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/presentation/widgets/item_status.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/logic/cubit/items_categories_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class ItemsListContainer extends StatefulWidget {
  const ItemsListContainer({super.key});

  @override
  State<ItemsListContainer> createState() => _ItemsListContainerState();
}

class _ItemsListContainerState extends State<ItemsListContainer> {
  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().getAll();
    context.read<ItemsCategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    void showEditDialog(ItemsModel item) async {
      showDialog(
        context: context,
        builder: (context) {
          final formKey = GlobalKey<FormState>();
          final priceController = TextEditingController(
            text: item.price.toString(),
          );
          final quantityController = TextEditingController(
            text: item.quantity.toString(),
          );

          String category = item.category;

          return AlertDialog(
            title: Text("Edit ${item.name}"),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return SizedBox(
                  width: ScreenSize.width / 3,
                  height: ScreenSize.height / 3,

                  child: Form(
                    key: formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: ScreenSize.width / 5.5,

                              child: CustomTextField(
                                controller: priceController,

                                hint: "Price",

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Price cannot be empty";
                                  }

                                  if (double.tryParse(value) == null) {
                                    return "Price must be a number";
                                  }

                                  return null;
                                },
                              ),
                            ),

                            Text("=> Price"),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                              width: ScreenSize.width / 5.5,

                              child: CustomTextField(
                                controller: quantityController,

                                hint: "Quantity",

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Quantity cannot be empty";
                                  }

                                  if (int.tryParse(value) == null) {
                                    return "Quantity must be a number";
                                  }

                                  return null;
                                },
                              ),
                            ),

                            Text("=> Quantity"),
                          ],
                        ),

                        BlocBuilder<ItemsCategoriesCubit, ItemsCategoriesState>(
                          builder: (context, state) {
                            if (state is ItemsCategoriesLoading) {
                              return CircularProgressIndicator();
                            }

                            List<String> categories = [];

                            if (state is GetItemsCategories) {
                              categories = state.categories
                                  .map((e) => e.name)
                                  .toList();
                            }

                            return SizedBox(
                              width: ScreenSize.width / 5.5,

                              child: CustomDropdownField(
                                value: category,

                                items: categories,

                                hint: "Select Category",

                                onChanged: (value) {
                                  setDialogState(() {
                                    category = value!;
                                  });
                                },

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select category";
                                  }

                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text("Cancle"),
              ),

              TextButton.icon(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final name = item.name;
                    final price = double.parse(priceController.text);
                    final quantity = int.parse(quantityController.text);

                    final newitem = ItemsModel(
                      name: name,
                      price: price,
                      quantity: quantity,
                      category: category,
                    );

                    final update = await context.read<ItemsCubit>().update(
                      newitem,
                    );
                    if (update) {
                      ModernToast.showToast(
                        context,
                        'Success',
                        'Item Updated successfully',
                        ToastificationType.success,
                      );
                    } else {
                      ModernToast.showToast(
                        context,
                        'Error',
                        "Can't Update the item, try agian",
                        ToastificationType.error,
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.done_all),
                label: Text("Done"),
              ),
            ],
          );
        },
      );
    }

    return Container(
      height: ScreenSize.height / 1.7,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.s3,
          children: [
            IconAndText(text: "Items List", icon: Icons.format_list_bulleted),

            BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                List<ItemsModel> items = [];
                if (state is ItemsGetAll) {
                  items = state.items;
                }

                if (state is ItemsLoading) {
                  return CircularProgressIndicator();
                } else {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(1.7),
                      5: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          TableHeader("Quantity"),
                          TableHeader("Category"),
                          Center(child: TableHeader("Status")),

                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in items)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.price),
                            TableCell1(ele.quantity),
                            TableCell1(ele.category),
                            ItemStatus(quantity: ele.quantity),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => showEditDialog(ele),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.edit,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      size: AppSize.s7,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<ItemsCubit>().delete(ele.name);
                                    ModernToast.showToast(
                                      context,
                                      'Success',
                                      'Item Deleted successfully',
                                      ToastificationType.success,
                                    );
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.all(AppPadding.p2),
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      size: AppSize.s7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
