import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/images.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/widgets/screens_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/dash_board.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/screen/time_screen.dart';

class AppBarMain extends StatefulWidget implements PreferredSizeWidget {
  const AppBarMain({super.key});

  @override
  State<AppBarMain> createState() => _AppBarMainState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarMainState extends State<AppBarMain> {
  int isChanged = Validators.isAppBarChanged;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: ScreenSize.width / 3,
      leading: Padding(
        padding: EdgeInsets.only(left: AppPadding.p4),
        child: Row(
          spacing: AppSize.s2,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(Images.tWithoutBackground),
              backgroundColor: Colors.transparent,
              radius: RadiusSize.r20,
            ),
            Text("Team Egypt", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
      actions: [
        ScreensButton(
          screen: DashBoard(),
          title: "Dash Board",
          isSelected: isChanged == 1,
          onSelected: () {
            setState(() {
              Validators.isAppBarChanged = 1;
            });
          },
        ),

        SizedBox(width: AppSize.s3),
        
        ScreensButton(
          screen: TimeScreen(),
          title: "Time Screen",
          isSelected: isChanged == 2,
          onSelected: () {
            setState(() {
              Validators.isAppBarChanged = 2;
            });
          },
        ),
      ],
    );
  }
}
