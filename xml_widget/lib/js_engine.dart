import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart' as js;
import 'exe_engine.dart';

class JSEngine implements ScriptEngine {
  final js.JavascriptRuntime _rt;
  final _notifiers = <String, Set<VoidCallback>>{};

  JSEngine._(this._rt);

  factory JSEngine({String? code,}) {
    final runtime = js.getJavascriptRuntime(xhr: false);
    if (code != null) {
      runtime.evaluate(code);
    }
    final engine = JSEngine._(runtime);
    return engine;
  }

  @override
  Future<void> prepare(BuildContext context) async {
    _rt.evaluate("""
async function notifyChange(keys) {
  await sendMessage('_onVariableChanged', JSON.stringify(keys));
}
    """);
    _rt.onMessage('_onVariableChanged', (args) {
      print('onVariableChanged(Dart): args=$args');
      if (args is List) {
        final callbacks = <VoidCallback>{};
        for (final key in args) {
          final cbs = _notifiers.keys
              .where((expr) => expr.contains(key))
              .map((expr) => _notifiers[expr])
              .whereType<Set<VoidCallback>>();
          for (final cb in cbs) {
            callbacks.addAll(cb);
          }
        }
        callbacks.forEach((cb) => cb());
      }
    });
    return Future.value();
  }

  @override
  void dispose() {
    _notifiers.clear();
  }

  @override
  void addListener(List<String> keywords, VoidCallback callback) {
    print("registerNotifier: keywords=$keywords");
    keywords.forEach((key) {
      final old = _notifiers[key];
      final callbacks = old ?? <VoidCallback>{};
      callbacks.add(callback);
      if (old != callbacks) {
        _notifiers[key] = callbacks;
      }
    });
  }

  @override
  String eval(String statement) {
    final result = _rt.evaluate("page.data.$statement");
    return result.stringResult;
  }
}
