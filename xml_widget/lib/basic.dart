part of durian;

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

bool _notDigit(int n) {
  final pos = n ^ 0x30;
  return pos < 0 || pos > 9;
}

const _builtinColors = <String, Color>{
  "transparent": Colors.transparent,
  "black": Colors.black,
  "black87": Colors.black87,
  "black54": Colors.black54,
  "black45": Colors.black45,
  "black38": Colors.black38,
  "black26": Colors.black26,
  "black12": Colors.black12,
  "white": Colors.white,
  "white70": Colors.white70,
  "white60": Colors.white60,
  "white54": Colors.white54,
  "white38": Colors.white38,
  "white30": Colors.white30,
  "white24": Colors.white24,
  "white12": Colors.white12,
  "white10": Colors.white10,

  "red": Colors.red,
  "pink": Colors.pink,
  "purple": Colors.purple,
  "deepPurple": Colors.deepPurple,
  "indigo": Colors.indigo,
  "blue": Colors.blue,
  "lightBlue": Colors.lightBlue,
  "cyan": Colors.cyan,
  "teal": Colors.teal,
  "green": Colors.green,
  "lightGreen": Colors.lightGreen,
  "lime": Colors.lime,
  "yellow": Colors.yellow,
  "amber": Colors.amber,
  "orange": Colors.orange,
  "deepOrange": Colors.deepOrange,
  "brown": Colors.brown,
  "grey": Colors.grey,
  "blueGrey": Colors.blueGrey,

  "redAccent": Colors.redAccent,
  "pinkAccent": Colors.pinkAccent,
  "purpleAccent": Colors.purpleAccent,
  "deepPurpleAccent": Colors.deepPurpleAccent,
  "indigoAccent": Colors.indigoAccent,
  "blueAccent": Colors.blueAccent,
  "lightBlueAccent": Colors.lightBlueAccent,
  "cyanAccent": Colors.cyanAccent,
  "tealAccent": Colors.tealAccent,
  "greenAccent": Colors.greenAccent,
  "lightGreenAccent": Colors.lightGreenAccent,
  "limeAccent": Colors.limeAccent,
  "yellowAccent": Colors.yellowAccent,
  "amberAccent": Colors.amberAccent,
  "orangeAccent": Colors.orangeAccent,
  "deepOrangeAccent": Colors.deepOrangeAccent,
};

extension _StringExt on String {

  Color? toColor() {
    if (this[0] != '#') {
      final key = startsWith('@color/') ? substring(7) : null;
      return _builtinColors[key];
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

extension _TextThemeExt on TextTheme {
  Map<String, TextStyle?> tighten() {
    final theme = this;
    return <String, TextStyle?>{
      "headline1": theme.headline1,
      "headline2": theme.headline2,
      "headline3": theme.headline3,
      "headline4": theme.headline4,
      "headline5": theme.headline5,
      "headline6": theme.headline6,
      "subtitle1": theme.subtitle1,
      "subtitle2": theme.subtitle2,
      "bodyText1": theme.bodyText1,
      "bodyText2": theme.bodyText2,
      "caption": theme.caption,
      "button": theme.button,
      "overline": theme.overline,
    };
  }
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
}
