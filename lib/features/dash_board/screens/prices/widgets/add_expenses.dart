import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';
import 'package:toastification/toastification.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.4,
      height: ScreenSize.height / 2.4,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: Form(
        key: formKey,
        child: Column(
          spacing: AppSize.s5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconAndText(
                  text: "Add Expenses",
                  icon: Icons.money_off_csred_outlined,
                ),

                TextButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newPrice = double.parse(priceController.text);
                      ExpensesModel expense = ExpensesModel(
                        name: nameController.text,
                        price: newPrice,
                      );
                      final isInserted = await SupabaseDaysData.insertExpenses(
                        Validators.choosenDay,
                        expense,
                      );
                      if (!isInserted) {
                        ModernToast.showToast(
                          context,
                          'Error',
                          'Error Inserting Expenses, Try Again later',
                          ToastificationType.error,
                        );
                        return;
                      }
                      ModernToast.showToast(
                        context,
                        'Success',
                        'Expenses Updated successfully',
                        ToastificationType.success,
                      );
                      nameController.clear();
                      priceController.clear();
                    }
                  },
                  icon: Icon(Icons.add_circle),
                  label: Text("Add"),
                ),
              ],
            ),

            SizedBox(
              width: ScreenSize.width / 5.5,
              child: CustomTextField(
                controller: nameController,
                hint: "Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
            ),

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
          ],
        ),
      ),
    );
  }
}
