part of durian;

typedef Widget FnWidgetBuilder(_AssembleElement e, List<Widget> children);

abstract class AssembleBuilder {
  Widget build(_AssembleElement e, List<Widget> children);

  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children);

  static XmlElement element(String name, Map<String, String> attrs, Iterable<XmlElement> children) {
    return XmlElement(
      XmlName.fromString(name),
      attrs.entries.map(attribute),
      children,
    );
  }

  static XmlAttribute attribute(MapEntry<String, String> e) =>
      XmlAttribute(XmlName.fromString('flutter:${e.key}'), e.value);
}

class TextAssembleBuilder implements AssembleBuilder {
  const TextAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    final style = e.style;
    final extra = e.extra;
    final inherited = e.inheritStyle;
    final color = style.color('color') ?? inherited?.textColor;
    final size = style._getDouble('font-size') ?? inherited?.fontSize;
    final lineHeight = style._getDouble('line-height') ?? inherited?.lineHeight;
    final sz = size ?? 14;
    final height = lineHeight?.let((it) => it > sz ? it : it * sz);
    final align = style['text-align'] ?? inherited?.textAlign;

    Widget w = Text(
      extra?['data'] ?? '',
      style: TextStyle(
        color: color,
        fontSize: size,
        height: 1,
      ),
    );
    if (height != null) {
      w = Container(
        height: height,
        alignment: _alignment[align] ?? (height > sz ? Alignment.centerLeft : null),
        child: w,
      );
    }
    return w;
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final style = e.style;
    final extra = e.extra;
    final inherited = e.inheritStyle;
    final color = style.color('color') ?? inherited?.textColor;
    final size = style._getDouble('font-size') ?? inherited?.fontSize;
    final lineHeight = style._getDouble('line-height') ?? inherited?.lineHeight;
    final sz = size ?? 14;
    final height = lineHeight?.let((it) => it > sz ? it : it * sz);
    final align = style['text-align'] ?? inherited?.textAlign;

    final attrs = {
      'data': extra?['data'] ?? '',
      'style.height': "1",
    }
      ..color(color, prefix: 'style.')
      ..attrDouble('style.fontSize', size);
    var node = AssembleBuilder.element('Text', attrs, children);
    if (height != null) {
      final _attrs = {
        'height': '$height',
      }..attr('alignment', align ?? (height > sz ? 'centerLeft' : null));
      node = AssembleBuilder.element('Container', _attrs, [node]);
    }
    return node;
  }

}

class ImageAssembleBuilder implements AssembleBuilder {
  const ImageAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    final style = e.style;
    final extra = e.extra;
    final src = extra?['src'] ?? '';
    final width = style.width;
    final height = style.height;
    if (src.startsWith('http')) {
      return Image.network(
        src,
        width: width,
        height: height,
      );
    }
    if (src.startsWith('@image/')) {
      final name = 'assets/images/${src.substring(7)}';
      return Image.asset(
        name,
        width: width,
        height: height,
      );
    }
    // fake Image by ColoredBox
    if (src.contains("{{")) {
      final color = (Random().nextDouble() * 0xFFFFFF).toInt();
      return SizedBox(
        width: width,
        height: height,
        child: ColoredBox(
          color: Color(color).withOpacity(1.0),
        ),
      );
    }
    return Image.file(
      File(src),
      width: width,
      height: height,
    );
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final extra = e.extra;
    final src = extra?['src'] ?? '';
    final attrs = {
      'src': src,
    };
    return AssembleBuilder.element('Image', attrs, children);
  }
}

class IconAssembleBuilder implements AssembleBuilder {
  const IconAssembleBuilder();

