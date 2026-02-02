import 'package:flutter/material.dart';

/// Helper для создания full-width layout с контентом в 1120px
///
/// Использование:
/// ```dart
/// Container(
///   width: double.infinity, // фон на весь экран
///   color: Colors.blue,
///   child: WebLayout.content(
///     padding: EdgeInsets.all(80),
///     child: YourContent(),
///   ),
/// )
/// ```
class WebLayout {
  /// Оборачивает контент в Container с maxWidth: 1120px
  /// и центрирует его
  static Widget content({required Widget child, EdgeInsetsGeometry? padding}) {
    return Builder(
      builder: (context) {
        final width = MediaQuery.of(context).size.width;

        // На мобильных не ограничиваем
        if (width < 768) {
          return padding != null
              ? Padding(padding: padding, child: child)
              : child;
        }

        // На десктопе ограничиваем 1120px и центрируем
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: padding != null
                ? Padding(padding: padding, child: child)
                : child,
          ),
        );
      },
    );
  }
}
