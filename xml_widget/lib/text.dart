part of durian;

class _XmlTextBuilder extends CommonWidgetBuilder {

  const _XmlTextBuilder() : super('Text');

  @override
  bool get childless => true;

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> children) {
    final attrs = element.attrs;
    final styleAttr = attrs['style'];
    TextStyle? textStyle;
    if (styleAttr?.startsWith('@theme/') ?? false) {
      final theme = element.context.theme;
      final path = styleAttr!.substring(7);
      textStyle = _PropertyStruct.themeTextStyle(theme, path);
    }
    final overrideStyle = _PropertyStruct.toTextStyle(attrs);
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
  Widget build(AssembleElement element, List<AssembleChildElement> children) {
    final attrs = element.attrs;
    return Icon(
      Icons.add,
      size: attrs['size']?.toSize(),
      color: attrs['color']?.toColor(),
      semanticLabel: attrs['semanticLabel'],
      textDirection: _textDirection[attrs['textDirection']],
    );
  }
}
