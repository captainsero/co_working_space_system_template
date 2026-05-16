import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/logic/cubit/tools_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/presentation/widgets/add_tool.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tools/presentation/widgets/rooms_tools_table.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  void initState() {
    context.read<ToolsCubit>().getTools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Tools"),
          AddTool(),
          RoomsToolsTable(),
        ],
      ),
    );
  }
}
