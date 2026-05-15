import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class SearchByNumber extends StatelessWidget {
  const SearchByNumber({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final Function(String) onSearchChanged;

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
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search by number",
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.tertiary,
              size: AppSize.s7,
            ),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onSearchChanged,
        ),
      ),
    );
  }
}
