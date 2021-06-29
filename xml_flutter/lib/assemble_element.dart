part of durian;

class _AssembleElement {
  final String name;
  final Map<String, String> style;
  final Map<String, String>? extra;
  final List<_AssembleElement> children;

  _AssembleElement(this.name, this.style, this.extra, this.children);

  @override
  String toString() {
    return '<$name style="$style" ${extra?.let((it) => 'extra="$extra"') ?? ''}>';
  }
}
