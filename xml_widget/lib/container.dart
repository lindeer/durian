part of durian;

class _XmlContainerBuilder extends CommonWidgetBuilder {
  const _XmlContainerBuilder() : super('Container');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Container(
      child: children.isEmpty ? null : children.first,
      alignment: _alignment[attrs['alignment']],
      padding: _PropertyStruct.padding(attrs),
      decoration: _PropertyStruct.boxDecoration(attrs),
      color: attrs['color']?.toColor(),
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
      constraints: _PropertyStruct.constraints(attrs),
      margin: _PropertyStruct.margin(attrs),
      transformAlignment: _alignment[attrs['transformAlignment']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlInkBuilder extends CommonWidgetBuilder {
  const _XmlInkBuilder() : super('Ink');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Ink(
      child: children.isEmpty ? null : children.first,
      padding: _PropertyStruct.padding(attrs),
      color: attrs['color']?.toColor(),
      decoration: _PropertyStruct.boxDecoration(attrs),
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
    );
  }
}

class _XmlMaterialButtonBuilder extends CommonWidgetBuilder {
  const _XmlMaterialButtonBuilder() : super('MaterialButton');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    return MaterialButton(
      child: children.isEmpty ? null : children.first,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      textTheme: _buttonTextTheme[attrs['textTheme']],
      textColor: attrs['textColor']?.toColor(),
      disabledTextColor: attrs['disabledTextColor']?.toColor(),
      color: attrs['color']?.toColor(),
      disabledColor: attrs['disabledColor']?.toColor(),
      focusColor: attrs['focusColor']?.toColor(),
      hoverColor: attrs['hoverColor']?.toColor(),
      highlightColor: attrs['highlightColor']?.toColor(),
      splashColor: attrs['splashColor']?.toColor(),
      colorBrightness: _brightness[attrs['colorBrightness']],
      elevation: attrs['elevation']?.toSize(),
      focusElevation: attrs['focusElevation']?.toDouble(),
      hoverElevation: attrs['hoverElevation']?.toDouble(),
      highlightElevation: attrs['highlightElevation']?.toDouble(),
      disabledElevation: attrs['disabledElevation']?.toDouble(),
      padding: _PropertyStruct.padding(attrs),
      visualDensity: _visualDensity[attrs['visualDensity']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
      autofocus: attrs['autofocus'] == "true",
      materialTapTargetSize: _materialTapTargetSize[attrs["materialTapTargetSize"]],
      animationDuration: attrs["animationDuration"]?.toDuration(),
      minWidth: attrs["minWidth"]?.toSize(),
      height: attrs["height"]?.toSize(),
      enableFeedback: attrs["enableFeedback"] != "false",
    );
  }
}

class _XmlDeprecatedWidgetBuilder extends CommonWidgetBuilder {
  final String instead;

  const _XmlDeprecatedWidgetBuilder(String name, this.instead) : super(name);

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    return ErrorWidget.withDetails(
      message: '$name is deprecated, use $instead instead!',
    );
  }
}

class _XmlRaisedButtonBuilder extends _XmlDeprecatedWidgetBuilder {
  const _XmlRaisedButtonBuilder() : super('RaisedButton', 'ElevatedButton');
}

class _XmlFlatButtonBuilder extends _XmlDeprecatedWidgetBuilder {
  const _XmlFlatButtonBuilder() : super('FlatButton', 'TextButton');
}

class _XmlElevatedButtonBuilder extends CommonWidgetBuilder {
  const _XmlElevatedButtonBuilder() : super('ElevatedButton');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    return ElevatedButton(
      child: children.isEmpty ? null : children.first,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      autofocus: attrs['autofocus'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlTextButtonBuilder extends CommonWidgetBuilder {
  const _XmlTextButtonBuilder() : super('TextButton');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    if (children.isEmpty) {
      return ErrorWidget.withDetails(message: 'TextButton must have one child!');
    }

    return TextButton(
      child: children.first,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      autofocus: attrs['autofocus'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}
