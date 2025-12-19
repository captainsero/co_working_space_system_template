import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  const HeadText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
