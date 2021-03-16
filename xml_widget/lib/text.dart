part of durian;

class _XmlTextBuilder extends CommonWidgetBuilder {

  const _XmlTextBuilder() : super('Text');

  @override
  bool get childless => true;

  @override
  Widget build(XmlElement element, List<Widget> children) {
    final attrs = Map<String, String>.fromEntries(element.attributes.map(
            (attr) => MapEntry(attr.name.local, attr.value)));
    return Text(
      attrs['data'] ?? '',
      maxLines: attrs['maxLines']?.let((it) => int.parse(it)),
      softWrap: attrs['softWrap']?.let((it) => it.toLowerCase() == 'true'),
      textDirection: attrs['textDirection']?.toTextDirection(),
    );
  }
}
