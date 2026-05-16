import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/screen/app_bar_main.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customers_column.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/price_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/reservations/today_rev_container.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  double total = 0.0;

  // NEW: hidden barcode listener field
  String _barcodeBuffer = '';
  DateTime _lastKeyTime = DateTime.now();

  static const Duration _scanTimeout = Duration(milliseconds: 200);

  late final FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    _keyboardFocusNode = FocusNode();
    _loadTotal();
    context.read<ReservationCubit>().getResByDate(date: Validators.choosenDay);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _loadTotal() async {
    total = await SupabaseInTeam.getTotal(Validators.choosenDay);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final now = DateTime.now();

          if (now.difference(_lastKeyTime) > _scanTimeout) {
            _barcodeBuffer = '';
          }

          _lastKeyTime = now;

          if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (_barcodeBuffer.isNotEmpty) {
              final controller = TextEditingController(text: _barcodeBuffer);

              TimeScreenLogic.tryInsertUser(context, controller, false);

              _barcodeBuffer = '';
            }
          } else {
            final char = event.character;
            if (char != null && char.isNotEmpty) {
              _barcodeBuffer += char;
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBarMain(),
        body: Padding(
          padding: EdgeInsets.all(AppPadding.p12),
          child: Row(
            children: [
              // Customers
              CustomerColumn(
                searchController: _searchController,
                searchQuery: searchQuery,
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value.trim();
                  });
                },
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: AppPadding.p12),
                  child: Column(
                    children: [
                      BlocBuilder<TimeScreenCubit, TimeScreenState>(
                        builder: (context, state) {
                          final total = (state is GetTotal)
                              ? state.total
                              : this.total;

                          return PriceContainer(total: total);
                        },
                      ),

                      SizedBox(height: AppSize.s10),
                      TodayRevContainer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