  static const _icons = {
    "home": Icons.house_outlined,
    "star": Icons.star_outline,
    "phone": Icons.call_outlined,
    "share": Icons.share_outlined,
    "emoji-add": Icons.add,
    "edit": Icons.edit,
    "right-arrow": Icons.keyboard_arrow_right,
  };

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    final style = e.style;
    final extra = e.extra;
    final size = style._optDouble('size', 24);
    final name = extra?['type'] ?? 'share';
    return Icon(
      _icons[name] ?? Icons.star,
      size: size,
      color: e.inheritStyle?.textColor,
    );
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final style = e.style;
    final extra = e.extra;
    final size = style._optDouble('size', 24);
    final name = extra?['type'] ?? 'share';
    final color = e.inheritStyle?.textColor;

    final attrs = {
      'icon': '@icon/$name',
    }..color(color)..attrDouble('size', size);
    return AssembleBuilder.element('Icon', attrs, children);
  }
}

class EmojiAssembleBuilder implements AssembleBuilder {
  const EmojiAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    return Icon(
      Icons.error_outline_outlined,
      size: 24,
      color: e.inheritStyle?.textColor,
    );
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final color = e.inheritStyle?.textColor;

    final attrs = {
      'icon': '@icon/error_outline_outlined',
    }..color(color);
    return AssembleBuilder.element('Icon', attrs, children);
  }
}

class ColumnAssembleBuilder implements AssembleBuilder {
  const ColumnAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final attrs = {
      'crossAxisAlignment': 'stretch',
    };
    return AssembleBuilder.element('Column', attrs, children);
  }
}

class BlockAssembleBuilder implements AssembleBuilder {
  const BlockAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    return children.first;
  }

  @override
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    if (children.length > 1) {
      print("<block> has more than one children, but take the first!");
    }
    return children.first;
  }
}

class AssembleTank {
  static final _defaultBuilders = const {
    'text': const TextAssembleBuilder(),
    'image': const ImageAssembleBuilder(),
    'icon': const IconAssembleBuilder(),
    'view': const ViewAssembleBuilder(),
    'emoji': const EmojiAssembleBuilder(),
    'block': const BlockAssembleBuilder(),
  };

  final Map<String, AssembleBuilder> builders;

  AssembleTank._(this.builders);

  factory AssembleTank({Map<String, AssembleBuilder>? builders}) {
    return AssembleTank._(builders ?? {});
  }

  Widget _assembleWidget(_AssembleElement element, int depth) {
    final name = element.name;
    final children = element.children
        .map((e) => _assembleWidget(e, depth + 1))
        .toList(growable: false);

    final builder = builders[name] ?? _defaultBuilders[name] ?? const ColumnAssembleBuilder();
    final style = element.style;
    final overflowY = style['overflow-y'];
    Widget w = depth == 0 && name == 'view' && overflowY != null
        ? ListView(children: children,)
        : builder.build(element, children);

    w = _CSSContainer(element: element, child: w, extra: element.extra,);
    return w;
  }

  Widget build(BuildContext context, _AssembleElement root) {
    if (root.name == '_floatStack') {
      var depth = 0;
      final children = root.children.map((e) => _assembleWidget(e, depth++)).toList(growable: false);
      return Stack(
        children: children,
      );
    }
    return _assembleWidget(root, 0);
  }

  XmlElement _assembleXml(_AssembleElement element, int depth) {
    final name = element.name;
    final children = element.children
        .map((e) => _assembleXml(e, depth + 1));

    final builder = builders[name] ?? _defaultBuilders[name] ?? const ColumnAssembleBuilder();
    final style = element.style;
    final overflowY = style['overflow-y'];
    final source = depth == 0 && name == 'view' && overflowY != null
        ? AssembleBuilder.element('ListView', const {}, children)
        : builder.assemble(element, children);

    final css = element.style;
    final padding = css.padding;
    final margin = css.margin;

    final flex = _CSSContainer._canFlex(css);
    final positionCSS = css['position'];
    final width = css.width;
    final height = css.height;

    final color = css.color('background-color') ?? css.color('background');
    final borderRadius = css.borderRadius;
    final border = css.border;
    final shadows = css.boxShadow;

    BoxDecoration? decoration;
    if (color != null || borderRadius != null || border != null || shadows != null) {
      decoration = BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadows,
      );
    }

