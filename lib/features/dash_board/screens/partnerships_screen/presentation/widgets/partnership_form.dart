import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:toastification/toastification.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';

class PartnershipForm extends StatefulWidget {
  const PartnershipForm({super.key});

  @override
  State<PartnershipForm> createState() => _PartnershipFormState();
}

class _PartnershipFormState extends State<PartnershipForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  // final codeController = TextEditingController();
  String? code;

  final List<String> offerTypes = [
    "percentage",
    "fixed",
    "freeHour",
    "freeItem",
  ];
  String? selectedOfferType;

  /// Generate auto code
  String generateCode(String name) {
    final lettersOnly = name.replaceAll(RegExp(r'[^A-Za-z]'), '');

    // take first 2 letters or pad with X if not enough
    final shortName = lettersOnly.length >= 2
        ? lettersOnly.substring(0, 2)
        : lettersOnly.padRight(2, 'X');

    // generate 3 random digits
    final random = Random();
    final numbers = List.generate(3, (_) => random.nextInt(10)).join();

    return (shortName + numbers).toUpperCase();
  }

  void insertData() async {
    if (_formKey.currentState!.validate()) {
      final generatedCode = generateCode(nameController.text);
      code = generatedCode;

      final valued = double.parse(valueController.text);

      OfferClass offer = OfferClass(
        name: nameController.text,
        value: valued,
        code: generatedCode,
        type: selectedOfferType!,
        description: descriptionController.text,
        active: true,
        usage: 0,
      );

      final success = await context.read<PartnerShipCubit>().insertOffer(
        offer: offer,
      );

      if (success) {
        context.read<PartnerShipCubit>().partnerShipLoadData();

        ModernToast.showToast(
          context,
          'Success',
          'Offer Inserted successfully',
          ToastificationType.success,
        );
      } else {
        ModernToast.showToast(
          context,
          'Error',
          'Offer with same name or code exists ',
          ToastificationType.error,
        );
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.s3,
          children: [
            IconAndText(
              text: "Add New PartnerShip",
              icon: Icons.add_link_sharp,
            ),

            SizedBox(height: AppSize.s3),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: nameController,
                    hint: "Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return "Name must contain only letters";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: valueController,
                    hint: "Value",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Value cannot be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Value must be a number";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomDropdownField(
                    value: selectedOfferType,
                    items: offerTypes,
                    hint: "Select Offer Type",
                    onChanged: (value) {
                      setState(() => selectedOfferType = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an offer type";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenSize.width / 5.5,
                  padding: EdgeInsets.all(AppPadding.p2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(RadiusSize.r12),
                  ),
                  child: Center(
                    child: SelectableText(
                      code ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),

                TextButton.icon(
                  onPressed: insertData,
                  icon: Icon(
                    Icons.group_add_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    "Add",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: descriptionController,
                    hint: "Description",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
