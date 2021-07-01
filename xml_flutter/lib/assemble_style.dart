part of durian;

class CSSStyle {
  final Map<String, String> _attrs;

  const CSSStyle(this._attrs);

  @override
  String toString() => _attrs.toString();

  bool get isEmpty => _attrs.isEmpty;

  String? operator[](String key) => _attrs[key];

  int optInt(String key, [int defVal = 0]) => _attrs[key]?.let((it) => int.tryParse(it)) ?? defVal;

  double _optDouble(String key, [double defVal = 0.0]) => (_attrs[key] as num?)?.toDouble() ?? defVal;

  double? _getDouble(String key) => _attrs[key]?.let((it) => double.tryParse(it));

  double? _percent(String key) => _attrs[key]?.let((it) {
    int pos = it.indexOf('%');
    return pos > 0
        ? double.tryParse(it.substring(0, pos))?.let((it) => it / 100)
        : double.tryParse(it);
  });

  double? get width => _getDouble('width');

  double? get height => _getDouble('height');

  EdgeInsetsGeometry? get padding => _edge('padding');

  EdgeInsetsGeometry? get margin => _edge('margin');

  EdgeInsetsGeometry? _edge(String property) {
    final keys = _attrs.keys.where((k) => k.startsWith(property));
    if (keys.isEmpty) return null;

    final values = _attrs[property]?.split(' ').map((e) => double.tryParse(e));
    final l = _sizeList(values);
    if (l == null) return null;
    final left = _getDouble('$property-left');
    final top = _getDouble('$property-top');
    final right = _getDouble('$property-right');
    final bottom = _getDouble('$property-bottom');
    final edge = EdgeInsets.only(
      left: left ?? l[0] ?? 0,
      top: top ?? l[1] ?? 0,
      right: right ?? l[2] ?? 0,
      bottom: bottom ?? l[3] ?? 0,
    );
    return EdgeInsets.zero == edge ? null : edge;
  }

  /// return [bottomLeft, topLeft, topRight, bottomRight]
  /// return [left, top, right, bottom]
  List<double?>? _sizeList(Iterable<double?>? values) {
    if (values == null || values.length < 2) {
      final v = values?.first;
      return v == null || v == 0 ? null : [v, v, v, v];
    }
    if (values.length == 2) { // padding: v h
      final v = values.first;
      final h = values.last;
      return [h, v, h, v];
    }
    final l = values.toList(growable: false);
    if (values.length == 3) {
      return [l[1], l[0], l[1], l[2]];
    }
    return [l[3], l[0], l[1], l[2]];
  }


  BorderRadius? get borderRadius {
    final keys = _attrs.keys.where((k) => k.contains(RegExp(r'border*-radius')));
    if (keys.isEmpty) return null;

    final values = _attrs['border-radius']?.replaceAll('px', '').split(' ').map((e) => double.tryParse(e));
    if (values == null) return null;

    final l = _sizeList(values);
    if (l == null) return null;
    final topLeft = _percent('border-top-left-radius');
    final topRight = _percent('border-top-right-radius');
    final bottomRight = _percent('border-bottom-right-radius');
    final bottomLeft = _percent('border-bottom-left-radius');
    return BorderRadius.only(
      topLeft: (topLeft ?? l[1])?.let((it) => Radius.circular(it)) ?? Radius.zero,
      topRight: (topRight ?? l[2])?.let((it) => Radius.circular(it)) ?? Radius.zero,
      bottomRight: (bottomRight ?? l[3])?.let((it) => Radius.circular(it)) ?? Radius.zero,
      bottomLeft: (bottomLeft ?? l[3])?.let((it) => Radius.circular(it)) ?? Radius.zero,
    );
  }

  static const _poundSign = 0x23;
  Color? color(String key) => _toColor(_attrs[key]);

