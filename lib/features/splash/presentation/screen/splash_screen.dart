import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/images.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/pick_date_theme.dart';
import 'package:team_egypt_v3/features/splash/data/supabase_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  String? statusMessage;

  /// Opens a date picker dialog
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return PickDateTheme(child: child!);
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  /// Calls Supabase insert
  Future<void> insertDay() async {
    setState(() {
      isLoading = true;
      statusMessage = null;
    });

    final result = await SupabaseSplash.insertDay(selectedDate, context);

    setState(() {
      isLoading = false;
      statusMessage = result != null
          ? '✅ Day added: ${DateFormat.yMMMd().format(result)}'
          : '❌ Failed to insert day.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: ScreenSize.width / 2.5,
          height: ScreenSize.height / 1.6,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width / 20,
            vertical: ScreenSize.height / 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(RadiusSize.r30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Team Icon
              CircleAvatar(
                radius: ScreenSize.width / 18,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(Images.teamIcon),
              ),

              Spacer(flex: 1),

              // SizedBox(height: AppSize.s20),

              // Date display + picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Date:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    width: ScreenSize.width / 7,
                    child: ElevatedButton.icon(
                      onPressed: pickDate,
                      icon: Icon(
                        Icons.calendar_today,
                        size: AppSize.s6,
                        // color: Colors.black,
                      ),
                      label: Text(
                        'Pick Date',
                        style: getRegularStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s6,
                          fontFamily: FontConstants.libertinusFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.s4),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat.yMMMd().format(selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: AppSize.s4),

              // Insert button
              isLoading
                  ? const CircularIndicator()
                  : SizedBox(
                      width: ScreenSize.width / 5,
                      child: ElevatedButton(
                        onPressed: insertDay,
                        child: Text('Start The Day'),
                      ),
                    ),

              SizedBox(height: AppSize.s4),

              // Status message
              if (statusMessage != null)
                Text(
                  statusMessage!,
                  style: TextStyle(
                    fontSize: FontSize.s5,
                    fontWeight: FontWeight.bold,
                    color: statusMessage!.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
