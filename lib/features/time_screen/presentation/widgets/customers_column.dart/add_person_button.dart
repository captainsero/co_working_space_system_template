import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/add_person_dialog.dart';

class AddPersonButton extends StatelessWidget {
  const AddPersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController numberController = TextEditingController();
        final TextEditingController collageController = TextEditingController();
        final TextEditingController partnershipCodeController =
            TextEditingController(text: "00000");

        await showDialog(
          context: context,
          builder: (context) => AddPersonDialog(
            nameController: nameController,
            numberController: numberController,
            collageController: collageController,
            partnershipCodeController: partnershipCodeController,
          ),
        );
      },
      icon: Icon(Icons.person_add),
      label: Text("Add New Customer"),
    );
  }
}
