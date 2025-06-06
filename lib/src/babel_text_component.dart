part of 'calculate_span_mixin.dart';

class BabelText extends StatelessWidget {
  const BabelText(
    this.text, {
    super.key,
    TextStyle? style,
    this.innerWidgetMapping,
    this.styleMapping,
    this.onTapMapping,
    this.onHoverTooltipMapping,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.padding,
  }) : baseTextStyle = style ?? const TextStyle();
  final String text;
  final Map<String, FutureOr<void> Function(BuildContext context)>?
  onTapMapping;
  final Map<
    String,
    TextStyle Function(BuildContext context, TextStyle currentStyle)
  >?
  styleMapping;
  final Map<
    String,
    BabelWidget Function(BuildContext context, TextStyle currentStyle)
  >?
  innerWidgetMapping;
  final Map<
    String,
    BabelTooltipMessage Function(BuildContext context, TextStyle currentStyle)
  >?
  onHoverTooltipMapping;
  final EdgeInsets? padding;
  final TextStyle baseTextStyle;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  @Deprecated(
    'Use textScaler instead. '
    'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
    'This feature was deprecated after v3.12.0-2.0.pre.',
  )
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = CalculateSpans._calculateSpans(
      context: context,
      text: text,
      baseTextStyle: baseTextStyle,
      onTapMapping: {
        ...BabelTextSettings.instance._defaultOnTapMapping,
        ...?onTapMapping,
      },
      customStyleMapping: {
        ...BabelTextSettings.instance._defaultSytleMapping,
        ...?styleMapping,
      },
      innerWidgetMapping: {
        ...BabelTextSettings.instance._defaultWidgetMapping,
        ...?innerWidgetMapping,
      },
      onHoverTooltipMapping: {
        ...BabelTextSettings.instance._defaultOnHoverTooltipMapping,
        ...?onHoverTooltipMapping,
      },
    );

    if (padding != null && padding != EdgeInsets.zero) {
      return Padding(
        padding: padding!,
        child: Text.rich(
          TextSpan(children: spans, style: baseTextStyle),
          style: baseTextStyle,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          // ignore: deprecated_member_use, deprecated_member_use_from_same_package
          textScaleFactor: textScaleFactor,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans, style: baseTextStyle),
      style: baseTextStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
