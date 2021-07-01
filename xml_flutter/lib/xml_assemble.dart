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
    if (padding != null) {
      w = Padding(
        padding: padding,
        child: w,
      );
    }
    final flex = _canFlex(css);
    final width = css.width;
    final height = css.height;
    if (width != null || height != null) {
      final borderBox = (css['box-sizing'] ?? 'content-box') == 'border-box';
      final horizontal = padding?.horizontal ?? 0;
      final vertical = padding?.vertical ?? 0;

      w = SizedBox(
        width: borderBox ? width : width?.let((it) => it + horizontal),
        height: borderBox ? height : height?.let((it) => it + vertical),
        child: w,
      );
    }

    final color = css.color('background-color') ?? css.color('background');
    final borderRadius = css.borderRadius;
    final border = css.border;
    if (color != null || borderRadius != null || border != null) {
      w = DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
        ),
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
