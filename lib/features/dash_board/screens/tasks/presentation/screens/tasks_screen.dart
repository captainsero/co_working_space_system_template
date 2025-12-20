import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/widgets/add_task.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/widgets/tasks_container.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Tasks"),
          AddTask(),
          TasksContainer(),
        ],
      ),
    );
  }
}
