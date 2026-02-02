import 'package:flutter/material.dart';

class WebLayout extends StatelessWidget {
  final Widget child;

  const WebLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // На мобильных не ограничиваем ширину
    if (width < 768) {
      return child;
    }

    // На десктопе применяем maxWidth: 1120
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: child,
      ),
    );
  }
}
