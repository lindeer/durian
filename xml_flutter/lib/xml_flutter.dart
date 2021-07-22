library durian;

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

part 'assemble_element.dart';
part 'assemble_reader.dart';
part 'assemble_style.dart';
part 'assemble_view.dart';
part 'xml_assemble.dart';

extension _TExt<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

class PreProcessor {
  final double _width;

  PreProcessor(this._width);

  String preprocess(BuildContext context, String source) {
    String result = processSize(context, source);
    return result;
  }

  String processSize(BuildContext context, String source) {
    final reg = RegExp(r'(\d+(\.\d+)?)(rpx|px|%)');
    return source.replaceAllMapped(reg, (match) {
      final v = match[1]!;
      final unit = match[3];

      if (unit == 'rpx') {
        final value = double.tryParse(v) ?? 0;
        return (value * _width / 750).toStringAsFixed(2);
      }
      if (unit == '%') {
        final value = double.tryParse(v) ?? 0;
        return (-value / 100).toStringAsFixed(2);
      }
      return v;
    });
  }
}
