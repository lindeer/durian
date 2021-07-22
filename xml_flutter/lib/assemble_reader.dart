part of durian;

class AssembleReader {
  static const _empty = const <_AssembleElement>[];

  static _AssembleElement fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    return _fromXml(root, null);
  }

  static _AssembleElement _fromXml(XmlElement e, AncestorStyle? parent) {
    final style = <String, String>{};
    Map<String, String>? extra;
    String? klass;
    e.attributes.forEach((attr) {
      final key = attr.name.local;
      final value = attr.value;
      if (key == 'style') {
        value.split(';').forEach((expr) {
          int pos = expr.indexOf(':');
          if (pos > 0) {
            style[expr.substring(0, pos).trim()] = expr.substring(pos + 1).trim();
          }
        });
      } else if (key == 'class') {
        klass = value;
      } else {
        final ext = extra ?? <String, String>{};
        ext[key] = value;
        extra = ext;
      }
    });

    var name = e.name.local;
    var children = _empty;

    final css = CSSStyle(style);
    if (name == 'text') {
      final text = e.text;
      final ext = extra ?? <String, String>{};
      ext['data'] = text.split('\n').map((line) => line.trim()).join('\n');
      extra = ext;
    } else {
      final textNodes = <XmlText>[];
      final elementNodes = <XmlElement>[];
      e.children.forEach((e) {
        if (e.nodeType == XmlNodeType.TEXT) {
          final node = e as XmlText;
          if (node.text.trim().isNotEmpty) {
            textNodes.add(node);
          }
        } else if (e.nodeType == XmlNodeType.ELEMENT) {
          elementNodes.add(e as XmlElement);
        }
      });
      final ancestorStyle = AncestorStyle.from(css, parent);
      if (elementNodes.length > 0) {
        children = elementNodes
            .map((child) => _fromXml(child, ancestorStyle))
            .toList(growable: false);
      } else if (textNodes.length > 0) {
        name = 'text';
        String _trimLine(XmlText e) => e.text.split('\n').map((line) => line.trim()).join('\n');
        textNodes.map((e) => e.text.trim().split('\n'));
        final ext = extra ?? <String, String>{};
        ext['data'] = textNodes.map(_trimLine).join('');
        extra = ext;
      }
    }
    return _AssembleElement(name, css, klass, extra, children, parent);
  }
}
