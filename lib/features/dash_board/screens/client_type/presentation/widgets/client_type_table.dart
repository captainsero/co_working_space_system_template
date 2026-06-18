import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/models/client_type.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/logic/cubit/client_type_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class ClientTypeTable extends StatelessWidget {
  const ClientTypeTable({super.key});

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
            IconAndText(text: "Client Types", icon: Icons.people),

            BlocBuilder<ClientTypeCubit, ClientTypeState>(
              builder: (context, state) {
                List<ClientType> types = [];

                if (state is ClientTypeGet) {
                  types = state.types;
                }

                return Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),

                    1: FlexColumnWidth(1),
                  },

                  children: [
                    TableRow(
                      children: [
                        TableHeader("Type"),

                        Center(child: TableHeader("Action")),
                      ],
                    ),

                    for (var type in types)
                      TableRow(
                        children: [
                          TableCell1(type.type),

                          IconButton(
                            onPressed: () async {
                              final deleted = await context
                                  .read<ClientTypeCubit>()
                                  .deleteClientType(type.id!);

                              if (deleted) {
                                ModernToast.showToast(
                                  context,
                                  "Success",
                                  "Deleted successfully",
                                  ToastificationType.success,
                                );
                              }
                            },

                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
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
