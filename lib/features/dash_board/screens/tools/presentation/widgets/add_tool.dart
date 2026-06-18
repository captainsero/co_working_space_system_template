import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/logic/cubit/tools_cubit.dart';
import 'package:toastification/toastification.dart';

class AddTool extends StatelessWidget {
  AddTool({super.key});

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
        child: BlocBuilder<ToolsCubit, ToolsState>(
          builder: (context, state) {
            void addTool() async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              final tool = ToolsModel(name: controller.text);

              final inserted = await context.read<ToolsCubit>().insertTool(
                tool,
              );

              if (inserted) {
                ModernToast.showToast(
                  context,
                  "Success",
                  "Tool added successfully",
                  ToastificationType.success,
                );

                controller.clear();
              } else {
                ModernToast.showToast(
                  context,
                  "Error",
                  "Tool already exists",
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
                    IconAndText(text: "Add Tool", icon: Icons.build),

                    TextButton.icon(
                      onPressed: addTool,
                      icon: Icon(Icons.add_circle),
                      label: Text("Add"),
                    ),
                  ],
                ),

                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: controller,
                    hint: "Tool Name",

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
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
