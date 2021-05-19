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

final _loading = Container(
  constraints: const BoxConstraints.tightFor(
    width: 64,
    height: 64,
  ),
  alignment: Alignment.center,
  child: const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(
      Colors.deepOrangeAccent,
    ),
  ),
);

class ExeEngineWidget extends InheritedWidget {
  static final _fake = ScriptEngine.fake();
  final ScriptEngine engine;

  ExeEngineWidget({required this.engine, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant ExeEngineWidget oldWidget) {
    return engine != oldWidget.engine;
  }

  static ScriptEngine of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<ExeEngineWidget>()?.widget as ExeEngineWidget?;
    return widget?.engine ?? _fake;
  }

  // only if engine is ready
  static Widget attachAsync(Future<ScriptEngine> future, Widget child) {
    return FutureBuilder<ScriptEngine>(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ExeEngineWidget(
            engine: snapshot.requireData,
            child: child,
          );
        } else {
          return _loading;
        }
      },
    );
  }
}
