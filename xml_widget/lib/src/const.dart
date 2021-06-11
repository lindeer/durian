part of durian;

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

const _poundSign = 0x23; // '#'
const _atSign = 0x40; // '@'

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

@visibleForTesting
const testColors = _builtinColors;

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

const _borderStyle = const {
  "none": BorderStyle.none,
  "solid": BorderStyle.solid,
};

const _blendMode = const {
  "clear": BlendMode.clear,
  "src": BlendMode.src,
  "dst": BlendMode.dst,
  "srcOver": BlendMode.srcOver,
  "dstOver": BlendMode.dstOver,
  "srcIn": BlendMode.srcIn,
  "dstIn": BlendMode.dstIn,
  "srcOut": BlendMode.srcOut,
  "dstOut": BlendMode.dstOut,
  "srcATop": BlendMode.srcATop,
  "dstATop": BlendMode.dstATop,
  "xor": BlendMode.xor,
  "plus": BlendMode.plus,
  "modulate": BlendMode.modulate,
  "overlay": BlendMode.overlay,
  "darken": BlendMode.darken,
  "lighten": BlendMode.lighten,
  "colorDodge": BlendMode.colorDodge,
  "colorBurn": BlendMode.colorBurn,
  "hardLight": BlendMode.hardLight,
  "softLight": BlendMode.softLight,
  "difference": BlendMode.difference,
  "exclusion": BlendMode.exclusion,
  "hue": BlendMode.hue,
  "saturation": BlendMode.saturation,
  "color": BlendMode.color,
  "luminosity": BlendMode.luminosity,
};

const _boxShape = const {
  "rectangle": BoxShape.rectangle,
  "circle": BoxShape.circle,
};

const _buttonTextTheme = const {
  "normal": ButtonTextTheme.normal,
  "primary": ButtonTextTheme.primary,
  "accent": ButtonTextTheme.accent,
};

const _brightness = const {
  "dark": Brightness.dark,
  "light": Brightness.light,
};

const _visualDensity = const {
  "standard": VisualDensity.standard,
  "comfortable": VisualDensity.comfortable,
  "compact": VisualDensity.compact,
};

const _materialTapTargetSize = const {
  "padded": MaterialTapTargetSize.padded,
  "shrinkWrap": MaterialTapTargetSize.shrinkWrap,
};

const _materialState = const {
  "hovered": MaterialState.hovered,
  "focused": MaterialState.focused,
  "pressed": MaterialState.pressed,
  "dragged": MaterialState.dragged,
  "selected": MaterialState.selected,
  "disabled": MaterialState.disabled,
  "error": MaterialState.error,
};

const _alignmentDirectional = const {
  "topStart": AlignmentDirectional.topStart,
  "topCenter": AlignmentDirectional.topCenter,
  "topEnd": AlignmentDirectional.topEnd,
  "centerStart": AlignmentDirectional.centerStart,
  "center": AlignmentDirectional.center,
  "centerEnd": AlignmentDirectional.centerEnd,
  "bottomStart": AlignmentDirectional.bottomStart,
  "bottomCenter": AlignmentDirectional.bottomCenter,
  "bottomEnd": AlignmentDirectional.bottomEnd,
};

const _stackFit = const {
  "loose": StackFit.loose,
  "expand": StackFit.expand,
  "passthrough": StackFit.passthrough,
};

const _axisDirection = const {
  "up": AxisDirection.up,
  "right": AxisDirection.right,
  "down": AxisDirection.down,
  "left": AxisDirection.left,
};

const _floatingActionButtonLocation = const {
  "startTop": FloatingActionButtonLocation.startTop,
  "miniStartTop": FloatingActionButtonLocation.miniStartTop,
  "centerTop": FloatingActionButtonLocation.centerTop,
  "miniCenterTop": FloatingActionButtonLocation.miniCenterTop,
  "endTop": FloatingActionButtonLocation.endTop,
  "miniEndTop": FloatingActionButtonLocation.miniEndTop,
  "startFloat": FloatingActionButtonLocation.startFloat,
  "miniStartFloat": FloatingActionButtonLocation.miniStartFloat,
  "centerFloat": FloatingActionButtonLocation.centerFloat,
  "miniCenterFloat": FloatingActionButtonLocation.miniCenterFloat,
  "endFloat": FloatingActionButtonLocation.endFloat,
  "miniEndFloat": FloatingActionButtonLocation.miniEndFloat,
  "startDocked": FloatingActionButtonLocation.startDocked,
  "miniStartDocked": FloatingActionButtonLocation.miniStartDocked,
  "centerDocked": FloatingActionButtonLocation.centerDocked,
  "miniCenterDocked": FloatingActionButtonLocation.miniCenterDocked,
  "endDocked": FloatingActionButtonLocation.endDocked,
  "miniEndDocked": FloatingActionButtonLocation.miniEndDocked,
};

const _drawerDragStartBehavior = const {
  "start": DragStartBehavior.start,
  "down": DragStartBehavior.down,
};

const _boxFit = const {
  "fill": BoxFit.fill,
  "contain": BoxFit.contain,
  "cover": BoxFit.cover,
  "fitWidth": BoxFit.fitWidth,
  "fitHeight": BoxFit.fitHeight,
  "none": BoxFit.none,
  "scaleDown": BoxFit.scaleDown,
};

const _imageRepeat = const {
  "repeat": ImageRepeat.repeat,
  "repeatX": ImageRepeat.repeatX,
  "repeatY": ImageRepeat.repeatY,
  "noRepeat": ImageRepeat.noRepeat,
};

const _filterQuality = const {
  "none": FilterQuality.none,
  "low": FilterQuality.low,
  "medium": FilterQuality.medium,
  "high": FilterQuality.high,
};

const _scrollViewKeyboardDismissBehavior = const {
  "manual": ScrollViewKeyboardDismissBehavior.manual,
  "onDrag": ScrollViewKeyboardDismissBehavior.onDrag,
};

const _flexFit = const {
  "tight": FlexFit.tight,
  "loose": FlexFit.loose,
};

const _borderShape = const {
  "circle": const CircleBorder(),
  "rectangle": const RoundedRectangleBorder(),
};

const _flutterColorPrefix = '@flutter:color/';
const _flutterColorPrefixLength = _flutterColorPrefix.length;
const _resColorPrefix = '@color/';
const _resColorPrefixLength = _resColorPrefix.length;

extension _StringExt on String {
  int? toInt() => int.tryParse(this);

  int optInt({defVal = 0.0}) => int.tryParse(this) ?? defVal;

  double? toDouble() => double.tryParse(this);

  double optDouble({defVal = 0.0}) => double.tryParse(this) ?? defVal;

  Duration? toDuration() {
    final n = int.tryParse(this);
    return n == null ? null : Duration(milliseconds: n);
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
