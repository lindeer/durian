part of durian;

typedef Widget FnWidgetBuilder(_AssembleElement e, List<Widget> children);

abstract class AssembleBuilder {
  Widget build(_AssembleElement e, List<Widget> children);

  String generate(_AssembleElement e, List<String> children);
}

class TextAssembleBuilder implements AssembleBuilder {
  const TextAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    final style = e.style;
    final extra = e.extra;
    final color = style.color('color') ?? e.inheritStyle?.textColor;
    final size = style._getDouble('font-size');
    return Text(
      extra?['data'] ?? '',
      style: TextStyle(
        color: color,
        fontSize: size,
        height: 1,
      ),
    );
  }

  @override
  String generate(_AssembleElement e, List<String> children) {
    final style = e.style;
    final extra = e.extra;
    final color = style.color('color') ?? e.inheritStyle?.textColor;
    final size = style._getDouble('font-size');
    return """
<Text
  flutter:data="${extra?['data'] ?? ''}"
  ${_FlutterXmlAttr.genColor(color, prefix: 'style.')}
  ${_FlutterXmlAttr.genAttr<double>('style.fontSize', size)}/>
""";
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
  String generate(_AssembleElement e, List<String> children) {
    final extra = e.extra;
    final src = extra?['src'] ?? '';
    return """
<Image
  flutter:src="$src"
  />
""";
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
  String generate(_AssembleElement e, List<String> children) {
    final style = e.style;
    final extra = e.extra;
    final size = style._optDouble('size', 24);
    final name = extra?['type'] ?? 'share';
    final color = e.inheritStyle?.textColor;
    return """
<Icon
  flutter:icon="@icon/$name"
  flutter:size="$size"
  ${_FlutterXmlAttr.genColor(color)}/>
""";
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
  String generate(_AssembleElement e, List<String> children) {
    final color = e.inheritStyle?.textColor;
    return """
<Icon
  flutter:icon="@icon/error_outline_outlined"
  ${_FlutterXmlAttr.genColor(color)}/>
""";
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
  String generate(_AssembleElement e, List<String> children) {
    return """
<Column
  flutter:crossAxisAlignment="stretch">
${children.join('\n')}
</Column>
""";
  }
}

class BlockAssembleBuilder implements AssembleBuilder {
  const BlockAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    return children.first;
  }

  @override
  String generate(_AssembleElement e, List<String> children) {
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

  String _assembleSource(_AssembleElement element, int depth) {
    final name = element.name;
    final children = element.children
        .map((e) => _assembleSource(e, depth + 1))
        .toList(growable: false);

    final builder = builders[name] ?? _defaultBuilders[name] ?? const ColumnAssembleBuilder();
    final style = element.style;
    final overflowY = style['overflow-y'];
    final source = depth == 0 && name == 'view' && overflowY != null
        ? """
<ListView>
${children.join('\n')}
</ListView>
"""
        : builder.generate(element, children);

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
    final sb = StringBuffer();
    final endTags = <String>[];

    /// string writing in reverse order
    if (flex > 0) {
      sb.write("""
<Flexible
  flutter:flex="$flex"
  flutter:fit="tight">
"""
      );
      endTags.add('</Flexible>');
    } else if (positionCSS == 'absolute' || positionCSS == 'fixed') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      sb.writeln('<Positioned');
      if (left != null) {
        sb.writeln('flutter:left="$left"');
      }
      if (top != null) {
        sb.writeln('flutter:top="$top"');
      }
      if (right != null) {
        sb.writeln('flutter:right="$right"');
      }
      if (bottom != null) {
        sb.writeln('flutter:bottom="$bottom"');
      }
      sb.writeln('>');
      endTags.add('</Positioned>');
    } else if (positionCSS == 'relative') {
      final left = css._getDouble('left');
      final top = css._getDouble('top');
      final right = css._getDouble('right');
      final bottom = css._getDouble('bottom');
      final dx = left ?? right?.let((it) => -right);
      final dy = top ?? bottom?.let((it) => -bottom);
      if (dx != null || dy != null) {
        sb.writeln('<Translate');
        if (dx != null) {
          sb.writeln('flutter:x="$dx"');
        }
        if (dy != null) {
          sb.writeln('flutter:y="$dy"');
        }
        sb.writeln('>');
        endTags.add('</Translate>');
      }
    }

    final marginCSS = css['margin'];
    if (marginCSS != null && marginCSS.contains('auto')) {
      sb.writeln('<Center>');
      endTags.add('</Center>');
    } else if (margin != null) {
      sb.writeln('<Padding');
      sb.writeln(_FlutterXmlAttr.genEdge(margin, 'padding'));
      sb.writeln('>');
      endTags.add('</Padding>');
    }

    if (borderRadius != null) {
      sb.write("""
<ClipRRect
  ${_FlutterXmlAttr.genRadius(borderRadius)}>
"""
      );
      endTags.add('</ClipRRect>');
    }

    final tap = element.extra?['bindtap'];
    if (tap != null) {
      sb.write("""
<InkWell
  flutter:onTap="$tap">
""");
      endTags.add('</InkWell>');
    }

    if (padding != null || decoration != null || validSize) {
      sb.writeln('<Ink');
      if (padding != null) {
        sb.writeln(_FlutterXmlAttr.genEdge(padding, 'padding'));
      }
      if (decoration != null) {
        if (color != null) {
          sb.writeln(_FlutterXmlAttr.genColor(color, prefix: 'decoration.'));
        }
        if (borderRadius != null) {
          sb.writeln(_FlutterXmlAttr.genRadius(borderRadius, prefix: 'decoration.'));
        }
        if (border != null) {
          sb.writeln(_FlutterXmlAttr.genBorder(border, prefix: 'decoration.'));
        }
      }
      if (_width != null) {
        sb.writeln('flutter:width="$_width"');
      }
      if (_height != null) {
        sb.writeln('flutter:height="$_height"');
      }
      sb.writeln(">");
      endTags.add('</Ink>');
    }

    sb.writeln(source);

    endTags.reversed.forEach(sb.writeln);

    final nodeString = sb.toString();
    final cf = _FlutterXmlAttr.genControlFlow(element.extra);
    return cf.isEmpty ? nodeString : _FlutterXmlAttr.insertFlow(nodeString, cf);
  }

  String gen(_AssembleElement root) {
    if (root.name == '_floatStack') {
      var depth = 0;
      final children = root.children.map((e) => _assembleSource(e, depth++)).toList(growable: false);
      return """
<Stack xmlns:flutter="http://flutter.dev/xml/flutter">
${children.join('\n')}
</Stack>
""";
    }
    return _assembleSource(root, 0);
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

// make flutter to xml attributes
class _FlutterXmlAttr {
  static String genAttr<T>(String key, T? t, {String Function(T)? map}) {
    if (t == null) return '';
    final v = map == null ? '$t' : t.let(map);
    return 'flutter:$key="$v"';
  }

  static String genColor(Color? color, {String prefix = ''}) {
    return genAttr<Color>('${prefix}color', color, map: (it) => '#${it.value.toRadixString(16)}');
  }

  static String genEdge(EdgeInsets insets, String key) {
    if (insets.left == insets.right && insets.left == insets.top && insets.left == insets.bottom) {
      return 'flutter:$key="${insets.left}"';
    } else {
      final sb = StringBuffer();
      if (insets.left > 0) {
        sb.writeln('flutter:${key}Left="${insets.left}"');
      }
      if (insets.top > 0) {
        sb.writeln('flutter:${key}Top="${insets.top}"');
      }
      if (insets.right > 0) {
        sb.writeln('flutter:${key}Right="${insets.right}"');
      }
      if (insets.bottom > 0) {
        sb.writeln('flutter:${key}Bottom="${insets.bottom}"');
      }
      return sb.toString();
    }
  }

  static String genRadius(BorderRadius radius, {String prefix = ''}) {
    final topLeft = radius.topLeft;
    final topRight = radius.topRight;
    final bottomLeft = radius.bottomLeft;
    final bottomRight = radius.bottomRight;
    if (topLeft == topRight && topLeft == bottomLeft && topLeft == bottomRight) {
      return 'flutter:${prefix}borderRadius="${topLeft.x}"';
    } else {
      final sb = StringBuffer();
      if (topLeft.x > 0) {
        sb.writeln('flutter:${prefix}borderRadiusTopLeft="${topLeft.x}"');
      }
      if (topRight.x > 0) {
        sb.writeln('flutter:${prefix}borderRadiusTopRight="${topRight.x}"');
      }
      if (bottomLeft.x > 0) {
        sb.writeln('flutter:${prefix}borderRadiusBottomLeft="${bottomLeft.x}"');
      }
      if (bottomRight.x > 0) {
        sb.writeln('flutter:${prefix}borderRadiusBottomRight="${bottomRight.x}"');
      }
      return sb.toString();
    }
  }

  static void _genSide(StringBuffer sb, BorderSide side, String prefix, String direction) {
    if (side.color != Colors.black) {
      sb.writeln(genColor(side.color, prefix: '${prefix}border$direction.'));
    }
    if (side.width > 1.0) {
      sb.writeln(genAttr('${prefix}border$direction.width', side.width));
    }
  }

  static String genBorder(Border border, {String prefix = ''}) {
    final sb = StringBuffer();
    if (border.isUniform) {
      final side = border.top;
      _genSide(sb, side, prefix, '');
    } else {
      _genSide(sb, border.left, prefix, 'Left');
      _genSide(sb, border.top, prefix, 'Top');
      _genSide(sb, border.right, prefix, 'Right');
      _genSide(sb, border.bottom, prefix, 'Bottom');
    }
    return sb.toString();
  }

  static String? _genKeyword(Map<String, String> extra, String wxKey, {String? flutterKey}) {
    flutterKey ??= wxKey;
    // '&' in xml should have to be '&amp;'
    return extra['wx:$wxKey']?.let((it) => 'flutter:$flutterKey="${it.replaceAll('&', '&amp;')}"');
  }

  static String genControlFlow(Map<String, String>? extra) {
    if (extra == null) return '';
    return _genKeyword(extra, "if")
        ?? _genKeyword(extra, "elif", flutterKey: "elseif")
        ?? _genKeyword(extra, "else")
        ?? _genKeyword(extra, "for")
        ?? '';
  }

  static final _startTag = RegExp(r'<\w+[\s\S]*?>');
  static String insertFlow(String text, String to) {
    final match = _startTag.firstMatch(text);
    if (match == null) return text;
    final sb = StringBuffer();
    if (0 < match.start) {
      sb.write(text.substring(0, match.start));
    }
    final str = match[0]!;
    final end = str.lastIndexOf('>');
    final s = str.endsWith("/>")
        ? str.replaceFirst("/>", " $to/>")
        : str.replaceRange(end, str.length, " $to>");
    sb.write(s);
    if (match.end < text.length) {
      sb.write(text.substring(match.end));
    }
    return sb.toString();
  }
}
