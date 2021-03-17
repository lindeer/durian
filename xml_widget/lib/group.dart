part of durian;

class _XmlColumnBuilder extends CommonWidgetBuilder {
  const _XmlColumnBuilder() : super('Column');

  @override
  Widget build(AssembleElement element, List<Widget> children) {
    final attrs = element.attrs;
    return Column(
      children: children,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
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
    );
  }
}
