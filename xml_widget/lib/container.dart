part of durian;

class _XmlContainerBuilder extends CommonWidgetBuilder {
  const _XmlContainerBuilder() : super('Container');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return Container(
      child: descendant.isEmpty ? null : descendant.first.child,
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
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return Ink(
      child: descendant.isEmpty ? null : descendant.first.child,
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
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    return MaterialButton(
      child: descendant.isEmpty ? null : descendant.first.child,
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
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
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

class _XmlOutlineButtonBuilder extends _XmlDeprecatedWidgetBuilder {
  const _XmlOutlineButtonBuilder() : super('OutlineButton', 'OutlinedButton');
}

class _XmlElevatedButtonBuilder extends CommonWidgetBuilder {
  const _XmlElevatedButtonBuilder() : super('ElevatedButton');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    return ElevatedButton(
      child: descendant.isEmpty ? null : descendant.first.child,
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
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: '$name must have one child!');
    }

    return TextButton(
      child: descendant.first.child,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      autofocus: attrs['autofocus'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlOutlinedButtonBuilder extends CommonWidgetBuilder {
  const _XmlOutlinedButtonBuilder() : super('OutlinedButton');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: '$name must have one child!');
    }

    return OutlinedButton(
      child: descendant.first.child,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      autofocus: attrs['autofocus'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlPaddingBuilder extends CommonWidgetBuilder {
  const _XmlPaddingBuilder() : super('Padding');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final padding = _PropertyStruct.padding(attrs);
    if (padding == null) {
      return ErrorWidget.withDetails(message: 'Padding must have valid value!');
    }
    return Padding(
      padding: padding,
      child: descendant.isEmpty ? null : descendant.first.child,
    );
  }
}

class _XmlInkWellBuilder extends CommonWidgetBuilder {
  const _XmlInkWellBuilder() : super('InkWell');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onTap"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final onLongPressed = handler != null && longPressUri != null ? () => handler.onLongPressed(longPressUri) : null;

    return InkWell(
      child: descendant.isEmpty ? null : descendant.first.child,
      onTap: onPressed,
      onLongPress: onLongPressed,
      focusColor: attrs['focusColor']?.toColor(),
      hoverColor: attrs['hoverColor']?.toColor(),
      highlightColor: attrs['highlightColor']?.toColor(),
      splashColor: attrs['splashColor']?.toColor(),
      radius: attrs['radius']?.toSize(),
      borderRadius: _PropertyStruct._borderRadius(attrs),
      enableFeedback: attrs['enableFeedback'] == "false",
      excludeFromSemantics: attrs['excludeFromSemantics'] == "true",
      canRequestFocus: attrs['canRequestFocus'] == "false",
      autofocus: attrs['autofocus'] == "true",
    );
  }
}

class _XmlFloatingActionButtonBuilder extends CommonWidgetBuilder {
  const _XmlFloatingActionButtonBuilder() : super('FloatingActionButton');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final handler = element.context.onPressHandler;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.onPressed(pressUri) : null;
    return FloatingActionButton(
      child: descendant.isEmpty ? null : descendant.first.child,
      onPressed: onPressed,
      tooltip: attrs['tooltip'],
      foregroundColor: attrs["foregroundColor"]?.toColor(),
      backgroundColor: attrs["backgroundColor"]?.toColor(),
      focusColor: attrs['focusColor']?.toColor(),
      hoverColor: attrs['hoverColor']?.toColor(),
      splashColor: attrs['splashColor']?.toColor(),
      elevation: attrs['elevation']?.toSize(),
      focusElevation: attrs['focusElevation']?.toDouble(),
      hoverElevation: attrs['hoverElevation']?.toDouble(),
      highlightElevation: attrs['highlightElevation']?.toDouble(),
      disabledElevation: attrs['disabledElevation']?.toDouble(),
      mini: attrs['mini'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
      autofocus: attrs['autofocus'] == "true",
      materialTapTargetSize: _materialTapTargetSize[attrs["materialTapTargetSize"]],
      isExtended: attrs['isExtended'] == "true",
    );
  }
}

class _XmlCenterBuilder extends CommonWidgetBuilder {
  const _XmlCenterBuilder() : super('Center');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return Center(
      child: descendant.isEmpty ? null : descendant.first.child,
      widthFactor: attrs['widthFactor']?.toDouble(),
      heightFactor: attrs['heightFactor']?.toDouble(),
    );
  }
}

class _XmlIntrinsicWidthBuilder extends CommonWidgetBuilder {
  const _XmlIntrinsicWidthBuilder() : super('IntrinsicWidth');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return IntrinsicWidth(
      child: descendant.isEmpty ? null : descendant.first.child,
      stepWidth: attrs['stepWidth']?.toDouble(),
      stepHeight: attrs['stepHeight']?.toDouble(),
    );
  }
}

class _XmlIntrinsicHeightBuilder extends CommonWidgetBuilder {
  const _XmlIntrinsicHeightBuilder() : super('IntrinsicHeight');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    return IntrinsicHeight(
      child: descendant.isEmpty ? null : descendant.first.child,
    );
  }
}

class _XmlAlignBuilder extends CommonWidgetBuilder {
  const _XmlAlignBuilder() : super('Align');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return Align(
      child: descendant.isEmpty ? null : descendant.first.child,
      alignment: _alignment[attrs['alignment']] ?? Alignment.center,
      widthFactor: attrs['widthFactor']?.toDouble(),
      heightFactor: attrs['heightFactor']?.toDouble(),
    );
  }
}

class _XmlAspectRatioBuilder extends CommonWidgetBuilder {
  const _XmlAspectRatioBuilder() : super('AspectRatio');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final ratio = attrs['aspectRatio']?.toDouble();
    if (ratio == null) {
      return ErrorWidget.withDetails(message: "No aspectRatio value!");
    }
    return AspectRatio(
      child: descendant.isEmpty ? null : descendant.first.child,
      aspectRatio: ratio,
    );
  }
}

