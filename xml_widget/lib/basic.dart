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

const _textDirection = const {
  "ltr": TextDirection.ltr,
  "rtl": TextDirection.rtl,
};

const _verticalDirection = const {
  "up": VerticalDirection.up,
  "down": VerticalDirection.down,
};

const _textBaseline = const {
  "alphabetic": TextBaseline.alphabetic,
  "ideographic": TextBaseline.ideographic,
};

const _axis = const {
  "horizontal": Axis.horizontal,
  "vertical": Axis.vertical,
};

const _mainAxisAlignment = const {
  "start": MainAxisAlignment.start,
  "end": MainAxisAlignment.end,
  "center": MainAxisAlignment.center,
  "spaceBetween": MainAxisAlignment.spaceBetween,
  "spaceAround": MainAxisAlignment.spaceAround,
  "spaceEvenly": MainAxisAlignment.spaceEvenly,
};

const _mainAxisSize = const {
  "min": MainAxisSize.min,
  "max": MainAxisSize.max,
};

const _crossAxisAlignment = const {
  "start": CrossAxisAlignment.start,
  "end": CrossAxisAlignment.end,
  "center": CrossAxisAlignment.center,
  "stretch": CrossAxisAlignment.stretch,
  "baseline": CrossAxisAlignment.baseline,
};

const _wrapAlignment = const {
  "start": WrapAlignment.start,
  "end": WrapAlignment.end,
  "center": WrapAlignment.center,
  "spaceBetween": WrapAlignment.spaceBetween,
  "spaceAround": WrapAlignment.spaceAround,
  "spaceEvenly": WrapAlignment.spaceEvenly,
};

const _wrapCrossAlignment = const {
  "start": WrapCrossAlignment.start,
  "end": WrapCrossAlignment.end,
  "center": WrapCrossAlignment.center,
};

const _clip = const {
  "none": Clip.none,
  "hardEdge": Clip.hardEdge,
  "antiAlias": Clip.antiAlias,
  "antiAliasWithSaveLayer": Clip.antiAliasWithSaveLayer,
};

const _alignment = const {
  "topLeft": Alignment.topLeft,
  "topCenter": Alignment.topCenter,
  "topRight": Alignment.topRight,
  "centerLeft": Alignment.centerLeft,
  "center": Alignment.center,
  "centerRight": Alignment.centerRight,
  "bottomLeft": Alignment.bottomLeft,
  "bottomCenter": Alignment.bottomCenter,
  "bottomRight": Alignment.bottomRight,
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

  int? toInt() => int.tryParse(this);

  int optInt({defVal = 0.0}) => int.tryParse(this) ?? defVal;

  double? toDouble() => double.tryParse(this);

  double optDouble({defVal = 0.0}) => double.tryParse(this) ?? defVal;

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

  TextDirection? toTextDirection() => _textDirection[this];

  VerticalDirection? toVerticalDirection() => _verticalDirection[this];

  Axis? toAxis() => _axis[this];

  MainAxisAlignment? toMainAxisAlignment() => _mainAxisAlignment[this];

  WrapAlignment? toWrapAlignment() => _wrapAlignment[this];

  WrapCrossAlignment? toWrapCrossAlignment() => _wrapCrossAlignment[this];

  Clip? toClip() => _clip[this];
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
