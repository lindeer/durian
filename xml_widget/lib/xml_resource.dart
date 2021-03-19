part of durian;

class _ColorItem {
  final String name;
  final Color color;

  _ColorItem(this.name, this.color);
}

class _StateColorItem {
  final Color color;
  final Set<MaterialState>? states;

  const _StateColorItem(this.color, this.states);
}

_StateColorItem? _stateItem(XmlElement e) {
  final c = e.getAttribute("flutter:color");
  final color = c?.toColor();
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

_ColorItem? _colorItem(XmlElement e) {
  final name = e.getAttribute('name');
  final text = e.text.trim();
  if (name == null || name.isEmpty || text.isEmpty) {
    return null;
  }
  final color = text.toColor();
  if (color == null) {
    return null;
  }
  return _ColorItem(name, color);
}

class XmlResColor {
  final _stateColors = <String, MaterialStateProperty<Color?>>{};
  final _colors = <String, Color>{};

  Color? operator [](String key) => _colors[key];

  MaterialStateProperty<Color?>? state(String key) => _stateColors[key];

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
        final color = _colorItem(e);
        if (color != null) {
          if (_colors.containsKey(color.name)) {
            print("color ${color.name} already defined!");
          }
          _colors[color.name] = color.color;
        }
      }
    });
  }
}
