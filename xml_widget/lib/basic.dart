part of durian;

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}
