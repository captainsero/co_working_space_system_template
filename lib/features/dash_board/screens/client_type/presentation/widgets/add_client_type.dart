import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/logic/cubit/client_type_cubit.dart';
import 'package:toastification/toastification.dart';

class AddClientType extends StatelessWidget {
  AddClientType({super.key});

  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.4,

      height: ScreenSize.height / 4,

      padding: EdgeInsets.all(AppPadding.p4),

      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,

        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),

      child: Form(
        key: formKey,

        child: BlocBuilder<ClientTypeCubit, ClientTypeState>(
          builder: (context, state) {
            void addType() async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              final type = ClientType(type: controller.text);

              final inserted = await context
                  .read<ClientTypeCubit>()
                  .insertClientType(type);

              if (inserted) {
                ModernToast.showToast(
                  context,
                  "Success",
                  "Client type added successfully",
                  ToastificationType.success,
                );

                controller.clear();
              } else {
                ModernToast.showToast(
                  context,
                  "Error",
                  "Type already exists",
                  ToastificationType.error,
                );
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    IconAndText(text: "Add Client Type", icon: Icons.person),

                    TextButton.icon(
                      onPressed: addType,

                      icon: Icon(Icons.add_circle),

                      label: Text("Add"),
                    ),
                  ],
                ),

                SizedBox(
                  width: ScreenSize.width / 5.5,

                  child: CustomTextField(
                    controller: controller,

                    hint: "Client Type",

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }

                      return null;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
