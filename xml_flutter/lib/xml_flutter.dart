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

final _mainAxisAlignment = MainAxisAlignment.values.asMap().map((key, value) => MapEntry(value, value.toString().split('.').last));
final _crossAxisAlignment = CrossAxisAlignment.values.asMap().map((key, value) => MapEntry(value, value.toString().split('.').last));
const _alignment = {
  "center": Alignment.center,
  "centerLeft": Alignment.centerLeft,
  "centerRight": Alignment.centerRight,
};

class PreProcessor {
  final double _width;

  PreProcessor(this._width);

  String preprocess(BuildContext context, String source) {
    String result = processSize(context, source);
    result = _processColor(context, result);
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

  static final _rgbColor = RegExp(r'rgba?\((.+)\)');
  String _processColor(BuildContext c, String source) {
    return source.replaceAllMapped(_rgbColor, (match) {
      final v = match[1]!;
      final color = _rgbaColor(v);
      return color != null ? '#${color.value.toRadixString(16)}': '';
    });
  }

  static Color? _rgbaColor(String text) {
    final rgb = text.split(',').map((value) => double.tryParse(value))
        .whereType<double>().toList(growable: false);
    if (rgb.length == 4) {
      return Color.fromRGBO(
        rgb[0].toInt(),
        rgb[1].toInt(),
        rgb[2].toInt(),
        rgb[3],
      );
    } else if (rgb.length == 3) {
      return Color.fromRGBO(
        rgb[0].toInt(),
        rgb[1].toInt(),
        rgb[2].toInt(),
        1.0,
      );
    }
  }
}
