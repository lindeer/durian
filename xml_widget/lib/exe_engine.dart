import 'package:flutter/material.dart';
import 'js_engine.dart';

abstract class ScriptEngine {

  Future<void> prepare(BuildContext context);

  void dispose();

  String eval(String statement);

  void addListener(List<String> keywords, VoidCallback cb);

  factory ScriptEngine.fake() => _FakeEngine();

  factory ScriptEngine({String? code,}) = JSEngine;
}

class _FakeEngine implements ScriptEngine {

  @override
  Future<void> prepare(BuildContext context) => Future.value();

  @override
  void dispose() {
  }

  @override
  String eval(String statement) => "";

  @override
  void addListener(List<String> keywords, VoidCallback cb) {
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

class ExeEngineWidget extends StatefulWidget {
  static final _fake = ScriptEngine.fake();
  final ScriptEngine engine;
  final Widget child;

  ExeEngineWidget({required this.engine, required this.child, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EngineState();

  static ScriptEngine of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_ShareEngineWidget>()?.widget as _ShareEngineWidget?;
    return widget?.engine ?? _fake;
  }
}

class _EngineState extends State<ExeEngineWidget> {

  @override
  Widget build(BuildContext context) {
    final engine = widget.engine;
    return FutureBuilder<void>(
      future: engine.prepare(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _ShareEngineWidget(
            engine: engine,
            child: widget.child,
          );
        } else {
          return _loading;
        }
      },
    );
  }

  @override
  void didUpdateWidget(ExeEngineWidget oldWidget) {
    if (widget.engine != oldWidget.engine) {
      oldWidget.engine.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    widget.engine.dispose();
  }
}

class _ShareEngineWidget extends InheritedWidget {
  final ScriptEngine engine;

  _ShareEngineWidget({required this.engine, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_ShareEngineWidget oldWidget) {
    return oldWidget.engine != engine;
  }
}
