import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class OurStuff extends StatelessWidget {
  const OurStuff({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height / 2.5,
      padding: EdgeInsets.all(AppPadding.p4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(RadiusSize.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSize.s3,
        children: [
          IconAndText(text: "Our Stuff", icon: Icons.group_sharp),

          BlocBuilder<StuffCubit, StuffState>(
            builder: (context, state) {
              List<StuffModel> stuff = [];
              if (state is StuffGet) {
                stuff = state.stuff;
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
                      TableHeader("Number"),
                      TableHeader("position"),
                      Center(child: TableHeader("Actions")),
                    ],
                  ),
                  for (var ele in stuff)
                    TableRow(
                      children: [
                        TableCell1(ele.name),
                        TableCell1(ele.number),
                        TableCell1(ele.position),

                        IconButton(
                          onPressed: () async {
                            final delete = await context
                                .read<StuffCubit>()
                                .delete(ele.number);

                            if (delete) {
                              ModernToast.showToast(
                                context,
                                'Success',
                                'Position Deleted successfully',
                                ToastificationType.success,
                              );
                            } else {
                              ModernToast.showToast(
                                context,
                                'Error',
                                'Cannot delete the Position, try again',
                                ToastificationType.error,
                              );
                            }
                          },
                          icon: Padding(
                            padding: EdgeInsets.all(AppPadding.p2),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                              size: AppSize.s7,
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
    );
  }
}
