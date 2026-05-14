import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/tasks_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/logic/cubit/tasks_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class TasksContainer extends StatelessWidget {
  const TasksContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 2,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.s3,
          children: [
            IconAndText(text: "Tasks", icon: Icons.book),

            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                List<TasksModel> tasks = [];
                if (state is GetTasks) {
                  tasks = List.from(state.tasks);

                  // 🔹 Sort tasks by date (earliest first)
                  tasks.sort((a, b) => b.endDate.compareTo(a.endDate));

                  // 🔸 If you prefer newest first, reverse it:
                  // tasks.sort((a, b) => b.endDate.compareTo(a.endDate));
                }

                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableHeader("Name"),
                        TableHeader("Staff Name"),
                        TableHeader("End Date"),
                        Center(child: TableHeader("Actions")),
                      ],
                    ),
                    for (var ele in tasks)
                      TableRow(
                        children: [
                          TableCell1(ele.name),
                          TableCell1(ele.staffName),
                          TableCell1(StringExtensions.formatDate(ele.endDate)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final toggled = await context
                                      .read<TasksCubit>()
                                      .markTask(ele.name);

                                  if (toggled) {
                                    ModernToast.showToast(
                                      context,
                                      'Success',
                                      'Task status toggled successfully',
                                      ToastificationType.success,
                                    );
                                  } else {
                                    ModernToast.showToast(
                                      context,
                                      'Error',
                                      'Could not toggle task, try again later',
                                      ToastificationType.error,
                                    );
                                  }
                                },
                                icon: Padding(
                                  padding: EdgeInsets.all(AppPadding.p2),
                                  child: ele.done
                                      ? Icon(
                                          Icons.done_all,
                                          color: ColorManager.green,
                                          size: AppSize.s7,
                                        )
                                      : Icon(
                                          Icons.download_done_sharp,
                                          color: ColorManager.black,
                                          size: AppSize.s7,
                                        ),
                                ),
                              ),

                              // IconButton(
                              //   onPressed: () async {
                              //     final remove = await context
                              //         .read<TasksCubit>()
                              //         .removeTask(ele.name);
                              //     if (remove) {
                              //       ModernToast.showToast(
                              //         context,
                              //         'Success',
                              //         'Task Removed Successfully',
                              //         ToastificationType.success,
                              //       );
                              //     } else {
                              //       ModernToast.showToast(
                              //         context,
                              //         'Error',
                              //         "Can't delete This task Write now",
                              //         ToastificationType.error,
                              //       );
                              //     }
                              //   },
                              //   icon: Icon(
                              //     Icons.delete,
                              //     color: Theme.of(context).colorScheme.error,
                              //     size: AppSize.s7,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
