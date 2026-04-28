import 'package:flutter/material.dart';

/// Shared shadows and surfaces so cards feel cohesive across the app.
abstract final class QuietDecorations {
  static List<BoxShadow> cardShadow(BuildContext context) {
    final color = Theme.of(context).colorScheme.shadow;
    return <BoxShadow>[
      BoxShadow(
        color: color.withValues(alpha: 0.12),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.06),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static BoxDecoration softCard(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardTheme.color ?? Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: cardShadow(context),
    );
  }
}
