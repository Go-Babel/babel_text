import 'package:flutter/material.dart';

class BabelWidget {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;
  final Widget child;
  const BabelWidget({
    required this.alignment,
    required this.baseline,
    required this.child,
  });

  BabelWidget copyWith({
    PlaceholderAlignment? alignment,
    TextBaseline? baseline,
    Widget? child,
  }) {
    return BabelWidget(
      alignment: alignment ?? this.alignment,
      baseline: baseline ?? this.baseline,
      child: child ?? this.child,
    );
  }

  WidgetSpan toWidgetSpam(TextStyle? style) {
    return WidgetSpan(
      alignment: alignment,
      baseline: baseline,
      child: child,
      style: style,
    );
  }
}
