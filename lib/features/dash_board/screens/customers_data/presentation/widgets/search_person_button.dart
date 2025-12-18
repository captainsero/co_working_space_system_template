import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/core/widgets/custom_barcode.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:toastification/toastification.dart';

class SearchPersonButton extends StatefulWidget {
  const SearchPersonButton({super.key});

  @override
  State<SearchPersonButton> createState() => _SearchPersonButtonState();
}

class _SearchPersonButtonState extends State<SearchPersonButton> {
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController collageController = TextEditingController();
  TextEditingController partnershipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSize.s2,
                    children: [
                      Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      Text(
                        "Search a Person",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),

                content: SizedBox(
                  width: ScreenSize.width / 5,
                  child: Column(
                    spacing: AppSize.s5,
                    children: [
                      CustomTextField(
                        controller: numberController,
                        hint: "Enter Number",
                      ),

                      CustomTextField(controller: nameController, hint: "Name"),

                      CustomTextField(
                        controller: collageController,
                        hint: "Collage",
                      ),

                      CustomTextField(
                        controller: partnershipCodeController,
                        hint: "Partnership Code",
                      ),

                      SizedBox(
                        width: AppSize.s70,
                        height: AppSize.s30,
                        child: CustomBarcode(number: numberController.text),
                      ),
                    ],
                  ),
                ),

                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final number = numberController.text.trim();
                      final collage = collageController.text.trim();
                      final partnershipCode = partnershipCodeController.text
                          .trim();

                      // Number: exactly 11 digits
                      final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

                      // Partnership code: 5 letters/numbers only (no shapes)
                      final codeValid = RegExp(
                        r'^[A-Za-z0-9]{5}$',
                      ).hasMatch(partnershipCode);

                      if (!numberValid) {
                        ModernToast.showToast(
                          context,
                          'Warning',
                          'Number must be exactly 11 digits',
                          ToastificationType.warning,
                        );
                        return;
                      }
                      if (!codeValid) {
                        ModernToast.showToast(
                          context,
                          'Warning',
                          'Partnership code must be 5 letters/numbers only',
                          ToastificationType.warning,
                        );
                        return;
                      }

                      final updateUser =
                          await SupabaseCustomersData.updateUserData(
                            number: number,
                            name: name,
                            collage: collage,
                            partnershipCode: partnershipCode,
                          );

                      final updateInTeam = await context
                          .read<InTeamCubit>()
                          .updateUser(
                            number: number,
                            name: name,
                            collage: collage,
                            partnershipCode: partnershipCode,
                          );

                      if (updateUser && updateInTeam) {
                        ModernToast.showToast(
                          context,
                          'Success',
                          'User Updated Successfully',
                          ToastificationType.success,
                        );
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          "User Didn't Updated, try again later",
                          ToastificationType.warning,
                        );
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s10),
                    ),
                    child: const Text("Edit"),
                  ),

                  TextButton(
                    onPressed: () async {
                      final number = numberController.text.trim();
                      final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

                      if (!numberValid) {
                        ModernToast.showToast(
                          context,
                          'Warning',
                          'Number must be exactly 11 digits',
                          ToastificationType.warning,
                        );
                        return;
                      }

                      final delete =
                          await SupabaseCustomersData.deleteUserByNumber(
                            number: number,
                          );

                      await context.read<InTeamCubit>().deleteUser(number);

                      if (delete) {
                        ModernToast.showToast(
                          context,
                          'Success',
                          'User Deleted Successfully',
                          ToastificationType.success,
                        );
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          "User Didn't Deleted, try again later",
                          ToastificationType.warning,
                        );
                      }
                      Navigator.pop(context);
                    },

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s10),
                    ),
                    child: Text(
                      "Delete",
                      style: getSemiBoldStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontFamily: FontConstants.libertinusFamily,
                        fontSize: FontSize.s7,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s10),
                    ),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final number = numberController.text.trim();
                      final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

                      if (!numberValid) {
                        ModernToast.showToast(
                          context,
                          'Warning',
                          'Number must be exactly 11 digits',
                          ToastificationType.warning,
                        );
                        return;
                      }

                      final UsersClass? user =
                          await SupabaseCustomersData.getUsersDataByNumber(
                            number: numberController.text,
                          );
                      if (user != null) {
                        setState(() {
                          nameController = TextEditingController(
                            text: user.name,
                          );
                          collageController = TextEditingController(
                            text: user.collage,
                          );
                          partnershipCodeController = TextEditingController(
                            text: user.partnershipCode,
                          );
                        });
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          'There is no user with this number',
                          ToastificationType.error,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s10),
                    ),
                    child: const Text("Search"),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Text("Search person"),
    );
  }
}
