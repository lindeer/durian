part of durian;

class _XmlColumnBuilder extends CommonWidgetBuilder {
  const _XmlColumnBuilder() : super('Column');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Column(
      children: children,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
      mainAxisSize: _mainAxisSize[attrs['mainAxisSize']] ?? MainAxisSize.max,
      crossAxisAlignment: _crossAxisAlignment[attrs['crossAxisAlignment']] ?? CrossAxisAlignment.center,
      textDirection: _textDirection[attrs['textDirection']],
      verticalDirection: _verticalDirection[attrs['textDirection']] ?? VerticalDirection.down,
      textBaseline: _textBaseline[attrs['textBaseline']],
    );
  }
}

class _XmlRowBuilder extends CommonWidgetBuilder {
  const _XmlRowBuilder() : super('Row');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Row(
      children: children,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
      mainAxisSize: _mainAxisSize[attrs['mainAxisSize']] ?? MainAxisSize.max,
      crossAxisAlignment: _crossAxisAlignment[attrs['crossAxisAlignment']] ?? CrossAxisAlignment.center,
      textDirection: _textDirection[attrs['textDirection']],
      verticalDirection: _verticalDirection[attrs['textDirection']] ?? VerticalDirection.down,
      textBaseline: _textBaseline[attrs['textBaseline']],
    );
  }
}

class _XmlWrapBuilder extends CommonWidgetBuilder {
  const _XmlWrapBuilder() : super('Wrap');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Wrap(
      children: children,
      direction: attrs['direction']?.toAxis() ?? Axis.horizontal,
      alignment: attrs['alignment']?.toWrapAlignment() ?? WrapAlignment.start,
      spacing: attrs['spacing']?.toDouble() ?? 0.0,
      runAlignment: attrs['runAlignment']?.toWrapAlignment() ?? WrapAlignment.start,
      runSpacing: attrs['runSpacing']?.toDouble() ?? 0.0,
      crossAxisAlignment: attrs['crossAxisAlignment']?.toWrapCrossAlignment() ?? WrapCrossAlignment.start,
      textDirection: attrs['textDirection']?.toTextDirection(),
      verticalDirection: attrs['verticalDirection']?.toVerticalDirection() ?? VerticalDirection.down,
      clipBehavior: attrs['clipBehavior']?.toClip() ?? Clip.none,
    );
  }
}
