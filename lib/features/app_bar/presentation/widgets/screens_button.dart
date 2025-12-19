import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';

class ScreensButton extends StatelessWidget {
  const ScreensButton({
    super.key,
    required this.screen,
    required this.title,
    required this.isSelected,
    required this.onSelected,
  });

  final Widget screen;
  final String title;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p2),
      child: isSelected
          ? ElevatedButton(
              onPressed: () {
                onSelected();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        screen,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: Duration(milliseconds: 200),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            )
          : TextButton(
              onPressed: () {
                onSelected();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        screen,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: Duration(milliseconds: 200),
                  ),
                );
              },
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
    );
  }
}
