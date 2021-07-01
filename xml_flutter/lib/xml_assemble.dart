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
    return Image.file(
      File(src),
      width: width,
      height: height,
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

class AssembleTank {
  static final _defaultBuilders = const {
    'text': const TextAssembleBuilder(),
    'image': const ImageAssembleBuilder(),
    'view': const ViewAssembleBuilder(),
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
    Widget w = depth == 0 && name == 'view'
        ? ListView(children: children,)
        : builder.build(element, children);

    final css = element.style;
    final padding = css.padding;

    final flex = _canFlex(css);
    final positionCSS = css['position'];
    final width = css.width;
    final height = css.height;

    final color = css.color('background-color') ?? css.color('background');
    final borderRadius = css.borderRadius;
    final border = css.border;
    BoxDecoration? decoration;
    if (color != null || borderRadius != null || border != null) {
      decoration = BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
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
    }

    final tap = element.extra?['bindtap'];
    if (tap != null) {
      w = InkWell(
        onTap: () {
        },
        child: w,
      );
    }

    if (borderRadius != null) {
      w = ClipRRect(
        borderRadius: borderRadius,
        child: w,
      );
    }

    final marginCSS = css['margin'];
    if (marginCSS != null) {
      if (marginCSS.contains('auto')) {
        w = Center(
          child: w,
        );
      } else {
        final margin = css.margin;
        if (margin != null) {
          w = Padding(
            padding: margin,
            child: w,
          );
        }
      }
    }

    // flexible should be contained directly inside Column/Row
    if (flex > 0) {
      w = Flexible(
        flex: flex,
        fit: FlexFit.tight,
        child: w,
      );
    } else if (positionCSS == 'absolute') {
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
      }
    }
    return w;
  }

  int _canFlex(CSSStyle style) {
    final flex = style.optInt('flex', 0);
    return flex;
  }

  Widget build(BuildContext context, _AssembleElement root) {
    return _assembleWidget(root, 0);
  }
}
