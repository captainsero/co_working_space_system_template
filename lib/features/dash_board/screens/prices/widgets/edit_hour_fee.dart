import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:toastification/toastification.dart';

class EditHourFee extends StatefulWidget {
  const EditHourFee({super.key});

  @override
  State<EditHourFee> createState() => _EditHourFeeState();
}

class _EditHourFeeState extends State<EditHourFee> {
  TextEditingController priceController = TextEditingController(
    text: Validators.hourFee.toString(),
  );
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.4,
      height: ScreenSize.height / 3.9,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.s5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconAndText(
                  text: "Edit Hour Fee",
                  icon: Icons.attach_money_rounded,
                ),

                TextButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newPrice = double.parse(priceController.text);
                      Box box = Hive.box<double>('itemsTotal');
                      box.put('hourFee', newPrice);
                      Validators.hourFee = newPrice;
                      ModernToast.showToast(
                        context,
                        'Success',
                        'Price Updated successfully',
                        ToastificationType.success,
                      );
                    }
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit"),
                ),
              ],
            ),

            SizedBox(
              width: ScreenSize.width / 5.5,
              child: CustomTextField(
                controller: priceController,
                hint: "Price per hour",
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
