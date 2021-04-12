
import 'package:flutter/material.dart';

abstract class ExeEngine {
  String run(String statement);

  void registerNotifier(List<String> keywords, VoidCallback cb);

  factory ExeEngine.fake() => _FakeEngine();
}

class _FakeEngine implements ExeEngine {
  @override
  String run(String statement) => "";

  @override
  void registerNotifier(List<String> keywords, VoidCallback cb) {
  }
}

class ExeEngineWidget extends InheritedWidget {
  static final _fake = ExeEngine.fake();
  final ExeEngine engine;

  ExeEngineWidget({required this.engine, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant ExeEngineWidget oldWidget) {
    return engine != oldWidget.engine;
  }

  static ExeEngine of(BuildContext context) {
    final ExeEngineWidget? widget = context.dependOnInheritedWidgetOfExactType<ExeEngineWidget>();
    return widget?.engine ?? _fake;
  }
}
