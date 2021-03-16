part of durian;

class _XmlTextBuilder extends CommonWidgetBuilder {

  const _XmlTextBuilder() : super('Text');

  @override
  bool get childless => true;

  @override
  Widget build(XmlElement element, List<Widget> children) {
    final children = <XmlNode>[];
    String text = '';
    bool isPlain = true;
    element.children.forEach((node) {
      if (node.nodeType == XmlNodeType.TEXT) {
        final txt = (node as XmlText).text.trim();
        if (txt.isNotEmpty) {
          children.add(node);
          text += txt;
        }
      } else if (node.nodeType == XmlNodeType.ELEMENT) {
        isPlain = false;
        children.add(node);
      }
    });

    if (isPlain) {
      return Text(
        text,
      );
    } else {
      final span = _createSpans(children);
      return RichText(
        text: TextSpan(
          children: span,
        ),
      );
    }
  }

  List<InlineSpan> _createSpans(List<XmlNode> nodes) {
    final span = <InlineSpan>[];
    nodes.forEach((node) {
      if (node.nodeType == XmlNodeType.TEXT) {
        final txt = (node as XmlText).text.trim();
        if (txt.isNotEmpty) {
          span.add(TextSpan(
            text: txt,
          ));
        }
      } else if (node.nodeType == XmlNodeType.ELEMENT) {
        final e = node as XmlElement;
        final w = _assembleByElement(e);
        span.add(WidgetSpan(
          child: w,
          alignment: PlaceholderAlignment.middle,
        ));
      }
    });
    return span;
  }
}
