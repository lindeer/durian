part of durian;

class _PropertyStruct {
  static TextStyle? toTextStyle(AssembleResource res, Map<String, String> attr) {
    const prefix = 'style.';
    final keys = attr.keys.where((k) => k.startsWith(prefix));
    if (keys.isEmpty) {
      return null;
    }
    final start = prefix.length;
    final style = {for (final k in keys) k.substring(start): attr[k]};
    return TextStyle(
      color: res[style['color']],
      backgroundColor: res[style['backgroundColor']],
      fontSize: res.size(style['fontSize']),
    );
  }

  static TextTheme? _textTheme(ThemeData theme, String name) {
    switch (name) {
      case 'textTheme': return theme.textTheme;
      case 'primaryTextTheme': return theme.primaryTextTheme;
      case 'accentTextTheme': return theme.accentTextTheme;
      default: return null;
    }
  }

  static TextStyle? themeTextStyle(ThemeData theme, String text) {
    final secondary = text.split('.');
    return _textTheme(theme, secondary[0])?.tighten()[secondary[1]];
  }

  static EdgeInsetsGeometry? _edge(AssembleResource res, String property, Map<String, String> attr) {
    final keys = attr.keys.where((k) => k.startsWith(property));
    if (keys.isEmpty) {
      return null;
    }
    final padding = attr[property];
    final paddingLeft = attr['${property}Left'] ?? padding;
    final paddingTop = attr['${property}Top'] ?? padding;
    final paddingRight = attr['${property}Right'] ?? padding;
    final paddingBottom = attr['${property}Bottom'] ?? padding;
    return EdgeInsets.only(
      left: res.size(paddingLeft) ?? 0.0,
      top: res.size(paddingTop) ?? 0.0,
      right: res.size(paddingRight) ?? 0.0,
      bottom: res.size(paddingBottom) ?? 0.0,
    );
  }

  static EdgeInsetsGeometry? padding(AssembleResource res, Map<String, String> map) => _edge(res, 'padding', map);

  static EdgeInsetsGeometry? margin(AssembleResource res, Map<String, String> map) => _edge(res, 'margin', map);

  static BorderSide _side(AssembleResource res, String key, Map<String, String> attr) {
    final color = attr['$key.color'];
    final width = attr['$key.width'];
    final style = attr['$key.style'];

    return BorderSide(
      color: res[color] ?? Colors.black,
      width: width?.toDouble() ?? 1.0,
      style: _borderStyle[style] ?? BorderStyle.solid,
    );
  }

  static BoxBorder? _boxBorder(AssembleResource res, Map<String, String> attr) {
    final keys = attr.keys.where((k) => k.startsWith('border'));
    if (keys.isEmpty) {
      return null;
    }
    final borderKeys = keys.where((k) => k.startsWith('border.'));
    final side = borderKeys.isEmpty ? null : _side(res, 'border', attr);

    const keyLeft = 'borderLeft';
    const keyTop = 'borderTop';
    const keyRight = 'borderRight';
    const keyBottom = 'borderBottom';

    final leftKeys = keys.where((k) => k.startsWith(keyLeft));
    final left = leftKeys.isEmpty ? side : _side(res, keyLeft, attr);

    final topKeys = keys.where((k) => k.startsWith(keyTop));
    final top = topKeys.isEmpty ? side : _side(res, keyTop, attr);

    final rightKeys = keys.where((k) => k.startsWith(keyRight));
    final right = rightKeys.isEmpty ? side : _side(res, keyRight, attr);

    final bottomKeys = keys.where((k) => k.startsWith(keyBottom));
    final bottom = bottomKeys.isEmpty ? side : _side(res, keyBottom, attr);

    return left == null && top == null && right == null && bottom == null ? null :
    Border(
      left: left ?? BorderSide.none,
      top: top ?? BorderSide.none,
      right: right ?? BorderSide.none,
      bottom: bottom ?? BorderSide.none,
    );
  }

  static BorderRadius? _borderRadius(AssembleResource res, Map<String, String> attr) {
    final keys = attr.keys.where((k) => k.startsWith('radius'));
    if (keys.isEmpty) {
      return null;
    }
    final radius = attr['radius'];
    final topLeft = attr['radiusTopLeft'] ?? radius;
    final topRight = attr['radiusTopRight'] ?? radius;
    final bottomLeft = attr['radiusBottomLeft'] ?? radius;
    final bottomRight = attr['radiusBottomRight'] ?? radius;

    Radius _radius(String? s) {
      final r = res.size(s);
      return r == null ? Radius.zero : Radius.circular(r);
    }
    return BorderRadius.only(
      topLeft: _radius(topLeft),
      topRight: _radius(topRight),
      bottomLeft: _radius(bottomLeft),
      bottomRight: _radius(bottomRight),
    );
  }

