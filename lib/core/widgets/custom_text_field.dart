import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.tertiary,
      controller: controller,
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontWeight: FontWeight.w600,
      ),
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
      validator: validator,
    );
  }
}
