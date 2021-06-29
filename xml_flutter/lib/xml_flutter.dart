library durian;

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

part 'assemble_element.dart';
part 'assemble_reader.dart';
part 'assemble_style.dart';
part 'xml_assemble.dart';

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}
