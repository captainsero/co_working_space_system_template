import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customers_column.dart';

class SearchByNumber extends StatelessWidget {
  const SearchByNumber({super.key, required this.widget});

  final CustomerColumn widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s70,
      height: AppSize.s15,
      child: Center(
        child: TextField(
          cursorHeight: AppSize.s7,
          cursorColor: Theme.of(context).colorScheme.tertiary,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
          controller: widget.searchController,
          decoration: InputDecoration(
            hintText: "Search by number",
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onSearchChanged,
        ),
      ),
    );
  }
}
