import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  tearDown(() {
    BabelTextSettings.instance.defaultTooltipTextStyleSource(
      BabelTooltipTextStyleSource.flutterTooltipTheme,
    );
    BabelTextSettings.instance.defaultTooltipWaitDuration(null);
  });

  const complexScenarioSourceText =
      '''⚽️ Football social media that connects users with other users and clubs through selection partnerships.

<pC><b>Success app<b><pC> with more than <b>800 thousand downloads<b>.

In this application, among other things, I delivered:
 • <b>Brazilian Pix payment integration<b>
 • <b>Feed performance improvements<b>
 • <b>Club selection queries<b>
 • <b>Complete UI/UX refactor for user posts<b>
 • <b>In-app banner implementation<b>
 • <b>User rank / badge system<b>
 • <b>Crowdfunding across app and web<b>
 • <b>YouTube Shorts channel integration<b>

<soft>I even created the<soft> <youtubeShorts>youtube_shorts<youtubeShorts> <soft>package to encapsulate this logic.<soft>''';

  const complexScenarioRenderedText =
      '''⚽️ Football social media that connects users with other users and clubs through selection partnerships.

Success app with more than 800 thousand downloads.

In this application, among other things, I delivered:
 • Brazilian Pix payment integration
 • Feed performance improvements
 • Club selection queries
 • Complete UI/UX refactor for user posts
 • In-app banner implementation
 • User rank / badge system
 • Crowdfunding across app and web
 • YouTube Shorts channel integration

<soft>I even created the<soft> youtube_shorts <soft>package to encapsulate this logic.<soft>''';

  Offset findTextOffset(
    WidgetTester tester, {
    required Finder widgetFinder,
    required String fullText,
    required String targetText,
  }) {
    final element = tester.element(widgetFinder);
    final box = tester.renderObject<RenderBox>(widgetFinder);
    final start = fullText.indexOf(targetText);
    expect(start, isNonNegative);

    final textPainter = TextPainter(
      text: TextSpan(
        text: fullText,
        style: DefaultTextStyle.of(element).style,
      ),
      textDirection: Directionality.of(element),
    )..layout(maxWidth: box.size.width);

    final boxes = textPainter.getBoxesForSelection(
      TextSelection(baseOffset: start, extentOffset: start + targetText.length),
    );

    expect(boxes, isNotEmpty);

    final targetBox = boxes.first;
    return box.localToGlobal(targetBox.toRect().center);
  }

  testWidgets('BabelText tooltip uses Flutter tooltip styling by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          'Hello <tooltip>world<tooltip>',
          style: const TextStyle(color: Colors.red),
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => const BabelTooltipMessage('Tooltip content'),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
    final richMessage = tooltip.richMessage! as BabelInlineSpan;

    expect(richMessage.style, const TextStyle());
  });

  testWidgets('BabelText can keep the legacy trigger text tooltip style', (
    tester,
  ) async {
    BabelTextSettings.instance.defaultTooltipTextStyleSource(
      BabelTooltipTextStyleSource.triggerTextStyle,
    );

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          'Hello <tooltip>world<tooltip>',
          style: const TextStyle(color: Colors.red),
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => const BabelTooltipMessage('Tooltip content'),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
    final richMessage = tooltip.richMessage! as BabelInlineSpan;

    expect(richMessage.style?.color, Colors.red);
  });

  testWidgets('BabelTooltipMessage can override tooltip theme and text mode', (
    tester,
  ) async {
    const tooltipTextStyle = TextStyle(color: Colors.white, fontSize: 15);
    final tooltipDecoration = BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(10),
    );
    const tooltipPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          'Hello <tooltip>world<tooltip>',
          style: const TextStyle(color: Colors.red),
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => BabelTooltipMessage(
                  'Tooltip content',
                  textStyleSource: BabelTooltipTextStyleSource.triggerTextStyle,
                  contentTextStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  tooltipTheme: TooltipThemeData(
                    decoration: tooltipDecoration,
                    textStyle: tooltipTextStyle,
                    padding: tooltipPadding,
                  ),
                ),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
    final richMessage = tooltip.richMessage! as BabelInlineSpan;

    expect(tooltip.decoration, tooltipDecoration);
    expect(tooltip.textStyle, tooltipTextStyle);
    expect(tooltip.padding, tooltipPadding);
    expect(richMessage.style?.color, Colors.red);
    expect(richMessage.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('BabelSelectableText also applies tooltip theme overrides', (
    tester,
  ) async {
    const tooltipTextStyle = TextStyle(color: Colors.amber);

    await tester.pumpWidget(
      buildTestApp(
        BabelSelectableText(
          'Hello <tooltip>world<tooltip>',
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => const BabelTooltipMessage(
                  'Tooltip content',
                  tooltipTheme: TooltipThemeData(textStyle: tooltipTextStyle),
                ),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
    final richMessage = tooltip.richMessage! as BabelInlineSpan;

    expect(tooltip.textStyle, tooltipTextStyle);
    expect(richMessage.style, const TextStyle());
  });

  testWidgets('BabelText applies the global default tooltip wait duration', (
    tester,
  ) async {
    const waitDuration = Duration(milliseconds: 650);
    BabelTextSettings.instance.defaultTooltipWaitDuration(waitDuration);

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          'Hello <tooltip>world<tooltip>',
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => const BabelTooltipMessage('Tooltip content'),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));

    expect(tooltip.waitDuration, waitDuration);
  });

  testWidgets('Per-tooltip wait duration overrides the global default', (
    tester,
  ) async {
    BabelTextSettings.instance.defaultTooltipWaitDuration(
      const Duration(milliseconds: 650),
    );
    const localWaitDuration = Duration(milliseconds: 1200);

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          'Hello <tooltip>world<tooltip>',
          onHoverTooltipMapping: {
            '<tooltip>':
                (_, __) => const BabelTooltipMessage(
                  'Tooltip content',
                  tooltipTheme: TooltipThemeData(
                    waitDuration: localWaitDuration,
                  ),
                ),
          },
        ),
      ),
    );

    final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));

    expect(tooltip.waitDuration, localWaitDuration);
  });

  testWidgets('BabelText fires in complex scenario', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          complexScenarioSourceText,
          onTapMapping: {
            '<youtubeShorts>': (_) {
              tapCount += 1;
            },
          },
        ),
      ),
    );

    final targetOffset = findTextOffset(
      tester,
      widgetFinder: find.byType(Text),
      fullText: complexScenarioRenderedText,
      targetText: 'youtube_shorts',
    );

    await tester.tapAt(targetOffset);
    await tester.pumpAndSettle();

    expect(tapCount, 1);
  });

  testWidgets('BabelSelectableText fires in complex scenario', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        BabelSelectableText(
          complexScenarioSourceText,
          onTapMapping: {
            '<youtubeShorts>': (_) {
              tapCount += 1;
            },
          },
        ),
      ),
    );

    final targetOffset = findTextOffset(
      tester,
      widgetFinder: find.byType(SelectableText),
      fullText: complexScenarioRenderedText,
      targetText: 'youtube_shorts',
    );

    await tester.tapAt(targetOffset);
    await tester.pumpAndSettle();

    expect(tapCount, 1);
  });

  testWidgets('BabelText fires onTapMapping for mapped text', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        BabelText(
          '<action>Tap here<action>',
          onTapMapping: {
            '<action>': (_) {
              tapCount += 1;
            },
          },
        ),
      ),
    );

    await tester.tap(find.byType(Text));
    await tester.pumpAndSettle();

    expect(tapCount, 1);
  });

  testWidgets('BabelSelectableText fires onTapMapping for mapped text', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildTestApp(
        BabelSelectableText(
          '<action>Tap here<action>',
          onTapMapping: {
            '<action>': (_) {
              tapCount += 1;
            },
          },
        ),
      ),
    );

    await tester.tap(find.byType(SelectableText));
    await tester.pumpAndSettle();

    expect(tapCount, 1);
  });

  testWidgets(
    'inner widget onPressed works inside BabelSelectableText without onTapMapping',
    (tester) async {
      var pressCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          BabelSelectableText(
            'Before @@ after',
            innerWidgetMapping: {
              '@@':
                  (_, __) => BabelWidget(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        pressCount += 1;
                      },
                    ),
                  ),
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(pressCount, 1);
    },
  );

  testWidgets(
    'inner widget onPressed still works when wrapped by active onTapMapping',
    (tester) async {
      var pressCount = 0;
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          BabelSelectableText(
            'Before <action>@@<action> after',
            onTapMapping: {
              '<action>': (_) {
                tapCount += 1;
              },
            },
            innerWidgetMapping: {
              '@@':
                  (_, __) => BabelWidget(
                    child: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () {
                        pressCount += 1;
                      },
                    ),
                  ),
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pumpAndSettle();

      expect(pressCount, 1);
      expect(tapCount, 0);
    },
  );

  testWidgets(
    'BabelSelectableText supports the same marker in styleMapping and onTapMapping',
    (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          BabelSelectableText(
            '<action>Tap here<action>',
            styleMapping: {
              '<action>':
                  (_, currentStyle) =>
                      currentStyle.copyWith(fontWeight: FontWeight.bold),
            },
            onTapMapping: {
              '<action>': (_) {
                tapCount += 1;
              },
            },
          ),
        ),
      );

      await tester.tap(find.byType(SelectableText));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    },
  );

  testWidgets(
    'BabelSelectableText supports tap markers with regex characters',
    (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          BabelSelectableText(
            '(action)Tap here(action)',
            onTapMapping: {
              '(action)': (_) {
                tapCount += 1;
              },
            },
          ),
        ),
      );

      await tester.tap(find.byType(SelectableText));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    },
  );
}
