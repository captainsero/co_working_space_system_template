import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  const HeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Customers Data",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
