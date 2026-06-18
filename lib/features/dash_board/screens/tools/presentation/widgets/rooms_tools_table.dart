import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/tools_model.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/logic/cubit/tools_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class RoomsToolsTable extends StatelessWidget {
  const RoomsToolsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            IconAndText(text: "Rooms Tools", icon: Icons.build),

            BlocBuilder<ToolsCubit, ToolsState>(
              builder: (context, state) {
                List<ToolsModel> tools = [];

                if (state is ToolsGet) {
                  tools = state.tools;
                }

                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                  columnWidths: const {
                    0: FlexColumnWidth(3),

                    1: FlexColumnWidth(1),
                  },

                  children: [
                    TableRow(
                      children: [
                        TableHeader("Tool Name"),

                        Center(child: TableHeader("Actions")),
                      ],
                    ),

                    for (var tool in tools)
                      TableRow(
                        children: [
                          TableCell1(tool.name),

                          IconButton(
                            onPressed: () async {
                              final delete = await context
                                  .read<ToolsCubit>()
                                  .deleteTool(tool.id!);

                              if (delete) {
                                ModernToast.showToast(
                                  context,
                                  "Success",
                                  "Tool deleted successfully",
                                  ToastificationType.success,
                                );
                              } else {
                                ModernToast.showToast(
                                  context,
                                  "Error",
                                  "Cannot delete tool",
                                  ToastificationType.error,
                                );
                              }
                            },

                            icon: Padding(
                              padding: EdgeInsets.all(AppPadding.p2),

                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
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