  static BoxDecoration? boxDecoration(AssembleResource res, Map<String, String> attr) {
    const prefix = 'decoration.';
    final keys = attr.keys.where((k) => k.startsWith(prefix));
    if (keys.isEmpty) {
      return null;
    }
    const start = prefix.length;
    final style = {for (final k in keys) k.substring(start): attr[k]!};

    return BoxDecoration(
      color: res[style['color']],
      border: _boxBorder(res, style),
      borderRadius: _borderRadius(res, style),
      backgroundBlendMode: _blendMode[style['backgroundBlendMode']],
      shape: _boxShape[style['shape']] ?? BoxShape.rectangle,
    );
  }

  static BoxConstraints? constraints(AssembleResource res, Map<String, String> attr) {
    const prefix = 'constraints.';
    final keys = attr.keys.where((k) => k.startsWith(prefix));
    if (keys.isEmpty) {
      return null;
    }
    const start = prefix.length;
    final style = {for (final k in keys) k.substring(start): attr[k]!};
    final width = style['width'];
    final height = style['height'];
    final minWidth = style['minWidth'] ?? width;
    final maxWidth = style['maxWidth'] ?? width;
    final minHeight = style['minHeight'] ?? height;
    final maxHeight = style['maxHeight'] ?? height;
    return BoxConstraints(
      minWidth: res.size(minWidth) ?? 0.0,
      maxWidth: res.size(maxWidth) ?? double.infinity,
      minHeight: res.size(minHeight) ?? 0.0,
      maxHeight: res.size(maxHeight) ?? double.infinity,
    );
  }

  static BorderRadius? _borderRadius2(AssembleResource res, String? value) {
    final radiusValues = value?.split(' ');
    if (radiusValues == null || radiusValues.length == 0) {
      return null;
    }
    if (radiusValues.length == 1) {
      final r = res.size(radiusValues[0]);
      return r == null ? null : BorderRadius.circular(r);
    } else if (radiusValues.length == 2) {
      final t = res.size(radiusValues[0]) ?? 0.0;
      final b = res.size(radiusValues[1]) ?? 0.0;
      return BorderRadius.only(
        topLeft: Radius.circular(t),
        topRight: Radius.circular(t),
        bottomLeft: Radius.circular(b),
        bottomRight: Radius.circular(b),
      );
    } else if (radiusValues.length == 4) {
      final tl = res.size(radiusValues[0]) ?? 0.0;
      final tr = res.size(radiusValues[1]) ?? 0.0;
      final br = res.size(radiusValues[2]) ?? 0.0;
      final bl = res.size(radiusValues[3]) ?? 0.0;
      return BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomRight: Radius.circular(br),
        bottomLeft: Radius.circular(bl),
      );
    }
  }

  static BorderSide? _borderSide2(AssembleResource res, String? value) {
    final sideValues = value?.split(' ')?..removeWhere((e) => e.isEmpty);
    double? width;
    Color? color;
    BorderStyle? style;
    BorderSide? side;
    for (String v in (sideValues ?? List.empty())) {
      if ((v.codeUnitAt(0) ^ 0x30) <= 9) {
        width = double.tryParse(v);
      } else if (_borderStyle.keys.contains(v)) {
        style = _borderStyle[v];
      } else {
        color = res['v'];
      }
    }

    if (width != null || color != null || style != null) {
      side = BorderSide(
        width: width ?? 1.0,
        color: color ?? Colors.black,
        style: style ?? BorderStyle.solid,
      );
    }
    return side;
  }

  static ShapeBorder? shapeBorder(AssembleResource res, Map<String, String> attrs) {
    final shapeName = attrs["shape"];
    final _shape = _borderShape[shapeName];
    final side = _borderSide2(res, attrs["shape.side"]);

    var shape = side != null ? _shape?.copyWith(side: side) : _shape;
    if (shapeName == 'circle') {
      return shape;
    }

    BorderRadius? radius = _borderRadius2(res, attrs["shape.borderRadius"]);
    if (radius != null) {
      shape = (shape as RoundedRectangleBorder?)?.copyWith(borderRadius: radius);
    }
    return shape;
  }
}