    final borderBox = (css['box-sizing'] ?? 'content-box') == 'border-box';
    double? _width = width, _height = height;
    if (!borderBox) {
      final horizon = (padding?.horizontal ?? 0); // + (border?.let((it) => it.left.width + it.right.width) ?? 0);
      final vertical = (padding?.vertical ?? 0); // + (border?.let((it) => it.top.width + it.bottom.width) ?? 0);
      _width = width?.let((it) => it + horizon);
      _height = height?.let((it) => it + vertical);
    }
    final validSize = _width != null || _height != null;
    XmlElement wrap = source;
    if (padding != null || decoration != null || validSize) {
      final attrs = <String, String>{};
      if (padding != null) {
        attrs.edge(padding, 'padding');
      }
      if (decoration != null) {
        if (color != null) {
          attrs.color(color, prefix: 'decoration.');
        }
        if (borderRadius != null) {
          attrs.radius(borderRadius, prefix: 'decoration.');
        }
        if (border != null) {
          attrs.border(border, prefix: 'decoration.');
        }
      }
      if (_width != null) {
        attrs.attrDouble('width', _width);
      }
      if (_height != null) {
        attrs.attrDouble('height', _height);
      }
      wrap = AssembleBuilder.element('Ink', attrs, [wrap]);
    }

    final tap = element.extra?['bindtap'];
    if (tap != null) {
      wrap = AssembleBuilder.element('InkWell', {'onTap': tap}, [wrap]);
    }

    if (borderRadius != null) {
      wrap = AssembleBuilder.element('ClipRRect', {}..radius(borderRadius), [wrap]);
    }

    final marginCSS = css['margin'];
    if (marginCSS != null && marginCSS.contains('auto')) {
      wrap = AssembleBuilder.element('Center', {}, [wrap]);
    } else if (margin != null) {
      wrap = AssembleBuilder.element('Padding', {}..edge(margin, 'padding'), [wrap]);
    }

    if (flex > 0) {
      final attrs = {
        'flex': '$flex',
        'fit': 'tight',
      };
      wrap = AssembleBuilder.element('Flexible', attrs, [wrap]);
    } else if (positionCSS == 'absolute' || positionCSS == 'fixed') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      final attrs = <String, String>{}
        ..attrDouble('left', left)
        ..attrDouble('top', top)
        ..attrDouble('right', right)
        ..attrDouble('bottom', bottom);
      wrap = AssembleBuilder.element('Positioned', attrs, [wrap]);
    } else if (positionCSS == 'relative') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      final dx = left ?? right?.let((it) => -right);
      final dy = top ?? bottom?.let((it) => -bottom);
      if (dx != null || dy != null) {
        final attrs = <String, String>{}
          ..attrDouble('x', dx)
          ..attrDouble('y', dy);
        wrap = AssembleBuilder.element('Translate', attrs, [wrap]);
      }
    }

    element.extra?.controlFlow()
        ?.let(AssembleBuilder.attribute)
        .let(wrap.attributes.add);
    return wrap;
  }

  XmlElement assemble(_AssembleElement root) {
    XmlElement rootElement;
    if (root.name == '_floatStack') {
      var depth = 0;
      final children = root.children.map((e) => _assembleXml(e, depth++)).toList(growable: false);
      rootElement = AssembleBuilder.element('Stack', const {}, children);
    } else {
      rootElement = _assembleXml(root, 0);
    }
    final xmlns = XmlAttribute(XmlName.fromString('xmlns:flutter'), 'http://flutter.dev/xml/flutter');
    rootElement.attributes.add(xmlns);
    rootElement.children.add(_dialog());
    return rootElement;
  }

  XmlElement _dialog() {
    const xml = """
<Dialog flutter:name="name_card_select">
  <Column flutter:mainAxisAlignment="end">
    <Container
      flutter:decoration.color="@flutter:color/white"
      flutter:decoration.borderRadius="10">
      <Column flutter:crossAxisAlignment="stretch">
        <TextButton
          flutter:height="56"
          flutter:for="{{options}}"
          flutter:onPressed="item.onClick">
          <Text flutter:data="{{item.text}}"/>
        </TextButton>
      </Column>
    </Container>

    <SizedBox flutter:height="10"/>

    <Container
      flutter:decoration.color="@flutter:color/white"
      flutter:decoration.borderRadius="10">

      <TextButton
        flutter:height="56"
        flutter:onPressed="copyNickname">
        <Text flutter:data="取消"/>
      </TextButton>
    </Container>

    <SizedBox flutter:height="40"/>
  </Column>
</Dialog>
    """;
    final doc = XmlDocument.parse(xml);
    doc.rootElement.detachParent(doc);
    return doc.rootElement;
  }

  static String indentLines(Iterable<String> text, int indent) {
    final lines = [
      for (final str in text)
        ...(str.split('\n'))
    ];
    return lines.map((e) => e.padLeft(indent)).join('\n');
  }
}

