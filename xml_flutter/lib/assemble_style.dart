part of durian;

class CSSStyle {
  final Map<String, String> _attrs;

  const CSSStyle(this._attrs);

  @override
  String toString() => _attrs.toString();

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
    final left = _getDouble('$property-left');
    final top = _getDouble('$property-top');
    final right = _getDouble('$property-right');
    final bottom = _getDouble('$property-bottom');
    final l = _sizeList(values);
    return EdgeInsets.only(
      left: left ?? l[0] ?? 0,
      top: top ?? l[1] ?? 0,
      right: right ?? l[2] ?? 0,
      bottom: bottom ?? l[3] ?? 0,
    );
  }

  /// return [bottomLeft, topLeft, topRight, bottomRight]
  /// return [left, top, right, bottom]
  List<double?> _sizeList(Iterable<double?>? values) {
    if (values == null || values.length < 2) {
      final v = values?.first;
      return [v, v, v, v];
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

    final values = _attrs['border-radius']?.split(' ').map((e) => double.tryParse(e));
    if (values == null) return null;

    final l = _sizeList(values);
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
}
