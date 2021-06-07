part of durian;

class AssembleReader {
  final Directory _dir;

  AssembleReader._(this._dir);

  factory AssembleReader(String path) {
    return AssembleReader._(Directory(path));
  }

  Future<AssembleResource> loadResource() async {
    final f = File('${_dir.path}/colors.xml');
    final res = _ResImpl();
    if (f.existsSync()) {
      final source = await f.readAsString();
      res.loadResource(source);
    }
    return res;
  }

  static AssembleElement _fromXml(XmlElement e) {
    final children = e.children.where((child) => child.nodeType == XmlNodeType.ELEMENT)
        .map((child) => _fromXml(child as XmlElement)).toList(growable: false);
    final map = e.attributes.map(
            (attr) => MapEntry(attr.name, attr.value));
    final raw = Map.fromEntries(map.map((entry) => MapEntry(entry.key.qualified, entry.value)));
    final attrs = Map.fromEntries(map.map((entry) => MapEntry(entry.key.local, entry.value)));
    final name = e.name.qualified;
    return AssembleElement(name, attrs, raw, children);
  }

  Future<AssembleElement> parseElement() async {
    final f = File('${_dir.path}/app.xml');
    final source = await f.readAsString();
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    return _fromXml(root);
  }

  static AssembleElement fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    return _fromXml(root);
  }

  Future<String> loadJS() async {
    final f = File('${_dir.path}/app.js');
    final source = await f.readAsString();
    return source;
  }
}
