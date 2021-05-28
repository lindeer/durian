
import 'package:flutter/material.dart' show VoidCallback;
import 'exe_engine.dart';

/// ViewModel for PageModelWidget
abstract class PageModel {

  ScriptEngine get engine;

  void addListener(List<String> expressions, VoidCallback listener);

  void removeListener(VoidCallback listener);

  void dispose();

  factory PageModel.fake() => _FakeModel._fake;
}

class _FakeModel implements PageModel {
  static final _fake = _FakeModel();
  @override
  ScriptEngine get engine => throw UnimplementedError();

  @override
  void addListener(List<String> expressions, VoidCallback listener) {
  }

  @override
  void removeListener(VoidCallback listener) {
  }

  @override
  void dispose() {
  }
}

/// similar with ChangeNotifier
abstract class NotifierModel implements PageModel {
  final _listeners = <String, Set<VoidCallback>>{};

  @override
  void addListener(List<String> expressions, VoidCallback listener) {
    expressions.forEach((key) {
      final old = _listeners[key];
      final callbacks = old ?? <VoidCallback>{};
      callbacks.add(listener);
      if (old != callbacks) {
        _listeners[key] = callbacks;
      }
    });
  }

  @override
  void removeListener(VoidCallback listener) {
    final listeners = Map.of(_listeners);
    listeners.values.forEach((e) {
      e.remove(listener);
    });
  }

  @override
  void dispose() {
    _listeners.clear();
  }

  void _onPageCreated(Map<String, dynamic> result) {
  }

  void _onDataChanged(Map<String, dynamic> result) {
    final callbacks = <VoidCallback>{};
    for (final key in result.keys) {
      _listeners.keys
          .where((expr) => expr.contains(key))
          .map((expr) => _listeners[expr])
          .whereType<Set<VoidCallback>>().forEach((set) {
        callbacks.addAll(set);
      });
    }
    callbacks.forEach((cb) => cb());
  }

  void notifyDataChanged(Map<String, dynamic> data) {
    _onDataChanged(data);
  }
}

/// A model associated with an engine instance
class ScriptModel extends NotifierModel {
  final ScriptEngine _engine;

  ScriptModel._(this._engine);

  @override
  ScriptEngine get engine => _engine;

  factory ScriptModel(String code, ScriptEngine engine) {
    final model = ScriptModel._(engine);
    engine.registerBridge('_onPageCreated', model._onPageCreated);
    engine.eval(code, type: StatementType.declaration);
    engine.eval("""
function notifyChange(data) {
  sendMessage('_onDataChanged', JSON.stringify(data));
}
    """,
      type: StatementType.declaration,
    );
    engine.registerBridge('_onDataChanged', model._onDataChanged);
    return model;
  }
}
