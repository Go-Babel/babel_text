// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../calculate_span_mixin.dart';

enum BabelTooltipTextStyleSource {
  /// Start from Flutter's tooltip text styling, using the app theme or
  /// tooltip defaults instead of inheriting the style from the trigger text.
  flutterTooltipTheme,

  /// Keep the legacy behavior and inherit the text style from the place where
  /// the tooltip is attached.
  triggerTextStyle,
}

class BabelTooltipMessage {
  final String content;
  final GestureRecognizer? recognizer;
  final MouseCursor? mouseCursor;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final String? semanticsLabel;
  final Locale? locale;
  final bool? spellOut;
  final TooltipThemeData? tooltipTheme;
  final TextStyle? contentTextStyle;
  final BabelTooltipTextStyleSource? textStyleSource;
  const BabelTooltipMessage(
    this.content, {
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.semanticsLabel,
    this.locale,
    this.spellOut,
    this.tooltipTheme,
    this.contentTextStyle,
    this.textStyleSource,
  });

  BabelTooltipMessage copyWith({
    String? content,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerExitEvent)? onExit,
    String? semanticsLabel,
    Locale? locale,
    bool? spellOut,
    TooltipThemeData? tooltipTheme,
    TextStyle? contentTextStyle,
    BabelTooltipTextStyleSource? textStyleSource,
  }) {
    return BabelTooltipMessage(
      content ?? this.content,
      recognizer: recognizer ?? this.recognizer,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      onEnter: onEnter ?? this.onEnter,
      onExit: onExit ?? this.onExit,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
      spellOut: spellOut ?? this.spellOut,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      textStyleSource: textStyleSource ?? this.textStyleSource,
    );
  }

  @override
  String toString() {
    return 'BabelTooltip(content: $content, recognizer: $recognizer, mouseCursor: $mouseCursor, onEnter: $onEnter, onExit: $onExit, semanticsLabel: $semanticsLabel, locale: $locale, spellOut: $spellOut, tooltipTheme: $tooltipTheme, contentTextStyle: $contentTextStyle, textStyleSource: $textStyleSource)';
  }

  @override
  bool operator ==(covariant BabelTooltipMessage other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        other.recognizer == recognizer &&
        other.mouseCursor == mouseCursor &&
        other.onEnter == onEnter &&
        other.onExit == onExit &&
        other.semanticsLabel == semanticsLabel &&
        other.locale == locale &&
        other.spellOut == spellOut &&
        other.tooltipTheme == tooltipTheme &&
        other.contentTextStyle == contentTextStyle &&
        other.textStyleSource == textStyleSource;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        recognizer.hashCode ^
        mouseCursor.hashCode ^
        onEnter.hashCode ^
        onExit.hashCode ^
        semanticsLabel.hashCode ^
        locale.hashCode ^
        spellOut.hashCode ^
        tooltipTheme.hashCode ^
        contentTextStyle.hashCode ^
        textStyleSource.hashCode;
  }
}
