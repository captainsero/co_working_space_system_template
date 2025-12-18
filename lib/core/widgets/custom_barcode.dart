import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color_manager.dart';
import 'package:team_egypt_v3/core/constants/fonts_manager.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/style_manager.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class CustomBarcode extends StatelessWidget {
  const CustomBarcode({super.key, required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      padding: EdgeInsets.all(AppPadding.p2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusSize.r12),
        color: ColorManager.white,
      ),
      color: ColorManager.black,
      data: number,
      style: getMediumStyle(
        color: ColorManager.black,
        fontFamily: FontConstants.arvoFamily,
      ),
      barcode: Barcode.code128(),
      width: ScreenSize.width / 5,
      height: ScreenSize.height / 6,
    );
  }
}