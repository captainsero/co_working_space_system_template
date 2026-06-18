import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/logic/cubit/client_type_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/presentation/widgets/add_client_type.dart';
import 'package:team_egypt_v3/features/dash_board/screens/client_type/presentation/widgets/client_type_table.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';

class ClientTypeScreen extends StatefulWidget {
  const ClientTypeScreen({super.key});

  @override
  State<ClientTypeScreen> createState() => _ClientTypeScreenState();
}

class _ClientTypeScreenState extends State<ClientTypeScreen> {
  @override
  void initState() {
    context.read<ClientTypeCubit>().getClientTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: AppSize.s5,
        children: [
          HeadText(text: "Client Types"),
          AddClientType(),
          ClientTypeTable(),
        ],
      ),
    );
  }
}
