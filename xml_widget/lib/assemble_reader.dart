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

  Future<AssembleElement> parseElement() async {
    final f = File('${_dir.path}/app.xml');
    final source = await f.readAsString();
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    final c = AssembleContext(_ResImpl(), CallbackHolder(), (e)=>SizedBox.shrink(), (c,e)=>SizedBox.shrink());
    return AssembleElement.fromXml(root, c);
  }

  static AssembleElement fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    final c = AssembleContext(_ResImpl(), CallbackHolder(), (e)=>SizedBox.shrink(), (c,e)=>SizedBox.shrink());
    return AssembleElement.fromXml(root, c);
  }

  Future<String> loadJS() async {
    final f = File('${_dir.path}/app.js');
    final source = await f.readAsString();
    return source;
  }
}
