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
        // skip
      } else {
        final ext = extra ?? <String, String>{};
        ext[key] = value;
        extra = ext;
      }
    });

    final name = e.name.local;
    var children = _empty;

    final css = CSSStyle(style);
    if (name == 'text') {
      final text = e.text;
      final ext = extra ?? <String, String>{};
      ext['data'] = text.split('\n').map((line) => line.trim()).join('\n');
      extra = ext;
    } else {
      final ancestorStyle = AncestorStyle.from(css, parent);
      children = e.children
          .where((e) => e.nodeType == XmlNodeType.ELEMENT)
          .map((child) => _fromXml(child as XmlElement, ancestorStyle))
          .toList(growable: false);
    }
    return _AssembleElement(name, css, extra, children, parent);
  }
}
