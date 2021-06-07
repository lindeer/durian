
import 'package:flutter/material.dart' show VoidCallback;
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_resource.dart';
import 'package:xml_widget/xml_widget.dart';
import 'script_engine.dart';

/// ViewModel for PageModelWidget
abstract class PageModel {

  /// evaluate expression
  ScriptEngine get engine;

  /// color, dimen...
  AssembleResource get resource;

  /// onPressed, onLongPressed, onScrolled...
  InterOperation get interaction;

  /// build new widget by element
  WidgetAssembler get assemble;

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
  AssembleResource get resource => AssembleResource.fake();

  @override
  InterOperation get interaction => throw UnimplementedError();

  @override
  WidgetAssembler get assemble => throw UnimplementedError();

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
  final AssembleResource _resource;
  final InterOperation _operation;
  final WidgetAssembler _assembler;

  ScriptModel._(this._engine, this._resource, this._operation, this._assembler);

  @override
  ScriptEngine get engine => _engine;

  @override
  AssembleResource get resource => _resource;

  @override
  InterOperation get interaction => _operation;

  @override
  WidgetAssembler get assemble => _assembler;

  factory ScriptModel(String code, ScriptEngine engine, AssembleResource res, InterOperation operation, WidgetAssembler assemble) {
    final model = ScriptModel._(engine, res, operation, assemble);
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

class _DataStore implements ScriptEngine {
  final Map<String, String> _data;

  _DataStore(this._data);

  @override
  String eval(String statement, {StatementType type = StatementType.expression}) {
    return _data[statement] ?? '';
  }

  @override
  void registerBridge(String name, void bridge(Map<String, dynamic> result)) {
  }
}

class DialogModel implements PageModel {
  final _DataStore _data;
  final PageModel _parent;

  DialogModel._(this._data, this._parent);

  factory DialogModel(Map<String, dynamic> json, PageModel parent) {
    return DialogModel._(_DataStore(json.cast()), parent);
  }

  String operator[](String key) => _data._data[key] ?? '';

  @override
  void addListener(List<String> expressions, listener) {
  }

  @override
  void dispose() {
  }

  @override
  ScriptEngine get engine => _data;

  @override
  WidgetAssembler get assemble => _parent.assemble;

  @override
  InterOperation get interaction => _parent.interaction;

  @override
  AssembleResource get resource => _parent.resource;

  @override
  void removeListener(listener) {
  }

  @override
  String toString() => _data._data.toString();
}
