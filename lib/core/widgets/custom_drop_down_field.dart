import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
        contentPadding: EdgeInsets.all(AppPadding.p4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusSize.r12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: AppSize.s0_5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusSize.r12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: AppSize.s0_5,
          ),
        ),
      ),
      dropdownColor: Theme.of(context).primaryColorDark,
      style: Theme.of(context).textTheme.bodyMedium,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }
}
