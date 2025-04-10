part of 'calculate_span_mixin.dart';

class BabelTextSettings {
  static BabelTextSettings? _instance;
  BabelTextSettings._();
  static BabelTextSettings get instance => _instance ??= BabelTextSettings._();

  Map<String, TextStyle Function(BuildContext context, TextStyle currentStyle)>
  _defaultSytleMapping = {
    // Bold
    '<b>':
        (context, currentStyle) =>
            currentStyle.copyWith(fontWeight: FontWeight.bold),

    // Underline
    '<u>':
        (context, currentStyle) =>
            currentStyle.copyWith(decoration: TextDecoration.underline),

    // Italic
    '<i>':
        (context, currentStyle) =>
            currentStyle.copyWith(fontStyle: FontStyle.italic),

    // With primary color
    '<pC>':
        (context, currentStyle) =>
            currentStyle.copyWith(color: Theme.of(context).colorScheme.primary),

    // With secondary color
    '<sC>':
        (context, currentStyle) => currentStyle.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),

    // With tertiary color
    '<tC>':
        (context, currentStyle) => currentStyle.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
        ),

    // With grey color
    '<gC>':
        (context, currentStyle) =>
            currentStyle.copyWith(color: Theme.of(context).colorScheme.outline),
  };
  Map<String, Widget Function(BuildContext context, TextStyle currentStyle)>
  _defaultWidgetMapping = {};
  Map<String, FutureOr<void> Function(BuildContext context)>
  _defaultOnTapMapping = {};

  void defaultSytleMapping(
    Map<
      String,
      TextStyle Function(BuildContext context, TextStyle currentStyle)
    >
    newStyleMapping,
  ) {
    _defaultSytleMapping = newStyleMapping;
  }

  void defaultWidgetMapping(
    Map<String, Widget Function(BuildContext context, TextStyle currentStyle)>
    newWidgetMapping,
  ) {
    _defaultWidgetMapping = newWidgetMapping;
  }

  void defaultOnTapMapping(
    Map<String, FutureOr<void> Function(BuildContext context)> newOnTapMapping,
  ) {
    _defaultOnTapMapping = newOnTapMapping;
  }
}
