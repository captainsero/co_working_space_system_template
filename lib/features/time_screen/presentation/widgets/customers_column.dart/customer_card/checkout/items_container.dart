import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items_categories/logic/cubit/items_categories_cubit.dart';

class ItemsContainer extends StatefulWidget {
  const ItemsContainer({super.key, required this.user});
  final String user;

  @override
  State<ItemsContainer> createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  String item = 'Drink';
  bool isChosen = true;

  // void onChoose() {
  //   setState(() {
  //     item = item == "Drink" ? "Snack" : "Drink";
  //   });
  //   context.read<ItemsCubit>().getByCategory(item);
  // }

  String selectedCategory = '';

  // void onDrink() {
  //   setState(() {
  //     item = "Drink";
  //     isChosen = true;
  //   });
  //   context.read<ItemsCubit>().getByCategory(item);
  // }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    context.read<ItemsCubit>().getByCategory(category);
  }

  // void onSnack() {
  //   setState(() {
  //     item = "Snack";
  //     isChosen = false;
  //   });
  //   context.read<ItemsCubit>().getByCategory(item);
  // }

  @override
  void initState() {
    super.initState();
    // context.read<ItemsCubit>().getByCategory(item);
    context.read<ItemsCategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsCubit, ItemsState>(
      builder: (context, state) {
        List<ItemsModel> items = [];
        if (state is ItemsGetByCategory) {
          items = state.items;
        }

        if (state is ItemsLoading) {
          return CircularProgressIndicator();
        } else {
          return Container(
            width: ScreenSize.width / 1.8,
            height: ScreenSize.height / 1.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusSize.r12),
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
              ),
            ),
            child: Column(
              children: [
                BlocBuilder<ItemsCategoriesCubit, ItemsCategoriesState>(
                  builder: (context, categoryState) {
                    if (categoryState is ItemsCategoriesLoading) {
                      return CircularProgressIndicator();
                    }

                    if (categoryState is GetItemsCategories) {
                      final categories = categoryState.categories;

                      // Select first category automatically
                      if (selectedCategory.isEmpty && categories.isNotEmpty) {
                        selectedCategory = categories.first.name;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<ItemsCubit>().getByCategory(
                            selectedCategory,
                          );
                        });
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,

                        child: Row(
                          children: categories.map((category) {
                            final selected = selectedCategory == category.name;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p2,
                              ),

                              child: TextButton(
                                onPressed: () => selectCategory(category.name),

                                child: Text(
                                  category.name,

                                  style: selected
                                      ? Theme.of(context).textTheme.titleMedium
                                      : Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }

                    return SizedBox();
                  },
                ),
                Expanded(
                  child: SizedBox(
                    width: ScreenSize.width / 1.8,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 items per row
                        childAspectRatio: 1.2, // Adjust for card shape
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        // Decide label & color
                        late String label;
                        late Color textColor;

                        if (item.quantity == 0) {
                          label = "Out Of Stock";
                          textColor = Theme.of(context).colorScheme.error;
                        } else if (item.quantity < 5 && item.quantity > 0 ||
                            item.quantity == 5) {
                          // 👈 quantity less than 5
                          label = "Low Stock";
                          textColor = ColorManager.orange;
                        } else {
                          label = "Add";
                          textColor = Theme.of(context).colorScheme.onSecondary;
                        }

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.p4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Text(
                                  "Quantity: ${item.quantity}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Spacer(),
                                Text(
                                  "Price: ${item.price}\$",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),

                                Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: item.quantity == 0
                                        ? null
                                        : () async {
                                            final itemBox =
                                                Hive.box<CheckoutItems>(
                                                  widget.user,
                                                );

                                            // ✅ Check if an item with the same name already exists
                                            final alreadyExists = itemBox.values
                                                .any(
                                                  (checkout) =>
                                                      checkout.name ==
                                                      items[index].name,
                                                );

                                            if (alreadyExists) {
                                              // Item is already in the box → do nothing
                                              return;
                                            }

                                            // Item is not in the box → add it
                                            await itemBox.add(
                                              CheckoutItems(
                                                name: items[index].name,
                                                price: items[index].price,
                                                quantity: 1,
                                                category: items[index].category,
                                                mainQuantity:
                                                    items[index].quantity,
                                              ),
                                            );
                                          },

                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: FontSize.s6,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
