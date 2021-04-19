import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart' as js;
import 'exe_engine.dart';

class JSEngine implements ExeEngine {
  final js.JavascriptRuntime _rt;
  final _notifiers = <String, Set<VoidCallback>>{};

  JSEngine._(this._rt);

  factory JSEngine({String? code,}) {
    final runtime = js.getJavascriptRuntime(xhr: false);
    runtime.evaluate("""
async function notifyChange(keys) {
  await sendMessage('_onVariableChanged', JSON.stringify(keys));
}
    """);
    if (code != null) {
      runtime.evaluate(code);
    }
    final engine = JSEngine._(runtime);
    runtime.onMessage('_onVariableChanged', (args) {
      print('onVariableChanged(Dart): args=$args');
      if (args is List) {
        final callbacks = <VoidCallback>{};
        for (final key in args) {
          final cb = engine._notifiers[key];
          if (cb != null) {
            callbacks.addAll(cb);
          }
        }
        callbacks.forEach((cb) => cb());
      }
    });
    return engine;
  }

  @override
  void registerNotifier(List<String> keywords, VoidCallback callback) {
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
  String run(String statement) {
    final result = _rt.evaluate(statement);
    return result.stringResult;
  }
}
