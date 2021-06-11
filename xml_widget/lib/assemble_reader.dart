part of durian;

abstract class AssembleReader {
  Future<AssembleResource> loadResource();

  Future<AssembleElement> loadElement();

  Future<String> loadJS();

  factory AssembleReader({required String path, bool? assets}) {
    return (assets ?? false) ? _AssetReader(path) : _FileReader(path);
  }

  static AssembleResource fromRaw(String source) {
    final res = _ResImpl();
    res.loadResource(source);
    return res;
  }

  static AssembleElement _fromXml(XmlElement e) {
    final children = e.children
        .where((child) => child.nodeType == XmlNodeType.ELEMENT)
        .map((child) => _fromXml(child as XmlElement))
        .toList(growable: false);
    final map = e.attributes.map((attr) => MapEntry(attr.name, attr.value));
    final raw = Map.fromEntries(map.map((entry) => MapEntry(entry.key.qualified, entry.value)));
    final attrs = Map.fromEntries(map.map((entry) => MapEntry(entry.key.local, entry.value)));
    final name = e.name.qualified;
    return AssembleElement(name, attrs, raw, children);
  }

  static AssembleElement fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    return _fromXml(root);
  }
}

class _FileReader implements AssembleReader {
  final String path;

  const _FileReader(this.path);

  @override
  Future<AssembleResource> loadResource() async {
    final f = File('$path/colors.xml');
    if (f.existsSync()) {
      final str = await f.readAsString();
      return AssembleReader.fromRaw(str);
    } else {
      return _ResImpl();
    }
  }

  @override
  Future<AssembleElement> loadElement() async {
    final f = File('$path/app.xml');
    final source = await f.readAsString();
    return AssembleReader.fromSource(source);
  }

  @override
  Future<String> loadJS() async {
    final f = File('$path/app.js');
    final source = await f.readAsString();
    return source;
  }
}

class _AssetReader implements AssembleReader {
  final String path;

  const _AssetReader(this.path);

  @override
  Future<AssembleResource> loadResource() async {
    try {
      final str = await rootBundle.loadString('$path/colors.xml');
      return AssembleReader.fromRaw(str);
    } catch (_) {
      return _ResImpl();
    }
  }

  @override
  Future<AssembleElement> loadElement() async {
    final source = await rootBundle.loadString('$path/app.xml');
    return AssembleReader.fromSource(source);
  }

  @override
  Future<String> loadJS() => rootBundle.loadString('$path/app.js');
}
