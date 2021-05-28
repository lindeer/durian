part of durian;

class _StateColorItem {
  final Color color;
  final Set<MaterialState>? states;

  const _StateColorItem(this.color, this.states);
}

class _ResImpl implements AssembleResource {
  static final _digits = RegExp(r"\d+");
  final ThemeData _theme;
  final _stateColors = <String, MaterialStateProperty<Color?>>{};
  final _colors = <String, Color>{};

   _ResImpl(BuildContext context)
       : _theme = Theme.of(context);

  @override
  Color? operator [](String? key) => key == null ? null : _saveColor(key);

  @override
  MaterialStateProperty<Color?>? state(String key) => _stateColors[key];

  @override
  ThemeData get theme => _theme;

  @override
  double? size(String? value) {
    if (value == null) return null;
    if (value == "infinity") return double.infinity;

    final m = _digits.firstMatch(value);
    final v = m?[0];
    if (v == null || m == null) return null;
    final n = double.tryParse(v);
    if (n == null) return null;
    final unit = value.substring(m.end).trim();
    return unit.isEmpty ? n : _unitSize(n, unit);
  }

  double _unitSize(double v, String unit) {
    switch (unit) {
      case 'dp':
      case 'sp':
      case 'px':
      default:
    }
    return v;
  }

  @override
  IconData? icon(String? key) {
    final pos = key?.indexOf('icon/') ?? -1;
    if (key == null || pos < 0) {
      return null;
    }
    final prefix = key.substring(0, pos);
    final name = key.substring(pos + 5);

    if ('@flutter:' == prefix) {
      return sysIcons[name];
    }
  }

  @override
  String toString() => "{color=${_colors.toString()}, state=${_stateColors.toString()}}";

  void loadResource(String source) {
    final doc = XmlDocument.parse(source);
    final children = doc.rootElement.children.where((e) => e.nodeType == XmlNodeType.ELEMENT).whereType<XmlElement>();
    children.forEach((e) {
      final name = e.name.local;
      if (name == 'state') {
        final state = _colorState(e);
        final key = e.getAttribute('name');
        if (state != null && key != null) {
          _stateColors[key] = state;
        }
      } else if (name == 'color') {
        final key = e.getAttribute('name');
        final text = e.text.trim();
        _saveColor(text, name: key);
      }
    });
  }

  static Color? _parseColor(String str) {
    final first = str.codeUnitAt(0);
    if (first == _poundSign) {
      final text = str.substring(1);
      final value = text.length == 3 ? text.split('').map((e) => '$e$e').join('') : text;
      final color = int.tryParse(value, radix: 16)?.let((color) =>
      color <= 0xffffff ? Color(color).withAlpha(255) : Color(color));
      return color;
    }
    return null;
  }

  Color? _saveColor(String text, {String? name}) {
    if (text.isEmpty) return null;
    Color? color = _colors[text];
    if (color != null) {
      if (name != null) {
        _colors[name] = color;
      }
      return color;
    }
    if (text.startsWith(_flutterColorPrefix)) {
      final key = text.substring(_flutterColorPrefixLength);
      color = _builtinColors[key];
      if (color != null) {
        _colors[text] = color;
        if (name != null) {
          _colors[name] = color;
        }
      }
      return color;
    }
    if (text.startsWith(_resColorPrefix)) {
      final key = text.substring(_resColorPrefixLength);
      if (key == name) {
        print("name '$name' could not refer '$text'");
        return null;
      }
      color = _colors[key];
      if (color != null) {
        _colors[text] = color;
        if (name != null) {
          _colors[name] = color;
        }
      }
      return color;
    }
    color = _parseColor(text);
    if (color != null) {
      _colors[text] = color;
      if (name != null) {
        _colors[name] = color;
      }
    }
    return color;
  }

  _StateColorItem? _stateItem(XmlElement e) {
    final c = e.getAttribute("flutter:color");
    if (c == null) {
      return null;
    }
    final color = _saveColor(c);
    if (color == null) {
      return null;
    }
    final state = e.getAttribute("flutter:state");
    if (state == null || state.isEmpty) {
      return _StateColorItem(color, null);
    }

    final states = state.split('|').map((key) => _materialState[key.trim()]).whereType<MaterialState>().toSet();
    return _StateColorItem(color, states);
  }

  MaterialStateProperty<Color?>? _colorState(XmlElement e) {
    final colors = <_StateColorItem>[];
    Color? defColor;
    e.children.whereType<XmlElement>().forEach((XmlElement child) {
      final item = _stateItem(child);
      if (item != null) {
        if (item.states == null) {
          defColor = item.color;
        } else {
          colors.add(item);
        }
      }
    });

    return colors.isEmpty ? null : MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      for (final c in colors) {
        if (states.containsAll(c.states!)) {
          return c.color;
        }
      }
      return defColor;
    });
  }
}
