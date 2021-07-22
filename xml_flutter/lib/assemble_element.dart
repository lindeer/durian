part of durian;

class _AssembleElement {
  final String name;
  final CSSStyle style;
  final String? klass;
  final Map<String, String>? extra;
  final List<_AssembleElement> children;
  final AncestorStyle? inheritStyle;

  _AssembleElement(this.name, this.style, this.klass, this.extra, this.children, this.inheritStyle);

  @override
  String toString() {
    return '<$name style="$style" ${extra?.let((it) => 'extra="$extra"') ?? ''}>';
  }
}
