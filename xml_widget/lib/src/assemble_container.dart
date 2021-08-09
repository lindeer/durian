part of durian;

class _XmlContainerBuilder extends CommonWidgetBuilder {
  const _XmlContainerBuilder() : super('Container');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    return Container(
      child: descendant.isEmpty ? null : descendant.first.child,
      alignment: _alignment[attrs['alignment']],
      padding: _PropertyStruct.padding(res, attrs),
      decoration: _PropertyStruct.boxDecoration(res, attrs),
      color: res[attrs['color']],
      width: res.size(attrs['width']),
      height: res.size(attrs['height']),
      constraints: _PropertyStruct.constraints(res, attrs),
      margin: _PropertyStruct.margin(res, attrs),
      transformAlignment: _alignment[attrs['transformAlignment']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlInkBuilder extends CommonWidgetBuilder {
  const _XmlInkBuilder() : super('Ink');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    return Ink(
      child: descendant.isEmpty ? null : descendant.first.child,
      padding: _PropertyStruct.padding(res, attrs),
      color: res[attrs['color']],
      decoration: _PropertyStruct.boxDecoration(res, attrs),
      width: res.size(attrs['width']),
      height: res.size(attrs['height']),
    );
  }
}

class _XmlMaterialButtonBuilder extends CommonWidgetBuilder {
  const _XmlMaterialButtonBuilder() : super('MaterialButton');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final op = buildContext.interaction;
    final pressFn = op.onPressed;
    final pressUri = attrs["onPressed"];
    final onPressed = pressFn != null && pressUri != null ? () => pressFn.call(buildContext, pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final longPressFn = op.onLongPressed;
    final onLongPressed =
        longPressFn != null && longPressUri != null ? () => longPressFn.call(buildContext, longPressUri) : null;

    return MaterialButton(
      child: descendant.isEmpty ? null : descendant.first.child,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      textTheme: _buttonTextTheme[attrs['textTheme']],
      textColor: res[attrs['textColor']],
      disabledTextColor: res[attrs['disabledTextColor']],
      color: res[attrs['color']],
      disabledColor: res[attrs['disabledColor']],
      focusColor: res[attrs['focusColor']],
      hoverColor: res[attrs['hoverColor']],
      highlightColor: res[attrs['highlightColor']],
      splashColor: res[attrs['splashColor']],
      colorBrightness: _brightness[attrs['colorBrightness']],
      elevation: res.size(attrs['elevation']),
      focusElevation: attrs['focusElevation']?.toDouble(),
      hoverElevation: attrs['hoverElevation']?.toDouble(),
      highlightElevation: attrs['highlightElevation']?.toDouble(),
      disabledElevation: attrs['disabledElevation']?.toDouble(),
      padding: _PropertyStruct.padding(res, attrs),
      visualDensity: _visualDensity[attrs['visualDensity']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
      autofocus: attrs['autofocus'] == "true",
      materialTapTargetSize: _materialTapTargetSize[attrs["materialTapTargetSize"]],
      animationDuration: attrs["animationDuration"]?.toDuration(),
      minWidth: res.size(attrs["minWidth"]),
      height: res.size(attrs["height"]),
      enableFeedback: attrs["enableFeedback"] != "false",
      shape: _PropertyStruct.shapeBorder(res, attrs),
    );
  }
}

class _XmlDeprecatedWidgetBuilder extends CommonWidgetBuilder {
  final String instead;

  const _XmlDeprecatedWidgetBuilder(String name, this.instead) : super(name);

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final op = buildContext.interaction;
    final pressFn = op.onPressed;
    final pressUri = attrs["onPressed"];
    final onPressed = pressFn != null && pressUri != null ? () => pressFn.call(buildContext, pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final longPressFn = op.onLongPressed;
    final onLongPressed =
        longPressFn != null && longPressUri != null ? () => longPressFn.call(buildContext, longPressUri) : null;

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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final op = buildContext.interaction;
    final pressFn = op.onPressed;
    final pressUri = attrs["onPressed"];
    final onPressed = pressFn != null && pressUri != null ? () => pressFn.call(buildContext, pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final longPressFn = op.onLongPressed;
    final onLongPressed =
        longPressFn != null && longPressUri != null ? () => longPressFn.call(buildContext, longPressUri) : null;
    final height = res.size(attrs['height']);
    final width = res.size(attrs['width']);
    final minSize = height == null && width == null ? null : Size(width ?? double.infinity, height ?? double.infinity);

    return TextButton(
      child: descendant.first.child,
      onPressed: onPressed,
      onLongPress: onLongPressed,
      autofocus: attrs['autofocus'] == "true",
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
      style: TextButton.styleFrom(
        backgroundColor: res[attrs['backgroundColor']],
        shape: _PropertyStruct.shapeBorder(res, attrs) as OutlinedBorder?,
        alignment: _alignment[attrs['alignment']],
        minimumSize: minSize,
      ),
    );
  }
}

class _XmlOutlinedButtonBuilder extends CommonWidgetBuilder {
  const _XmlOutlinedButtonBuilder() : super('OutlinedButton');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final op = buildContext.interaction;
    final pressFn = op.onPressed;
    final pressUri = attrs["onPressed"];
    final onPressed = pressFn != null && pressUri != null ? () => pressFn.call(buildContext, pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final longPressFn = op.onLongPressed;
    final onLongPressed =
        longPressFn != null && longPressUri != null ? () => longPressFn.call(buildContext, longPressUri) : null;

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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final padding = _PropertyStruct.padding(res, attrs);
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final op = buildContext.interaction;
    final pressFn = op.onPressed;
    final pressUri = attrs["onTap"];
    final onPressed = pressFn != null && pressUri != null ? () => pressFn.call(buildContext, pressUri) : null;
    final longPressUri = attrs["onLongPressed"];
    final longPressFn = op.onLongPressed;
    final onLongPressed =
        longPressFn != null && longPressUri != null ? () => longPressFn.call(buildContext, longPressUri) : null;

    return InkWell(
      child: descendant.isEmpty ? null : descendant.first.child,
      onTap: onPressed,
      onLongPress: onLongPressed,
      focusColor: res[attrs['focusColor']],
      hoverColor: res[attrs['hoverColor']],
      highlightColor: res[attrs['highlightColor']],
      splashColor: res[attrs['splashColor']],
      radius: res.size(attrs['radius']),
      borderRadius: _PropertyStruct._borderRadius(res, attrs),
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final op = buildContext.interaction;
    final handler = op.onPressed;
    final pressUri = attrs["onPressed"];
    final onPressed = handler != null && pressUri != null ? () => handler.call(buildContext, pressUri) : null;
    return FloatingActionButton(
      child: descendant.isEmpty ? null : descendant.first.child,
      onPressed: onPressed,
      tooltip: attrs['tooltip'],
      foregroundColor: res[attrs["foregroundColor"]],
      backgroundColor: res[attrs["backgroundColor"]],
      focusColor: res[attrs['focusColor']],
      hoverColor: res[attrs['hoverColor']],
      splashColor: res[attrs['splashColor']],
      elevation: res.size(attrs['elevation']),
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    return IntrinsicHeight(
      child: descendant.isEmpty ? null : descendant.first.child,
    );
  }
}

class _XmlAlignBuilder extends CommonWidgetBuilder {
  const _XmlAlignBuilder() : super('Align');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    if (descendant.isEmpty) {
      return ErrorWidget.withDetails(message: "Positioned should contain one child!");
    }
    return Positioned(
      child: descendant.first.child,
      left: res.size(attrs['left']),
      top: res.size(attrs['top']),
      right: res.size(attrs['right']),
      bottom: res.size(attrs['bottom']),
      width: res.size(attrs['width']),
      height: res.size(attrs['height']),
    );
  }
}

class _XmlSizedBoxBuilder extends CommonWidgetBuilder {
  const _XmlSizedBoxBuilder() : super('SizedBox');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;

    return SizedBox(
      child: descendant.isEmpty ? null : descendant.first.child,
      width: res.size(attrs['width']),
      height: res.size(attrs['height']),
    );
  }
}

class _XmlOpacityBuilder extends CommonWidgetBuilder {
  const _XmlOpacityBuilder() : super('Opacity');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
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

class _XmlClipOvalBuilder extends CommonWidgetBuilder {
  const _XmlClipOvalBuilder() : super('ClipOval');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;

    return ClipOval(
      child: descendant.isEmpty ? null : descendant.first.child,
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.antiAlias,
    );
  }
}

class _XmlClipRRectBuilder extends CommonWidgetBuilder {
  const _XmlClipRRectBuilder() : super('ClipRRect');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = buildContext.resource;
    final br = _PropertyStruct._borderRadius(res, attrs);

    return ClipRRect(
      child: descendant.isEmpty ? null : descendant.first.child,
      borderRadius: br ?? BorderRadius.zero,
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.antiAlias,
    );
  }
}
