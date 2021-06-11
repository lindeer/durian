import 'package:flutter/material.dart';

abstract class AssembleResource {
  Color? operator [](String? key);

  MaterialStateProperty<Color?>? state(String key);

  double? size(String? value);

  IconData? icon(String? key);

  factory AssembleResource.fake() => _FakeRes._fake;
}

class _FakeRes implements AssembleResource {
  static final _fake = _FakeRes();
  @override
  Color? operator [](String? key) {
    //
  }

  @override
  IconData? icon(String? key) {
    //
  }

  @override
  double? size(String? value) {
    //
  }

  @override
  MaterialStateProperty<Color?>? state(String key) {
    //
  }
}
