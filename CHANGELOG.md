## 2.1.0
* **NEW**: Added `BabelSelectableText` widget - a selectable text equivalent of `BabelText` with all the same customization features
* **NEW**: Added `BabelSelectableInline` widget - a widget that creates selectable inline text with babel formatting
* Support for text selection, copying, and all SelectableText-specific parameters (cursorColor, selectionControls, onSelectionChanged, etc.)
* Full compatibility with existing babel text features (styleMapping, onTapMapping, innerWidgetMapping, onHoverTooltipMapping)

## 2.0.2
"BabelWidget" fields are not required

## 2.0.1
Export "BabelWidget"

## 2.0.0
* **BREAKING CHANGE**: Changed `innerWidgetMapping` and `defaultWidgetMapping` to use `BabelWidget Function(BuildContext context, TextStyle currentStyle)` instead of `Widget Function(BuildContext context, TextStyle currentStyle)`. This allows for more control over widget alignment and baseline through the `BabelWidget` class.

## 1.0.0
* Initial release