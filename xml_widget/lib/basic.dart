part of durian;

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

extension _StringExt on String {

  TextDirection? toTextDirection() {
    final s = this.toLowerCase();
    if (s == 'rtl') return TextDirection.rtl;
    else if (s == 'ltr') return TextDirection.ltr;
    else return null;
  }
}
