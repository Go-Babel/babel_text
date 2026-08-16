import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'babel_text_component.dart';
part 'babel_text_inline_span.dart';
part 'babel_text_settings.dart';
part 'babel_selectable_text_component.dart';
part 'babel_selectable_inline_component.dart';
part 'models/babel_tooltip.dart';
part 'models/babel_widget.dart';

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
      BabelWidget Function(BuildContext context, TextStyle currentStyle)
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
    final allSymbols =
        {
            ...allStyleSymbols,
            ...allInnerSymbols,
            ...allOnTapSymbols,
            ...allOnHoverTooltipSymbols,
          }.toList()
          ..sort((left, right) => right.length.compareTo(left.length));

    if (allSymbols.isEmpty) {
      return [TextSpan(text: text, style: baseTextStyle)];
    }

    final pattern =
        r'(?<!\\)'
        '(${allSymbols.map(RegExp.escape).join('|')})';

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

    T? getLastNonNull<T>(Iterable<T?> values) {
      for (final value in values.toList().reversed) {
        if (value != null) {
          return value;
        }
      }
      return null;
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
            tooltipTheme: getLastNonNull(
              tooltips.map((tooltip) => tooltip.tooltipTheme),
            ),
            contentTextStyle: getLastNonNull(
              tooltips.map((tooltip) => tooltip.contentTextStyle),
            ),
            textStyleSource: getLastNonNull(
              tooltips.map((tooltip) => tooltip.textStyleSource),
            ),
          )
          : null;
    }

    TextStyle getTooltipBaseStyle(BabelTooltipMessage tooltipData) {
      final source =
          tooltipData.textStyleSource ??
          BabelTextSettings.instance._defaultTooltipTextStyleSource;

      switch (source) {
        case BabelTooltipTextStyleSource.flutterTooltipTheme:
          return tooltipData.contentTextStyle ?? _kBlankStyle;
        case BabelTooltipTextStyleSource.triggerTextStyle:
          return getCurrentStyle().merge(tooltipData.contentTextStyle);
      }
    }

    BabelInlineSpan? getBabelInlineSpan([BabelTooltipMessage? tooltipData]) {
      final effectiveTooltipData = tooltipData ?? getTooltipMessageData();
      if (effectiveTooltipData == null) {
        return null;
      }
      return BabelInlineSpan(
        text: effectiveTooltipData.content,
        context: context,
        baseTextStyle: getTooltipBaseStyle(effectiveTooltipData),
        recognizer: effectiveTooltipData.recognizer,
        mouseCursor: effectiveTooltipData.mouseCursor,
        onEnter: effectiveTooltipData.onEnter,
        onExit: effectiveTooltipData.onExit,
        semanticsLabel: effectiveTooltipData.semanticsLabel,
        locale: effectiveTooltipData.locale,
        spellOut: effectiveTooltipData.spellOut,
        innerWidgetMapping: innerWidgetMapping,
        styleMapping: customStyleMapping,
        onTapMapping: onTapMapping,
        onHoverTooltipMapping: onHoverTooltipMapping,
      );
    }

    Widget wrapWithTooltipIfNeeded({
      required Widget child,
      BabelTooltipMessage? tooltipData,
    }) {
      final effectiveTooltipData = tooltipData ?? getTooltipMessageData();
      final babelInlineSpan = getBabelInlineSpan(effectiveTooltipData);
      if (effectiveTooltipData == null || babelInlineSpan == null) {
        return child;
      }

      final tooltipTheme = effectiveTooltipData.tooltipTheme;
      final defaultTooltipWaitDuration =
          BabelTextSettings.instance._defaultTooltipWaitDuration;
      return Tooltip(
        richMessage: babelInlineSpan,
        constraints: tooltipTheme?.constraints,
        padding: tooltipTheme?.padding,
        margin: tooltipTheme?.margin,
        verticalOffset: tooltipTheme?.verticalOffset,
        preferBelow: tooltipTheme?.preferBelow,
        excludeFromSemantics: tooltipTheme?.excludeFromSemantics,
        decoration: tooltipTheme?.decoration,
        textStyle: tooltipTheme?.textStyle,
        textAlign: tooltipTheme?.textAlign,
        waitDuration: tooltipTheme?.waitDuration ?? defaultTooltipWaitDuration,
        showDuration: tooltipTheme?.showDuration,
        exitDuration: tooltipTheme?.exitDuration,
        triggerMode: tooltipTheme?.triggerMode,
        enableFeedback: tooltipTheme?.enableFeedback,
        child: child,
      );
    }

    InlineSpan wrapComponentWithTooltipIfNeeded(InlineSpan child) {
      final tooltipData = getTooltipMessageData();
      if (tooltipData == null) {
        return child;
      }

      return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: wrapWithTooltipIfNeeded(
          child: Text.rich(child),
          tooltipData: tooltipData,
        ),
      );
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
          final tooltipData = getTooltipMessageData();
          final haveTooltip = tooltipData != null;
          saveCurrBuffer();
          final BabelWidget babelWidget = innerWidgetMapping![matchName]!(
            context,
            getCurrentStyle(),
          );
          final rec = getCurrentRecognizer();

          final child =
              rec == null
                  ? haveTooltip
                      ? wrapWithTooltipIfNeeded(
                        child: babelWidget.child,
                        tooltipData: tooltipData,
                      )
                      : babelWidget.child
                  : haveTooltip
                  ? wrapWithTooltipIfNeeded(
                    child: InkWell(onTap: rec, child: babelWidget.child),
                    tooltipData: tooltipData,
                  )
                  : InkWell(onTap: rec, child: babelWidget.child);
          spans.add(
            BabelWidget(
              alignment: PlaceholderAlignment.middle,
              baseline: TextBaseline.alphabetic,
              child: child,
            ).toWidgetSpam(getCurrentStyle()),
          );
        } else {
          if (isStyle || isOnTap || isOnHoverTooltip) {
            saveCurrBuffer();
          }

          if (isStyle) {
            final isOpen = currentlyAppliedStyles.containsKey(matchName);

            if (isOpen) {
              currentlyAppliedStyles.remove(matchName);
            } else {
              final style = customStyleMapping![matchName]!(
                context,
                getCurrentStyle(),
              );
              currentlyAppliedStyles[matchName] = style;
            }
          }

          if (isOnTap) {
            final isOpen = currentOnTapApplied.containsKey(matchName);
            if (isOpen) {
              currentOnTapApplied.remove(matchName);
            } else {
              final onTap = onTapMapping![matchName]!;
              currentOnTapApplied[matchName] = onTap;
            }
          }

          if (isOnHoverTooltip) {
            final isOpen = currentlyActiveTooltip.containsKey(matchName);
            if (isOpen) {
              currentlyActiveTooltip.remove(matchName);
            } else {
              final tooltip = onHoverTooltipMapping![matchName]!(
                context,
                getCurrentStyle(),
              );
              currentlyActiveTooltip[matchName] = tooltip;
            }
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
