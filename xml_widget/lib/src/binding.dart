library durian.binding;

import 'package:flutter/material.dart';
import 'package:xml_widget/model_widget.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
part 'binding_condition.dart';
part 'binding_data.dart';
part 'binding_loop.dart';

class DataBinding {

  static final _reg = RegExp(r'{{(.+?)}}');

  static bool hasMatch(AssembleElement element) {
    final values = element.raw.values;
    for (final v in values) {
      if (_reg.hasMatch(v)) {
        return true;
      }
    }
    return false;
  }

  static List<String> matchKeys(AssembleElement element) {
    final values = element.raw.values;
    final keys = <String>{};
    for (final value in values) {
      final matches = _reg.allMatches(value);
      final items = matches.map((m) => m[0]).whereType<String>();
      keys.addAll(items);
    }
    return keys.toList(growable: false);
  }

  static String? matchKey(String? text) => text == null ? null : _reg.firstMatch(text)?[1] ?? text;

  static void bind(AssembleElement element, String getter(String code)) {
    final attrs = Map.of(element.raw);
    attrs.forEach((key, value) {
      if (value.contains("{{")) {
        final matches = _reg.allMatches(value);
        for (final m in matches) {
          final statement = m[1];
          if (statement != null) {
            final v = getter.call(statement);
            value = value.replaceAll("{{$statement}}", v);
          }
        }
        final k = key.replaceAll('flutter:', '');
        element.attrs[k] = value;
      }
    });
  }
}
