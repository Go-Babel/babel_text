// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BabelTooltipMessage {
  final String content;
  final GestureRecognizer? recognizer;
  final MouseCursor? mouseCursor;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final String? semanticsLabel;
  final Locale? locale;
  final bool? spellOut;
  const BabelTooltipMessage(
    this.content, {
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.semanticsLabel,
    this.locale,
    this.spellOut,
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
    );
  }

  @override
  String toString() {
    return 'BabelTooltip(content: $content, recognizer: $recognizer, mouseCursor: $mouseCursor, onEnter: $onEnter, onExit: $onExit, semanticsLabel: $semanticsLabel, locale: $locale, spellOut: $spellOut)';
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
        other.spellOut == spellOut;
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
        spellOut.hashCode;
  }
}
