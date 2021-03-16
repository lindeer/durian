part of durian;

class _XmlTextBuilder extends CommonWidgetBuilder {

  const _XmlTextBuilder() : super('Text');

  @override
  bool get childless => true;

  @override
  Widget build(XmlElement element, List<Widget> children) {
    final text = element.text;
    return Text(
      text,
    );
  }
}
