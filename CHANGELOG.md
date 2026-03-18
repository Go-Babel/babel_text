## 2.2.0
* Added per-tooltip `TooltipThemeData` overrides through `BabelTooltipMessage.tooltipTheme`.
* Added `BabelTooltipMessage.contentTextStyle` to control the rich text style rendered inside a tooltip.
* Added global tooltip text style configuration with `BabelTextSettings.defaultTooltipTextStyleSource`.
* Added `BabelTooltipTextStyleSource` so tooltips can use Flutter's tooltip styling or the legacy trigger text styling.
* Added tests covering tooltip styling behavior for both `BabelText` and `BabelSelectableText`.
* Warning: tooltip text styling now defaults to Flutter's tooltip theme/default behavior. To keep the previous behavior, switch to `BabelTooltipTextStyleSource.triggerTextStyle`.

## 2.1.2
* Fixed `onTapMapping` parsing for symbols that contain regex-special characters.
* Fixed combined `styleMapping` and `onTapMapping` usage when both share the same marker.
* Added interaction tests covering complex rich-text tap scenarios for `BabelText` and `BabelSelectableText`.

## 2.1.1
* Added package logo/screenshot for pub.dev

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
