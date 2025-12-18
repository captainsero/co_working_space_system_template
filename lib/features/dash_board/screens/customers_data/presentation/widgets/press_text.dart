import 'package:flutter/material.dart';

class PressText extends StatelessWidget {
  const PressText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Press Next To load The data.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
