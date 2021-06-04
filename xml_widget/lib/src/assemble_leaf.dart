part of durian;

class _XmlTextBuilder extends CommonWidgetBuilder {

  const _XmlTextBuilder() : super('Text');

  @override
  bool get childless => true;

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> children) {
    final attrs = element.attrs;
    final res = element.context.resource;
    final styleAttr = attrs['style'];
    TextStyle? textStyle;
    if (styleAttr?.startsWith('@theme/') ?? false) {
      final theme = Theme.of(buildContext);
      final path = styleAttr!.substring(7);
      textStyle = _PropertyStruct.themeTextStyle(theme, path);
    }
    final overrideStyle = _PropertyStruct.toTextStyle(res, attrs);
    textStyle = textStyle != null ? textStyle.merge(overrideStyle) : overrideStyle;
    return Text(
      attrs['data'] ?? '',
      style: textStyle,
      maxLines: attrs['maxLines']?.let((it) => int.parse(it)),
      softWrap: attrs['softWrap']?.let((it) => it.toLowerCase() == 'true'),
      textDirection: attrs['textDirection']?.toTextDirection(),
    );
  }
}

class _XmlIconBuilder extends CommonWidgetBuilder {

  const _XmlIconBuilder() : super('Icon');

  @override
  bool get childless => true;

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> children) {
    final attrs = element.attrs;
    final res = element.context.resource;
    return Icon(
      res.icon(attrs['icon']),
      size: res.size(attrs['size']),
      color: res[attrs['color']],
      semanticLabel: attrs['semanticLabel'],
      textDirection: _textDirection[attrs['textDirection']],
    );
  }
}

class _XmlImageBuilder extends CommonWidgetBuilder {
  const _XmlImageBuilder() : super('Image');

  @override
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final resource = element.context.resource;
    final src = attrs['src'] ?? '';
    File file;
    final scale = attrs['scale']?.toDouble();
    final ltrb = attrs['centerSlice']?.split(' ').map((e) => resource.size(e)).whereType<double>().toList(growable: false);
    final rect = ltrb != null && ltrb.length == 4 ? Rect.fromLTRB(ltrb[0], ltrb[1], ltrb[2], ltrb[3]) : null;
    if (src.startsWith('http')) {
      return Image.network(
        src,
        scale: scale ?? 1.0,
        semanticLabel: attrs['semanticLabel'],
        excludeFromSemantics: attrs['excludeFromSemantics'] == "true",
        width: attrs['width']?.toDouble(),
        height: attrs['height']?.toDouble(),
        color: resource[attrs['color']],
        colorBlendMode: _blendMode[attrs['colorBlendMode']],
        fit: _boxFit[attrs['fit']],
        alignment: _alignment[attrs['alignment']] ?? Alignment.center,
        repeat: _imageRepeat[attrs['repeat']] ?? ImageRepeat.noRepeat,
        centerSlice: rect,
        matchTextDirection: attrs['matchTextDirection'] == "true",
        gaplessPlayback: attrs['gaplessPlayback'] == "true",
        filterQuality: _filterQuality[attrs['filterQuality']] ?? FilterQuality.low,
        isAntiAlias: attrs['isAntiAlias'] == "true",
        cacheWidth: attrs['cacheWidth']?.toInt(),
        cacheHeight: attrs['cacheHeight']?.toInt(),
      );
    } else if (src.startsWith('@image/')) {
      final res = src.substring(7);
      return Image.asset(
        res,
        scale: scale,
        semanticLabel: attrs['semanticLabel'],
        excludeFromSemantics: attrs['excludeFromSemantics'] == "true",
        width: attrs['width']?.toDouble(),
        height: attrs['height']?.toDouble(),
        color: resource[attrs['color']],
        colorBlendMode: _blendMode[attrs['colorBlendMode']],
        fit: _boxFit[attrs['fit']],
        alignment: _alignment[attrs['alignment']] ?? Alignment.center,
        repeat: _imageRepeat[attrs['repeat']] ?? ImageRepeat.noRepeat,
        centerSlice: rect,
        matchTextDirection: attrs['matchTextDirection'] == "true",
        gaplessPlayback: attrs['gaplessPlayback'] == "true",
        filterQuality: _filterQuality[attrs['filterQuality']] ?? FilterQuality.low,
        isAntiAlias: attrs['isAntiAlias'] == "true",
        cacheWidth: attrs['cacheWidth']?.toInt(),
        cacheHeight: attrs['cacheHeight']?.toInt(),
      );
    } else if ((file = File(src)).existsSync()) {
      return Image.file(
        file,
        scale: scale ?? 1.0,
        semanticLabel: attrs['semanticLabel'],
        excludeFromSemantics: attrs['excludeFromSemantics'] == "true",
        width: attrs['width']?.toDouble(),
        height: attrs['height']?.toDouble(),
        color: resource[attrs['color']],
        colorBlendMode: _blendMode[attrs['colorBlendMode']],
        fit: _boxFit[attrs['fit']],
        alignment: _alignment[attrs['alignment']] ?? Alignment.center,
        repeat: _imageRepeat[attrs['repeat']] ?? ImageRepeat.noRepeat,
        centerSlice: rect,
        matchTextDirection: attrs['matchTextDirection'] == "true",
        gaplessPlayback: attrs['gaplessPlayback'] == "true",
        filterQuality: _filterQuality[attrs['filterQuality']] ?? FilterQuality.low,
        isAntiAlias: attrs['isAntiAlias'] == "true",
        cacheWidth: attrs['cacheWidth']?.toInt(),
        cacheHeight: attrs['cacheHeight']?.toInt(),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
