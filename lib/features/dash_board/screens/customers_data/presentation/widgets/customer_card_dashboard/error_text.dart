import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p4),
      child: Text(
        'Error: $error',
        style: getMediumStyle(
          color: Theme.of(context).colorScheme.error,
          fontFamily: FontConstants.libertinusFamily,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }
}
