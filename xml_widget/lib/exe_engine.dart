import 'package:flutter/material.dart';
import 'js_engine.dart';

abstract class ScriptEngine {
  String eval(String statement);

  void registerNotifier(List<String> keywords, VoidCallback cb);

  factory ScriptEngine.fake() => _FakeEngine();

  factory ScriptEngine({String? code,}) = JSEngine;
}

class _FakeEngine implements ScriptEngine {
  @override
  String eval(String statement) => "";

  @override
  void registerNotifier(List<String> keywords, VoidCallback cb) {
  }
}

class ExeEngineWidget extends InheritedWidget {
  static final _fake = ScriptEngine.fake();
  final ScriptEngine engine;

  ExeEngineWidget({required this.engine, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant ExeEngineWidget oldWidget) {
    return engine != oldWidget.engine;
  }

  static ScriptEngine of(BuildContext context) {
    final ExeEngineWidget? widget = context.dependOnInheritedWidgetOfExactType<ExeEngineWidget>();
    return widget?.engine ?? _fake;
  }
}