class _CSSContainer extends StatelessWidget {
  final _AssembleElement element;
  final Widget child;
  final Map<String, String>? extra;
  final _debugProperties = <String, String>{};

  _CSSContainer({Key? key, required this.element, required this.child, this.extra})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final css = element.style;
    Widget w = child;
    final padding = css.padding;

    final flex = _canFlex(css);
    final positionCSS = css['position'];
    final width = css.width;
    final height = css.height;

    final color = css.color('background-color') ?? css.color('background');
    final borderRadius = css.borderRadius;
    final border = css.border;
    final shadows = css.boxShadow;

    _debugProperties.clear();
    BoxDecoration? decoration;
    if (color != null || borderRadius != null || border != null || shadows != null) {
      decoration = BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadows,
      );
    }

    final borderBox = (css['box-sizing'] ?? 'content-box') == 'border-box';
    double? _width = width, _height = height;
    if (!borderBox) {
      final horizon = (padding?.horizontal ?? 0); // + (border?.let((it) => it.left.width + it.right.width) ?? 0);
      final vertical = (padding?.vertical ?? 0); // + (border?.let((it) => it.top.width + it.bottom.width) ?? 0);
      _width = width?.let((it) => it + horizon);
      _height = height?.let((it) => it + vertical);
    }
    final validSize = _width != null || _height != null;
    if (padding != null || decoration != null || validSize) {
      w = Ink(
        padding: padding,
        decoration: decoration,
        width: _width,
        height: _height,
        child: w,
      );
      if (color != null) {
        _debugProperties['color'] = color.toString();
      }
      if (borderRadius != null) {
        _debugProperties['radius'] = borderRadius.toString();
      }
      if (border != null) {
        _debugProperties['border'] = border.toString();
      }
      if (shadows != null) {
        _debugProperties['shadow'] = "true";
      }
      if (padding != null) {
        _debugProperties['padding'] = padding.toString();
      }
      if (validSize) {
        _debugProperties['size'] = '($_width, $_height)';
      }
    }

    final tap = extra?['bindtap'];
    if (tap != null) {
      w = InkWell(
        onTap: () {
        },
        child: w,
      );
      _debugProperties['tap'] = tap;
    }

    if (borderRadius != null) {
      w = ClipRRect(
        borderRadius: borderRadius,
        child: w,
      );
    }

    final margin = css.margin;
    final marginCSS = css['margin'];
    if (marginCSS != null && marginCSS.contains('auto')) {
      w = Center(
        child: w,
      );
      _debugProperties['margin'] = 'auto';
    } else if (margin != null) {
      w = Padding(
        padding: margin,
        child: w,
      );
      _debugProperties['margin'] = margin.toString();
    }

    // flexible should be contained directly inside Column/Row
    if (flex > 0) {
      w = Flexible(
        flex: flex,
        fit: FlexFit.tight,
        child: w,
      );
      _debugProperties['flex'] = '$flex';
    } else if (positionCSS == 'absolute' || positionCSS == 'fixed') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      w = Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: w,
      );
      _debugProperties['position'] = '($left, $top, $right, $bottom)';
    } else if (positionCSS == 'relative') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      final dx = left ?? right?.let((it) => -right);
      final dy = top ?? bottom?.let((it) => -bottom);
      if (dx != null || dy != null) {
        w = Transform.translate(
          offset: Offset(
            dx ?? 0,
            dy ?? 0,
          ),
          child: w,
        );
        _debugProperties['offset'] = '($dx, $dy)';
      }
    }
    return w;
  }

  static int _canFlex(CSSStyle style) {
    final flex = style.optInt('flex', style.optInt('flex-grow', 0));
    if (flex > 0 && style.parent?['display'] == 'flex') {
      return flex;
    }

    return 0;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('<${element.name}>', child.toStringShort()));
    _debugProperties.entries.map((e) => StringProperty(e.key, e.value)).forEach(properties.add);
  }
}

