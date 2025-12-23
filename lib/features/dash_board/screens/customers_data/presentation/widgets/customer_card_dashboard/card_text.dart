import 'package:flutter/material.dart';

class CardText extends StatelessWidget {
  const CardText({super.key, required this.text, required this.itemText});

  final dynamic itemText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      '$text : ${itemText ?? ''}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
