part of durian;

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

bool _notDigit(int n) {
  final pos = n ^ 0x30;
  return pos < 0 || pos > 9;
}

extension _StringExt on String {

  Color? toColor() {
    if (this[0] != '#') {
      return null;
    }

    final text = substring(1);
    final value = text.length == 3 ? text.split('').map((e) => '$e$e').join('') : text;
    final color = int.tryParse(value, radix: 16)?.let((color) =>
    color <= 0xffffff ? Color(color).withAlpha(255) : Color(color));

    return color;
  }

  double? toSize() {
    int n = this.length;

    while (n-- > 0 && _notDigit(this.codeUnits[n])){}
    if (n > 0) {
      final num = n < length ? substring(0, n + 1) : this;
      final unit = n < length ? substring(n + 1) : '';
      return _unitSize(num, unit);
    } else {
      return null;
    }
  }

  static double? _unitSize(String num, String unit) {
    return double.tryParse(num)?.let((it) {
      double v = it;
      switch (unit) {
        case 'dp':
        case 'sp':
        case 'px':
        default:
      }
      return v;
    });
  }

  TextDirection? toTextDirection() {
    final s = this.toLowerCase();
    if (s == 'rtl') return TextDirection.rtl;
    else if (s == 'ltr') return TextDirection.ltr;
    else return null;
  }

  MainAxisAlignment? toMainAxisAlignment() {
    switch (this) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spaceBetween': return MainAxisAlignment.spaceBetween;
      case 'spaceAround': return MainAxisAlignment.spaceAround;
      case 'spaceEvenly': return MainAxisAlignment.spaceEvenly;
      default: return null;
    }
  }
}

extension _XmlElementExt on XmlElement {
  Map<String, String> get attrs => Map.fromEntries(attributes.map(
          (attr) => MapEntry(attr.name.local, attr.value)));
}

class _PropertyStruct {
  static TextStyle? toTextStyle(Map<String, String> attr) {
    const prefix = 'style.';
    final keys = attr.keys.where((k) => k.startsWith(prefix));
    if (keys.isEmpty) {
      return null;
    }
    final start = prefix.length;
    final style = {for (final k in keys) k.substring(start): attr[k]};
    return TextStyle(
      color: style['color']?.toColor(),
      backgroundColor: style['backgroundColor']?.toColor(),
      fontSize: style['fontSize']?.toSize(),
    );
  }
}
