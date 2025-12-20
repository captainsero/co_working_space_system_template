import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/tasks_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/date_picker_button.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/logic/cubit/tasks_cubit.dart';
import 'package:toastification/toastification.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final staffController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String dateFormat = '';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateFormat = StringExtensions.formatDate(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: ScreenSize.width / 2.6,
        padding: EdgeInsets.all(AppPadding.p4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(RadiusSize.r16),
        ),
        child: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            void addTask() async {
              if (_formKey.currentState!.validate()) {
                final task = TasksModel(
                  name: nameController.text,
                  staffName: staffController.text,
                  endDate: selectedDate,
                  done: false,
                );
                final isAdded = await context.read<TasksCubit>().addTask(task);

                if (isAdded) {
                  ModernToast.showToast(
                    context,
                    'Success',
                    'Tasks Added Successfully',
                    ToastificationType.success,
                  );
                  nameController.clear();
                  staffController.clear();
                  dateFormat = '';
                } else {
                  ModernToast.showToast(
                    context,
                    'Error',
                    'There is task with the same name',
                    ToastificationType.error,
                  );
                  nameController.clear();
                  staffController.clear();
                }
              }
            }

            if (state is TasksLoading) {
              return CircularProgressIndicator();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.s3,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndText(text: "Add New Task", icon: Icons.task_alt),

                      TextButton.icon(
                        onPressed: addTask,
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
                      controller: staffController,
                      hint: "Staff Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Staff cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),

                  Row(
                    spacing: AppSize.s10,
                    children: [
                      DatePickerButton(onPick: _pickDate),

                      Text(
                        dateFormat.isEmpty ? "No date" : dateFormat,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
