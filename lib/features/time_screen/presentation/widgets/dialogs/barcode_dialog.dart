import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/core/widgets/custom_barcode.dart';

class BarcodeDialog extends StatelessWidget {
  const BarcodeDialog({super.key, required this.user});

  final UsersClass user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${user.name} Barcode"),
      content: CustomBarcode(number: user.number),
    );
  }
}


