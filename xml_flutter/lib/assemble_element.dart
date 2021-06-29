part of durian;

class _AssembleElement {
  final String name;
  final CSSStyle style;
  final Map<String, String>? extra;
  final List<_AssembleElement> children;

  _AssembleElement(this.name, Map<String, String> s, this.extra, this.children) : style = CSSStyle(s);

  @override
  String toString() {
    return '<$name style="$style" ${extra?.let((it) => 'extra="$extra"') ?? ''}>';
  }
}
