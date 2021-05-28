
import 'package:flutter/material.dart';

abstract class AssembleResource {
  ThemeData get theme;

  Color? operator[](String? key);

  MaterialStateProperty<Color?>? state(String key);

  double? size(String? value);

  IconData? icon(String? key);
}