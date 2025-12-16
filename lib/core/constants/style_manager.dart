import 'package:flutter/widgets.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';

TextStyle getRegularStyle({
  required Color color,
  double fontSize = FontSize.s12c,
  required String fontFamily,
}) =>
    TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
    );

TextStyle getMediumStyle({
  required Color color,
  double fontSize = FontSize.s12c,
  required String fontFamily,
}) =>
    TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
    );

TextStyle getSemiBoldStyle({
  required Color color,
  double fontSize = FontSize.s12c,
  required String fontFamily,
}) =>
    TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600,
    );

TextStyle getBoldStyle({
  required Color color,
  double fontSize = FontSize.s12c,
  required String fontFamily,
}) =>
    TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    );

