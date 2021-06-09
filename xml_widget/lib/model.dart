
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

  /// separate interface to get list size of given key
  int sizeOf(String key);

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
  int sizeOf(String key) => 0;

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

  void notifyDataChanged(Map<String, dynamic> result) {
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
}

/// A model associated with an engine instance
class ScriptModel extends NotifierModel {
  final ScriptEngine _engine;
  final AssembleResource _resource;
  final InterOperation _operation;
  final WidgetAssembler _assembler;

  ScriptModel(this._engine, this._resource, this._operation, this._assembler);

  @override
  ScriptEngine get engine => _engine;

  @override
  AssembleResource get resource => _resource;

  @override
  InterOperation get interaction => _operation;

  @override
  WidgetAssembler get assemble => _assembler;

  @override
  int sizeOf(String key) => int.tryParse(engine.eval('$key.length')) ?? 0;
}

class _DataStore implements ScriptEngine {
  final Map<String, dynamic> _data;

  _DataStore(this._data);

  static const _null = 'null';

  void _assignValue(String expr) {
    int pos = expr.indexOf('=');

    if (pos > 0) {
      final left = expr.substring(0, pos);
      final right = expr.substring(pos + 1);
      final key = left.contains('item') ? 'item' : left.replaceFirst('var ', '').trim();
      final indexLeft = right.lastIndexOf('[');
      final indexRight = right.lastIndexOf(']');

      if (indexLeft < indexRight) {
        final index = int.tryParse(right.substring(indexLeft + 1, indexRight)) ?? -1;
        final name = right.substring(0, indexLeft).trim();
        final list = _data[name] as List?;
        _data[key] = list?[index];
      }
    }
  }

  String? _getValue(String key) {
    Map<String, dynamic> data = _data;
    final keys = key.split('.');
    final k = keys.last;
    for (int i = 0; i < keys.length - 1; i++) {
      data = data[keys[i]] as Map<String, dynamic>;
    }
    return data[k];
  }

  @override
  String eval(String statement, {StatementType type = StatementType.expression}) {
    if (type == StatementType.assign) {
      _assignValue(statement);
      return _null;
    }
    return _getValue(statement) ?? _null;
  }

  @override
  void registerBridge(String name, void bridge(Map<String, dynamic> result)) {
  }
}

class DialogModel implements PageModel {
  static const KEY_IDENTIFIER = '_name_';
  final _DataStore _data;
  final PageModel _parent;

  DialogModel._(this._data, this._parent);

  factory DialogModel(Map<String, dynamic> json, PageModel parent) {
    return DialogModel._(_DataStore(json), parent);
  }

  String operator[](String key) => _data._data[key] as String? ?? _DataStore._null;

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
  int sizeOf(String key) {
    final l = _data._data[key] as List?;
    return l?.length ?? 0;
  }

  @override
  void removeListener(listener) {
  }

  @override
  String toString() => _data._data.toString();
}