  static Color? _toColor(String? str) {
    if (str == null || str.isEmpty) return null;
    final first = str.codeUnitAt(0);
    if (first == _poundSign) {
      final text = str.substring(1);
      final value = text.length == 3 ? text.split('').map((e) => '$e$e').join('') : text;
      final color = int.tryParse(value, radix: 16)
          ?.let((color) => color <= 0xffffff ? Color(color).withAlpha(255) : Color(color));
      return color;
    }
  }

  static const _borderStyles = const {
    'none': BorderStyle.none,
    'solid': BorderStyle.solid,
  };

  BorderSide? _side(String name, BorderSide? opt) {
    final str = _attrs[name];
    if (str == null) return null;

    String? styleStr;
    String? widthStr;
    String? colorStr;

    _apply(String v) {
      if (_borderStyles.containsKey(v)) {
        // style = _borderStyles[v];
        styleStr = v;
      } else if ((v.codeUnitAt(0) ^ 0x30) <= 9) {
        // width = double.tryParse(v.replaceAll('px', ''));
        widthStr = v.replaceAll('px', '');
      } else if (_toColor(v) != null) {
        // color = _toColor(v);
        colorStr = v;
      }
    }
    if (str.contains(' ')) {
      str.split(' ').forEach(_apply);
    } else {
      _apply(str);
    }

    final _widthStr = _attrs['$name-width']?.replaceAll('px', '');
    BorderStyle? style = (_attrs['$name-style'] ?? styleStr)?.let((it) => _borderStyles[it]);
    double? width = (_widthStr ?? widthStr)?.let((it) => double.tryParse(it));
    Color? color = (_attrs['$name-color'] ?? colorStr)?.let((it) => _toColor(it));
    if (style != null || width != null || color != null) {
      return BorderSide(
        color: color ?? opt?.color ?? Colors.black,
        width: width ?? opt?.width ?? 1.0,
        style: style ?? opt?.style ?? BorderStyle.solid,
      );
    }
  }

  Border? get border {
    final all = _side('border', null);
    final left = _side('border-left', all) ?? all;
    final top = _side('border-top', all) ?? all;
    final right = _side('border-right', all) ?? all;
    final bottom = _side('border-bottom', all) ?? all;
    if (left != null || top != null || right != null || bottom != null) {
      return Border(
        left: left ?? BorderSide.none,
        top: top ?? BorderSide.none,
        right: right ?? BorderSide.none,
        bottom: bottom ?? BorderSide.none,
      );
    }
  }

  static bool _startsDigit(String? v) => v != null && v.isNotEmpty && (v.codeUnitAt(0) ^ 0x30) <= 9;

  List<BoxShadow>? get boxShadow {
    final shadowStr = _attrs['box-shadow']?.replaceAll('px', '');
    if (shadowStr == null) return null;

    final shadows = shadowStr.split(',').map((v) {
      final values = v.split(' ');
      if (values.length < 2) {
        return null;
      }
      final offset = Offset(
        values[0].let((it) => double.tryParse(it)) ?? 0,
        values[1].let((it) => double.tryParse(it)) ?? 0,
      );
      if (values.length == 2) {
        return BoxShadow(offset: offset);
      }
      final last = values.last;
      final endWithColor = !_startsDigit(last);
      final color = _toColor(last);
      final list = endWithColor ? values.sublist(0, values.length - 1) : values;

      final blur = list.length > 2 ? list[2].let((it) => double.tryParse(it)) : null;
      final spread = list.length > 3 ? list[3].let((it) => double.tryParse(it)) : null;

      return BoxShadow(
        offset: offset,
        blurRadius: blur ?? 0,
        spreadRadius: spread ?? 0,
        color: color ?? Colors.black,
      );
    }).whereType<BoxShadow>();

    return shadows.isEmpty ? null : shadows.toList(growable: false);
  }
}

/// style inherited from ancestor, e.g. text color
class AncestorStyle {
  final Color textColor;

  AncestorStyle._(this.textColor);

  static AncestorStyle? from(CSSStyle style, AncestorStyle? parent) {
    final color = style.color('color');
    return color?.let((it) => AncestorStyle._(it)) ?? parent;
  }
}
