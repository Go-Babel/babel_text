### ▶️ Babel_text: A package for easy dynamic text manipulation.
A easy and highly customizable ```Text``` compoent. Change dynamically styles, add intuitively onTap functions in texts, easly display tooltip messages and more!

### 🗂️ *Summary*
- [How to use]( #how-to-use)
    - [Mapping custom style](#mapping-custom-style)
    - [Mapping custom onTap](#mapping-custom-ontap)
    - [Mapping custom inner widgets](#mapping-custom-inner-widgets)
    - [Mapping custom tooltip hover text](#mapping-custom-tooltip-hover-text)
- [Combining styles](#combining-styles)
- [Inline span](#inline-span)
- [How to config default settings](#how-to-config-default-settings)
    - [What are the default settings?](#what-are-the-default-settings) ✨✨
    - [Add default settings with configuration method](#add-default-settings-with-configuration-method)
    - [Add default settings with a custom default widget](#add-default-settings-with-a-custom-default-widget)

# How to use
The usage of it *could not* be more simple.<br>See the bellow guide-lines<br>

# Mapping custom style
> ### Dynamic change text style
What to bold a text whenever you surround it with the _"*"_ caracter?
Just type the following code:

```dart
BabelText(
  text: 'This part is *bold*', 
  styleMapping: {
    '*': (context, currentStyle) =>
      currentStyle.copyWith(fontWeight: FontWeight.bold),
  },
),
```

# Mapping custom onTap
> ### Create "on text tap" callbacks
What to navigate to a screen when tapping a word? Surround
the target texts with a key that maps to an function!

```dart
BabelText(
  text: 'Hey! <navigateToHome>Tap here<navigateToHome> to go home check',
  onTapMapping: {
    '<navigateToHome>': (context) {
      Navigator.of(context).pushNamed('/home');
    },
  },
),
```

# Mapping custom inner widgets
> ### Display any widget between texts
You can add an widget _(💡 like an icon!)_ in any place in the text, between any words.<p>Just map it 
to whatever you want and use the mapped symbol in the text!<br>
In the example bellow, let's display a handshake icon widget.
```dart
BabelText(
  text: 'Handshake widget: @@. Amazing!',
  innerWidgetMapping: {
    '@@': (context, currentStyle) => const Icon(Icons.handshake),
  },
),
```

# Mapping custom tooltip hover text
> ### Display a tooltip message when the user hover's above an target text
You can add an widget _(💡 like an icon!)_ in any place in the text, between any words.<p>Just map it 
to whatever you want and use the mapped symbol in the text!<br>
In the example bellow, let's display a handshake icon widget.
```dart
BabelText(
  text: 'Hello <description>world!<description>',
  onHoverTooltipMapping: {
    '<description>': (context, currentStyle) {
      return BabelTooltipMessage(
        'I will be displayed when the user makes a hover action in the "world" text!',
      );
    },
  },
),
```

# Combining styles
You can combine syles without thinking to much about it. It works out of the box!
The styles will be amounted one above the other, just ensure you are using `copyWith()` in the mapper function.<p>
In the example bellow, it will first get the standard text style and make it bold, then, it will go to the italic style mapper, that takes the previous *accumulated style*, in the example case, the bold style, and will add above it the italic style.
```dart
BabelText(
  text: '<b><i>This<i><b> text is bold and italic!', 
  styleMapping: {
    '<b>': // Bold
        (context, currentStyle) =>
            currentStyle.copyWith(fontWeight: FontWeight.bold),
    '<i>': // Italic
        (context, currentStyle) =>
            currentStyle.copyWith(fontStyle: FontStyle.italic),
  },
),
```

# Inline span
What to use the Babel text as a text span?<br>No problem, you are covered with ```BabelInline``` inline span:

```dart
RichText(
  text: TextSpan(
    children: [
      BabelInline(
        text: '-hello-, tap <navigateToHome>here<navigateToHome> to go home check',
        context: context,
        innerWidgetMapping: {
          'check': (context, currentStyle) => const Icon(Icons.check),
        },
        styleMapping: {
          '-': (context, currentStyle) =>
            currentStyle.copyWith(decoration: TextDecoration.underline),
        },
        onTapMapping: {
          '<navigateToHome>': (context) {
            Navigator.of(context).pushNamed('/home');
          },
        },
      ),
    ]
  ),
),
```

# How to config default settings
You don't wan't to repeat yourself for default rules like bold text for example, right?<br>
Set it as a default setting! That will be always included in all Babel text's.<br><br>
You can make the default configurations mapping of theme, widgets and functions two ways.
Using the "_set settings function_", or with default widget.


## What are the default settings?
Some default sytle configurations are already made. You can change them if you wan't.
The default settings are:
- Bold<p>`<b>`bold`<b>`
- Underline<p>`<u>`Underline`<u>`
- Italic<p>`<i>`Italic`<i>`
- With primary color<p>`<pC>`With primary color`<pC>`
- With secondary color<p>`<sC>`With secondary color`<sC>`
- With tertiary color<p>`<tC>`With tertiary color`<tC>`
- With grey color<p>`<gC>`With grey color`<gC>`


## Add default settings with configuration method
Inside the main function, configure the default mapping.

> ⚠️ Note:<br>
> You are configurating the default, but adding other parameters in the BabelText widget/inline will not replace the default parameters. They will be used together and if you use the same key it will override the default configuration ONLY in that BabelText component.

```dart
void main() {

  /// Applied the methods
  BabelTextSettings.instance.defaultSytleMapping({
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
      });
      
  BabelTextSettings.instance.defaultOnTapMapping({
    '<indicateTap>': (context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Durations.long1,
          content: Text('Tapped'),
        ),
      );
    },
  });
  BabelTextSettings.instance.defaultWidgetMapping({
    'check': (context,currentStyle) => const Icon(Icons.check), 
    '@@': (context,currentStyle) => const Icon(Icons.ac_unit), 
  });
  BabelTextSettings.instance.defaultOnHoverTooltipMapping({
    '<tappable>': (context,currentStyle) => const BabelTooltipMessage('Click to open'),
  });
  runApp(const MyApp());
}
```

> ✅ Done<br>Then, inside your widget, use the Babel text normally and all the atributes made above will be applied.



## Add default settings with a custom default widget
Another way you can make the configuration is through a component that will wrap the BabelText.
This approach is more usefull when you allready have a compoennt that defines commum styles of text.

So, create a widget with the default configurations you wan't and use this component instead of regular ```Text``` button.

```dart
class MyCustomTextWidget extends StatelessWidget {
  const MyCustomTextWidget(
    this.text, {
    super.key,
    TextStyle? style,
    this.align,
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
  }) : style = style ?? const TextStyle();

  final String text;
  final TextStyle style;
  final TextAlign? align;
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
    return BabelText(
      text: text,
      baseTextStyle: style,
      onTapMapping: {
        'check': (context,currentStyle) => const Icon(Icons.check), 
        '@@': (context,currentStyle) => const Icon(Icons.ac_unit), 
      },
      onHoverTooltipMapping: {
        '<tappable>': (context, currentStyle) => const BabelTooltipMessage('Click to open'),
      },
      innerWidgetMapping: {
        '@@': (context, currentStyle) => Icon(
              Icons.open_in_new,
              color: currentStyle.color,
            ),
      },
      styleMapping: {
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
      },
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
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
```