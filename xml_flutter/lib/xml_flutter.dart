library durian;

import 'package:xml/xml.dart';

part 'assemble_element.dart';
part 'assemble_reader.dart';

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}