class _XmlFittedBoxBuilder extends CommonWidgetBuilder {
  const _XmlFittedBoxBuilder() : super('FittedBox');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    return FittedBox(
      child: descendant.isEmpty ? null : descendant.first.child,
      fit: _boxFit[attrs['fit']] ?? BoxFit.contain,
      alignment: _alignment[attrs['alignment']] ?? Alignment.center,
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlBaselineBuilder extends CommonWidgetBuilder {
  const _XmlBaselineBuilder() : super('Baseline');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final baseline = attrs['baseline']?.toDouble();
    final type = _textBaseline[attrs['baselineType']];
    if (baseline == null || type == null) {
      return ErrorWidget.withDetails(message: "Baseline should contain valid baseline value and baselineType!");
    }
    return Baseline(
      child: descendant.isEmpty ? null : descendant.first.child,
      baseline: baseline,
      baselineType: type,
    );
  }
}

class _XmlPositionedBuilder extends CommonWidgetBuilder {
  const _XmlPositionedBuilder() : super('Positioned');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: "Positioned should contain one child!");
    }
    return Positioned(
      child: descendant.first.child,
      left: attrs['left']?.toSize(),
      top: attrs['top']?.toSize(),
      right: attrs['right']?.toSize(),
      bottom: attrs['bottom']?.toSize(),
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
    );
  }
}

class _XmlSizedBoxBuilder extends CommonWidgetBuilder {
  const _XmlSizedBoxBuilder() : super('SizedBox');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: "Positioned should contain one child!");
    }
    return SizedBox(
      child: descendant.isEmpty ? null : descendant.first.child,
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
    );
  }
}

class _XmlOpacityBuilder extends CommonWidgetBuilder {
  const _XmlOpacityBuilder() : super('Opacity');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final opacity = attrs['opacity']?.toDouble();
    if (opacity == null) {
      return ErrorWidget.withDetails(message: "Opacity should have 'opacity' value!");
    }
    return Opacity(
      child: descendant.isEmpty ? null : descendant.first.child,
      opacity: opacity,
      alwaysIncludeSemantics: attrs['alwaysIncludeSemantics'] == "true",
    );
  }
}

class _XmlFlexibleBuilder extends CommonWidgetBuilder {
  const _XmlFlexibleBuilder() : super('Flexible');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: "Flexible should contain one child!");
    }
    return Flexible(
      child: descendant.first.child,
      flex: attrs['flex']?.toInt() ?? 1,
      fit: _flexFit[attrs['fit']] ?? FlexFit.loose,
    );
  }
}

class _XmlExpandedBuilder extends CommonWidgetBuilder {
  const _XmlExpandedBuilder() : super('Expanded');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: "Expanded should contain one child!");
    }
    return Expanded(
      child: descendant.first.child,
      flex: attrs['flex']?.toInt() ?? 1,
    );
  }
}
