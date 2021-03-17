part of durian;

class _XmlContainerBuilder extends CommonWidgetBuilder {
  const _XmlContainerBuilder() : super('Container');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Container(
      child: children.isEmpty ? null : children.first,
      alignment: _alignment[attrs['alignment']],
      padding: _PropertyStruct.padding(attrs),
      decoration: _PropertyStruct.boxDecoration(attrs),
      color: attrs['color']?.toColor(),
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
      constraints: _PropertyStruct.constraints(attrs),
      margin: _PropertyStruct.margin(attrs),
      transformAlignment: _alignment[attrs['transformAlignment']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlInkBuilder extends CommonWidgetBuilder {
  const _XmlInkBuilder() : super('Ink');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Ink(
      child: children.isEmpty ? null : children.first,
      padding: _PropertyStruct.padding(attrs),
      color: attrs['color']?.toColor(),
      decoration: _PropertyStruct.boxDecoration(attrs),
      width: attrs['width']?.toSize(),
      height: attrs['height']?.toSize(),
    );
  }
}
