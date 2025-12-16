import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class AddPersonDialog extends StatelessWidget {
  const AddPersonDialog({
    super.key,
    required this.nameController,
    required this.numberController,
    required this.collageController,
    required this.partnershipCodeController,
  });
  final TextEditingController nameController;
  final TextEditingController numberController;
  final TextEditingController collageController;
  final TextEditingController partnershipCodeController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(AppPadding.p12),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSize.s1,
          children: [
            Icon(
              Icons.person_add,
              color: Theme.of(context).colorScheme.tertiary,
              size: AppSize.s8,
            ),
            Text("Add New Person"),
          ],
        ),
      ),
      content: SizedBox(
        width: ScreenSize.width / 5,
        height: ScreenSize.height / 2,
        child: Column(
          children: [
            const Spacer(),
            CustomTextField(controller: nameController, hint: "Name"),
            SizedBox(height: AppSize.s5),
            CustomTextField(controller: numberController, hint: "Number"),
            SizedBox(height: AppSize.s5),
            CustomTextField(controller: collageController, hint: "Collage"),
            SizedBox(height: AppSize.s5),
            CustomTextField(
              controller: partnershipCodeController,
              hint: "Partnership Code",
            ),
            const Spacer(),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),

          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text("Cancel"),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => TimeScreenLogic.addPersonButtonLogic(
            nameController: nameController,
            numberController: numberController,
            collageConroller: collageController,
            partnershipCodeController: partnershipCodeController,
            context: context,
          ),

          child: const Text("Add"),
        ),
      ],
    );
  }
}
