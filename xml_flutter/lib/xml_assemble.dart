part of durian;

typedef Widget FnWidgetBuilder(_AssembleElement e, List<Widget> children);

abstract class AssembleBuilder {
  Widget build(_AssembleElement e, List<Widget> children);
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
}

class BlockAssembleBuilder implements AssembleBuilder {
  const BlockAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
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

  int _canFlex(CSSStyle style) {
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
