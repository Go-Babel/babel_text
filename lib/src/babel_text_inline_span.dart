part of 'calculate_span_mixin.dart';

class BabelInline extends TextSpan with CalculateSpans {
  BabelInline({
    required String text,
    required BuildContext context,
    TextStyle baseTextStyle = const TextStyle(),
    Map<
      String,
      TextStyle Function(BuildContext context, TextStyle currentStyle)
    >?
    styleMapping,
    Map<String, Widget Function(BuildContext context, TextStyle currentStyle)>?
    innerWidgetMapping,
    Map<String, FutureOr<void> Function(BuildContext context)>? onTapMapping,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  }) : super(
         style: baseTextStyle,
         children: CalculateSpans._calculateSpans(
           context: context,
           text: text,
           customStyleMapping: {
             ...BabelTextSettings.instance._defaultSytleMapping,
             ...?styleMapping,
           },
           innerWidgetMapping: {
             ...BabelTextSettings.instance._defaultWidgetMapping,
             ...?innerWidgetMapping,
           },
           onTapMapping: {
             ...BabelTextSettings.instance._defaultOnTapMapping,
             ...?onTapMapping,
           },
           baseTextStyle: baseTextStyle,
         ),
       );
}
