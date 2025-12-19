import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

ThemeData getDarkTheme() {
  return ThemeData(
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.darkLight,
    splashColor: ColorManager.primary,
    scaffoldBackgroundColor: ColorManager.darkPrimary,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: ColorManager.primary,
      onPrimary: ColorManager.light,
      secondary: ColorManager.secondory,
      onSecondary: ColorManager.black,
      surface: ColorManager.darkPrimary,
      onSurface: ColorManager.white,
      error: ColorManager.error,
      onError: ColorManager.black,
      tertiary: ColorManager.light,
      onTertiary: ColorManager.black,
    ),

    // cardView
    cardTheme: CardThemeData(
      margin: EdgeInsets.all(AppMargin.m2),
      color: ColorManager.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusSize.r12), // your radius
        side: BorderSide(color: ColorManager.light, width: AppSize.s0_5),
      ),
      elevation: AppSize.s0,
    ),

    // app bar
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: ColorManager.white, size: AppSize.s25),
      toolbarHeight: AppSize.s40,
      centerTitle: true,
      backgroundColor: ColorManager.light,
      elevation: AppSize.s0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(RadiusSize.r12),
          bottomRight: Radius.circular(RadiusSize.r12),
        ),
      ),
      titleTextStyle: getBoldStyle(
        fontSize: FontSize.s12,
        color: ColorManager.white,
        fontFamily: FontConstants.mozillanFamily,
      ),
    ),

    // Drawer theme
    drawerTheme: DrawerThemeData(backgroundColor: ColorManager.primary),

    // button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.lightPrimary,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorManager.black,
        textStyle: getRegularStyle(
          color: ColorManager.black,
          fontSize: FontSize.s8,
          fontFamily: FontConstants.libertinusFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusSize.r12),
        ),
        backgroundColor: ColorManager.light,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        // Text/icon color
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return ColorManager.grey;
          }
          return ColorManager.light; // modern: light text on dark theme
        }),

        // Border
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: ColorManager.grey.withAlpha(120),
              width: AppSize.s0_5,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: ColorManager.lightPrimary,
              width: AppSize.s0_5,
            );
          }
          return BorderSide(
            color: ColorManager.light.withAlpha(180),
            width: AppSize.s0_5,
          );
        }),

        // Shape
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusSize.r12),
          ),
        ),

        // Size & padding (more “modern” + consistent)
        padding: WidgetStatePropertyAll(EdgeInsets.all(AppPadding.p4)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

        // Ripple/hover/pressed overlay (important for modern feel)
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return ColorManager.light.withAlpha(35);
          }
          if (states.contains(WidgetState.hovered)) {
            return ColorManager.light.withAlpha(18);
          }
          if (states.contains(WidgetState.focused)) {
            return ColorManager.light.withAlpha(22);
          }
          return null;
        }),

        // Typography
        textStyle: WidgetStatePropertyAll(
          getSemiBoldStyle(
            color: ColorManager.light,
            fontFamily: FontConstants.libertinusFamily,
            fontSize: FontSize.s7,
          ),
        ),
      ),
    ),

    // text theme (scaled down for large screens)
    textTheme: TextTheme(
      // Largest
      displayLarge: getBoldStyle(
        color: ColorManager.light,
        fontSize: FontSize.s20,
        fontFamily: FontConstants.shadowsFamily,
      ),
      displayMedium: getBoldStyle(
        color: ColorManager.white,
        fontSize: FontSize.s13,
        fontFamily: FontConstants.libertinusFamily,
      ),
      displaySmall: getBoldStyle(
        color: ColorManager.white,
        fontSize: FontSize.s12,
        fontFamily: FontConstants.libertinusFamily,
      ),

      // Headlines
      headlineLarge: getSemiBoldStyle(
        color: ColorManager.light,
        fontSize: FontSize.s11,
        fontFamily: FontConstants.libertinusFamily,
      ),
      headlineMedium: getSemiBoldStyle(
        color: ColorManager.light,
        fontSize: FontSize.s10,
        fontFamily: FontConstants.libertinusFamily,
      ),
      headlineSmall: getMediumStyle(
        color: ColorManager.light,
        fontSize: FontSize.s9,
        fontFamily: FontConstants.libertinusFamily,
      ),

      // Titles
      titleLarge: getBoldStyle(
        color: ColorManager.white,
        fontSize: FontSize.s8,
        fontFamily: FontConstants.libertinusFamily,
      ),
      titleMedium: getSemiBoldStyle(
        color: ColorManager.white,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
      titleSmall: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s6,
        fontFamily: FontConstants.libertinusFamily,
      ),

      // Body
      bodyLarge: getMediumStyle(
        color: ColorManager.light,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
      bodyMedium: getRegularStyle(
        color: ColorManager.light,
        fontSize: FontSize.s6,
        fontFamily: FontConstants.libertinusFamily,
      ),
      bodySmall: getRegularStyle(
        color: ColorManager.light,
        fontSize: FontSize.s5,
        fontFamily: FontConstants.libertinusFamily,
      ),

      // Labels (smallest)
      labelLarge: getSemiBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s8,
        fontFamily: FontConstants.libertinusFamily,
      ),
      labelMedium: getMediumStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
      labelSmall: getRegularStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s4,
        fontFamily: FontConstants.libertinusFamily,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorManager.primary,
      selectionColor: ColorManager.grey,
      selectionHandleColor: ColorManager.primary,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: ColorManager.darkPrimary,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black54,

      // Header (top area)
      headerBackgroundColor: ColorManager.primary,
      headerForegroundColor: ColorManager.white,
      headerHelpStyle: getMediumStyle(
        color: ColorManager.white.withAlpha(220),
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s6,
      ),
      headerHeadlineStyle: getBoldStyle(
        color: ColorManager.white,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s10,
      ),

      // Body text
      weekdayStyle: getMediumStyle(
        color: ColorManager.light.withAlpha(200),
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s8,
      ),
      dayStyle: getRegularStyle(
        color: ColorManager.white,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s6,
      ),
      yearStyle: getRegularStyle(
        color: ColorManager.white,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s7,
      ),

      // Day cell shape
      dayShape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RadiusSize.r16)),
        ),
      ),

      // Today highlight
      todayForegroundColor: WidgetStatePropertyAll(ColorManager.light),
      todayBorder: BorderSide(
        color: ColorManager.light,
        width: AppSize.s0_5,
      ), // supported prop
      // todayBackgroundColor: WidgetStatePropertyAll(Colors.transparent),

      // Selected day styling
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorManager.black;
        return ColorManager.white;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorManager.light;
        return Colors.transparent;
      }),
      dayOverlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return ColorManager.light.withAlpha(25);
        }
        if (states.contains(WidgetState.pressed)) {
          return ColorManager.light.withAlpha(35);
        }
        return null;
      }),

      // Year chip styling
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorManager.black;
        return ColorManager.white;
      }),

      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorManager.light;
        return Colors.transparent;
      }),
      dividerColor: ColorManager.light.withAlpha(40),

      // Buttons
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: ColorManager.light,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: ColorManager.light,
      ),
    ),

    // time picker theme
    timePickerTheme: TimePickerThemeData(
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: ColorManager.darkPrimary,
        textStyle: getBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s8,
          fontFamily: FontConstants.libertinusFamily,
        ),
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: ColorManager.darkPrimary,
        textStyle: getBoldStyle(
          color: ColorManager.primary,
          fontSize: FontSize.s8,
          fontFamily: FontConstants.libertinusFamily,
        ),
      ),
      backgroundColor: ColorManager.white,
      hourMinuteColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? ColorManager.primary
            : ColorManager.white,
      ),
      hourMinuteTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? ColorManager.white
            : ColorManager.primary,
      ),
      dayPeriodColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? ColorManager.primary
            : ColorManager.white,
      ),
      dayPeriodTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? ColorManager.white
            : ColorManager.primary,
      ),
      dialBackgroundColor: ColorManager.white,
      dialHandColor: ColorManager.primary,
      dialTextColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? ColorManager.white
            : ColorManager.primary,
      ),
      entryModeIconColor: ColorManager.primary,
      helpTextStyle: getMediumStyle(
        color: ColorManager.primary,
        fontFamily: FontConstants.libertinusFamily,
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
        side: BorderSide(color: ColorManager.primary),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.light.withAlpha(50),
      contentPadding: EdgeInsets.all(AppPadding.p4),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      border: InputBorder.none,
      floatingLabelStyle: getRegularStyle(
        color: ColorManager.black,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s8,
      ),
      hintStyle: getRegularStyle(
        color: ColorManager.grey,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s6,
      ),
      helperStyle: getBoldStyle(
        color: ColorManager.black,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s6,
      ),
      errorStyle: getRegularStyle(
        color: ColorManager.error,
        fontFamily: FontConstants.libertinusFamily,
        fontSize: FontSize.s6,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
          width: AppSize.s0_5,
        ),
        borderRadius: BorderRadius.circular(RadiusSize.r12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.lightPrimary,
          width: AppSize.s0_5,
        ),
        borderRadius: BorderRadius.circular(RadiusSize.r12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s0_5),
        borderRadius: BorderRadius.circular(RadiusSize.r12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.lightPrimary,
          width: AppSize.s0_5,
        ),
        borderRadius: BorderRadius.circular(RadiusSize.r12),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorManager.light),
        textStyle: WidgetStatePropertyAll(
          getSemiBoldStyle(
            color: ColorManager.light,
            fontFamily: FontConstants.libertinusFamily,
            fontSize: FontSize.s6,
          ),
        ),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: ColorManager.darkPrimary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ColorManager.light),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      titleTextStyle: getSemiBoldStyle(
        color: ColorManager.light,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
      contentTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
    ),

    // Dropdown Theme
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: getRegularStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s7,
        fontFamily: FontConstants.libertinusFamily,
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(ColorManager.white),
      overlayColor: WidgetStatePropertyAll(ColorManager.white),
    ),

    chipTheme: ChipThemeData(
      selectedColor: ColorManager.primary,
      backgroundColor: ColorManager.white,
      checkmarkColor: ColorManager.white,
      labelStyle: getRegularStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s6,
        fontFamily: FontConstants.libertinusFamily,
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorManager.darkPrimary,
      linearTrackColor: ColorManager.lightGrey,
      circularTrackColor: ColorManager.lightGrey,
      linearMinHeight: AppSize.s6,
      refreshBackgroundColor: ColorManager.white,
      circularTrackPadding: EdgeInsets.all(AppPadding.p4),
    ),
  );
}
