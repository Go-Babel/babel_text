import 'dart:async';
import 'dart:collection';
import 'package:babel_text/src/models/babel_tooltip.dart';
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
    required Map<String, FutureOr<void> Function(BuildContext context)>?
    onTapMapping,
    required Map<
      String,
      BabelTooltipMessage Function(BuildContext context, TextStyle currentStyle)
    >?
    onHoverTooltipMapping,
    required TextStyle baseTextStyle,
  }) {
    final List<InlineSpan> spans = [];
    final allStyleSymbols = customStyleMapping?.keys ?? [];
    final allInnerSymbols = innerWidgetMapping?.keys ?? [];
    final allOnTapSymbols = onTapMapping?.keys ?? [];
    final allOnHoverTooltipSymbols = onHoverTooltipMapping?.keys ?? [];
    final allSymbols = [
          ...allStyleSymbols,
          ...allInnerSymbols,
          ...allOnTapSymbols,
          ...allOnHoverTooltipSymbols,
        ]
        .join('|')
        .replaceAllMapped(
          RegExp(r'\*|\-|\+|\.'),
          (match) => '\\${match.group(0)}',
        );

    final pattern =
        r'(?<!\\)'
        '($allSymbols)';

    final LinkedHashMap<String, TextStyle> currentlyAppliedStyles =
        LinkedHashMap();
    final LinkedHashMap<String, BabelTooltipMessage> currentlyActiveTooltip =
        LinkedHashMap();
    final LinkedHashMap<String, FutureOr<void> Function(BuildContext context)>
    currentOnTapApplied = LinkedHashMap();
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

    // For each, let's get the one with the data not null.
    // If both are null, return null.
    BabelTooltipMessage? getTooltipMessageData() {
      final tooltipsJoined = currentlyActiveTooltip.values
          .map((t) => t.content)
          .join('');
      final tooltips = [...currentlyActiveTooltip.values];
      return tooltips.isNotEmpty
          ? BabelTooltipMessage(
            tooltipsJoined,
            recognizer:
                tooltips
                    .where((t) => t.recognizer != null)
                    .firstOrNull
                    ?.recognizer,
            mouseCursor:
                tooltips
                    .where((t) => t.mouseCursor != null)
                    .firstOrNull
                    ?.mouseCursor,
            onEnter:
                tooltips.where((t) => t.onEnter != null).firstOrNull?.onEnter,
            onExit: tooltips.where((t) => t.onExit != null).firstOrNull?.onExit,
            semanticsLabel:
                tooltips
                    .where((t) => t.semanticsLabel != null)
                    .firstOrNull
                    ?.semanticsLabel,
            locale: tooltips.where((t) => t.locale != null).firstOrNull?.locale,
            spellOut:
                tooltips.where((t) => t.spellOut != null).firstOrNull?.spellOut,
          )
          : null;
    }

    BabelInlineSpan? getBabelInlineSpan() {
      final tooltipData = getTooltipMessageData();
      if (tooltipData == null) {
        return null;
      }
      return BabelInlineSpan(
        text: tooltipData.content,
        context: context,
        baseTextStyle: getCurrentStyle(),
        recognizer: tooltipData.recognizer,
        mouseCursor: tooltipData.mouseCursor,
        onEnter: tooltipData.onEnter,
        onExit: tooltipData.onExit,
        semanticsLabel: tooltipData.semanticsLabel,
        locale: tooltipData.locale,
        spellOut: tooltipData.spellOut,
        innerWidgetMapping: innerWidgetMapping,
        styleMapping: customStyleMapping,
        onTapMapping: onTapMapping,
        onHoverTooltipMapping: onHoverTooltipMapping,
      );
    }

    InlineSpan wrapComponentWithTooltipIfNeeded(InlineSpan child) {
      final babelInlineSpan = getBabelInlineSpan();
      final haveTooltip = babelInlineSpan != null;
      return haveTooltip
          ? WidgetSpan(
            child: Tooltip(
              richMessage: babelInlineSpan,
              child: Text.rich(child),
            ),
          )
          : child;
    }

    void saveCurrBuffer() {
      final func = getCurrentRecognizer();
      final span = TextSpan(
        text: currentbuffer.toString(),
        style: getCurrentStyle(),
        recognizer:
            func == null ? null : TapGestureRecognizer()
              ?..onTap = func,
      );

      spans.add(wrapComponentWithTooltipIfNeeded(span));
      currentbuffer.clear();
    }

    text.splitMapJoin(
      RegExp(pattern, multiLine: true),
      onMatch: (p0) {
        final matchName = p0.group(0)!;
        final isInnerWidget = allInnerSymbols.contains(matchName);
        final isStyle = allStyleSymbols.contains(matchName);
        final isOnTap = allOnTapSymbols.contains(matchName);
        final isOnHoverTooltip = allOnHoverTooltipSymbols.contains(matchName);

        if (isInnerWidget) {
          final babelInlineSpan = getBabelInlineSpan();
          final haveTooltip = babelInlineSpan != null;
          saveCurrBuffer();
          final child = innerWidgetMapping![matchName]!(
            context,
            getCurrentStyle(),
          );
          final rec = getCurrentRecognizer();
          spans.add(
            WidgetSpan(
              child:
                  rec == null
                      ? haveTooltip
                          ? Tooltip(richMessage: babelInlineSpan, child: child)
                          : child
                      : haveTooltip
                      ? Tooltip(
                        richMessage: babelInlineSpan,
                        child: InkWell(onTap: rec, child: child),
                      )
                      : InkWell(onTap: rec, child: child),
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
        } else if (isOnHoverTooltip) {
          final isOpen = currentlyActiveTooltip.containsKey(matchName);
          if (isOpen) {
            saveCurrBuffer();
            currentlyActiveTooltip.remove(matchName);
          } else {
            saveCurrBuffer();
            final tooltip = onHoverTooltipMapping![matchName]!(
              context,
              getCurrentStyle(),
            );
            currentlyActiveTooltip[matchName] = tooltip;
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
