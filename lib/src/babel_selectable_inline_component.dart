part of 'calculate_span_mixin.dart';

class BabelSelectableInline extends StatelessWidget {
  const BabelSelectableInline({
    super.key,
    required this.text,
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
    // SelectableText specific parameters
    this.focusNode,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.onSelectionChanged,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
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

  // SelectableText specific parameters
  final FocusNode? focusNode;
  final bool showCursor;
  final bool autofocus;
  final int? minLines;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final DragStartBehavior dragStartBehavior;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final GestureTapCallback? onTap;
  final ScrollPhysics? scrollPhysics;
  final SelectionChangedCallback? onSelectionChanged;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final TextMagnifierConfiguration? magnifierConfiguration;

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

    return SelectableText.rich(
      TextSpan(children: spans, style: baseTextStyle),
      style: baseTextStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      // SelectableText specific parameters
      focusNode: focusNode,
      showCursor: showCursor,
      autofocus: autofocus,
      minLines: minLines,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      scrollPhysics: scrollPhysics,
      onSelectionChanged: onSelectionChanged,
      contextMenuBuilder: contextMenuBuilder,
      magnifierConfiguration: magnifierConfiguration,
    );
  }
}