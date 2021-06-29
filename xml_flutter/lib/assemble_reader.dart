part of durian;

class AssembleReader {
  static const _empty = const <_AssembleElement>[];

  static _AssembleElement fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    return _fromXml(root);
  }

  static _AssembleElement _fromXml(XmlElement e) {
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

    if (name == 'text') {
      final text = e.text;
      final ext = extra ?? <String, String>{};
      ext['data'] = text;
      extra = ext;
    } else {
      children = e.children
          .where((e) => e.nodeType == XmlNodeType.ELEMENT)
          .map((child) => _fromXml(child as XmlElement))
          .toList(growable: false);
    }
    return _AssembleElement(name, style, extra, children);
  }
}
