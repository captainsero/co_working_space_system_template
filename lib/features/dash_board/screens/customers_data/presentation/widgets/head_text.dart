import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class HeadText extends StatelessWidget {
  const HeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Customers Data",
        style: TextStyle(
          fontSize: ScreenSize.width / 50,
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Col.light2,
        ),
      ),
    );
  }
}
