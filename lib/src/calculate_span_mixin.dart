import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'babel_text_component.dart';
part 'babel_text_inline_span.dart';
part 'babel_text_settings.dart';

const TextStyle _kBlankStyle = TextStyle();

mixin CalculateSpans {
  static List<InlineSpan> _calculateSpans({
    required String text,
    required BuildContext context,
    required Map<
      String,
      TextStyle Function(BuildContext context, TextStyle currentStyle)
    >?
    customStyleMapping,
    required Map<
      String,
      Widget Function(BuildContext context, TextStyle currentStyle)
    >?
    innerWidgetMapping,
    required TextStyle baseTextStyle,
    required Map<String, FutureOr<void> Function(BuildContext context)>?
    onTapMapping,
  }) {
    final List<InlineSpan> spans = [];
    final allStyleSymbols = customStyleMapping?.keys ?? [];
    final allInnerSymbols = innerWidgetMapping?.keys ?? [];
    final allOnTapSymbols = onTapMapping?.keys ?? [];
    final allSymbols = [
          ...allStyleSymbols,
          ...allInnerSymbols,
          ...allOnTapSymbols,
        ]
        .join('|')
        .replaceAllMapped(
          RegExp(r'\*|\-|\+|\.'),
          (match) => '\\${match.group(0)}',
        );

    final pattern =
        r'(?<!\\)'
        '($allSymbols)';

    final Map<String, TextStyle> currentlyAppliedStyles = {};
    final Map<String, FutureOr<void> Function(BuildContext context)>
    currentOnTapApplied = {};

    final StringBuffer currentbuffer = StringBuffer();

    TextStyle getCurrentStyle() {
      TextStyle currStyle = _kBlankStyle;

      for (final style in currentlyAppliedStyles.values) {
        currStyle = currStyle.merge(style);
      }
      return baseTextStyle.merge(currStyle);
    }

    FutureOr<void> Function()? getCurrentRecognizer() {
      final taps = [...currentOnTapApplied.values];
      return taps.isEmpty
          ? null
          : () async {
            for (final onTap in taps) {
              await onTap(context);
            }
          };
    }

    void saveCurrBuffer() {
      final func = getCurrentRecognizer();
      spans.add(
        TextSpan(
          text: currentbuffer.toString(),
          style: getCurrentStyle(),
          recognizer:
              func == null ? null : TapGestureRecognizer()
                ?..onTap = func,
        ),
      );
      currentbuffer.clear();
    }

    text.splitMapJoin(
      RegExp(pattern, multiLine: true),
      onMatch: (p0) {
        final matchName = p0.group(0)!;
        final isInnerWidget = allInnerSymbols.contains(matchName);
        final isStyle = allStyleSymbols.contains(matchName);
        final isOnTap = allOnTapSymbols.contains(matchName);

        if (isInnerWidget) {
          saveCurrBuffer();
          final rec = getCurrentRecognizer();
          spans.add(
            WidgetSpan(
              child:
                  rec == null
                      ? innerWidgetMapping![matchName]!(
                        context,
                        getCurrentStyle(),
                      )
                      : InkWell(
                        onTap: rec,
                        child: innerWidgetMapping![matchName]!(
                          context,
                          getCurrentStyle(),
                        ),
                      ),
            ),
          );
        } else if (isStyle) {
          final isOpen = currentlyAppliedStyles.containsKey(matchName);

          if (isOpen) {
            saveCurrBuffer();
            currentlyAppliedStyles.remove(matchName);
          } else {
            saveCurrBuffer();
            final style = customStyleMapping![matchName]!(
              context,
              getCurrentStyle(),
            );
            currentlyAppliedStyles[matchName] = style;
          }
        } else if (isOnTap) {
          final isOpen = currentOnTapApplied.containsKey(matchName);
          if (isOpen) {
            saveCurrBuffer();
            currentOnTapApplied.remove(matchName);
          } else {
            saveCurrBuffer();
            final onTap = onTapMapping![matchName]!;
            currentOnTapApplied[matchName] = onTap;
          }
        }

        return '';
      },
      onNonMatch: (p0) {
        // currentbuffer.write(p0.replaceAll(RegExp(r'(?<!\\)/'), ''));
        currentbuffer.write(p0);
        return '';
      },
    );

    saveCurrBuffer();

    return spans;
  }
}