extension _ColorExt on Color {
  String toColorString() {
    return '#${value.toRadixString(16)}';
  }
}

extension _MapAppend on Map<String, String> {
  bool attr(String key, String? value) {
    bool put = value != null;
    if (put) {
      this[key] = value;
    }
    return put;
  }

  bool attrDouble(String key, double? value) => attr(key, value?.toStringAsFixed(2).replaceAll('.00', ''));

  bool color(Color? color, {String prefix = ''}) => attr('${prefix}color', color?.toColorString());

  void edge(EdgeInsets insets, String key) {
    if (insets.left == insets.right && insets.left == insets.top && insets.left == insets.bottom) {
      attrDouble(key, insets.left);
    } else {
      if (insets.left > 0) {
        attrDouble('${key}Left', insets.left);
      }
      if (insets.top > 0) {
        attrDouble('${key}Top', insets.top);
      }
      if (insets.right > 0) {
        attrDouble('${key}Right', insets.right);
      }
      if (insets.bottom > 0) {
        attrDouble('${key}Bottom', insets.bottom);
      }
    }
  }

  void radius(BorderRadius radius, {String prefix = ''}) {
    final topLeft = radius.topLeft;
    final topRight = radius.topRight;
    final bottomLeft = radius.bottomLeft;
    final bottomRight = radius.bottomRight;
    if (topLeft == topRight && topLeft == bottomLeft && topLeft == bottomRight) {
      attrDouble('${prefix}borderRadius', topLeft.x);
    } else {
      if (topLeft.x > 0) {
        attrDouble('${prefix}borderRadiusTopLeft', topLeft.x);
      }
      if (topRight.x > 0) {
        attrDouble('${prefix}borderRadiusTopRight', topRight.x);
      }
      if (bottomLeft.x > 0) {
        attrDouble('${prefix}borderRadiusBottomLeft', bottomLeft.x);
      }
      if (bottomRight.x > 0) {
        attrDouble('${prefix}borderRadiusBottomRight', bottomRight.x);
      }
    }
  }

  void _side(BorderSide side, String prefix, String direction) {
    if (side.color != Colors.black) {
      color(side.color, prefix: '${prefix}border$direction.');
    }
    if (side.width > 1.0) {
      attrDouble('${prefix}border$direction.width', side.width);
    }
  }

  void border(Border border, {String prefix = ''}) {
    if (border.isUniform) {
      final side = border.top;
      _side(side, prefix, '');
    } else {
      _side(border.left, prefix, 'Left');
      _side(border.top, prefix, 'Top');
      _side(border.right, prefix, 'Right');
      _side(border.bottom, prefix, 'Bottom');
    }
  }

  MapEntry<String, String>? _ctrl(String wxKey, {String? flutterKey}) {
    flutterKey ??= wxKey;
    final value = this['wx:$wxKey'];
    return value?.let((it) => MapEntry(flutterKey!, it));
  }

  MapEntry<String, String>? controlFlow() {
    return _ctrl('if')
        ?? _ctrl('elif', flutterKey: 'elseif')
        ?? _ctrl('else')
        ?? _ctrl('for');
  }
}
