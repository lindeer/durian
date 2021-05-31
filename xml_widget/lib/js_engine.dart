import 'package:flutter_js/flutter_js.dart' as js;
import 'script_engine.dart';

class JSEngine implements ScriptEngine {
  final js.JavascriptRuntime _rt;
  final String domain;
  final _exprHandler = <StatementType, String Function(String expr)>{};

  JSEngine._(this._rt, this.domain);

  factory JSEngine({String prefix = 'page.data.'}) {
    final runtime = js.getJavascriptRuntime(xhr: false);
    final engine = JSEngine._(runtime, prefix);
    engine._exprHandler[StatementType.expression] = engine._prefix;
    engine._exprHandler[StatementType.condition] = engine._parseField;
    engine._exprHandler[StatementType.call] = engine._parseCall;
    return engine;
  }

  static final _reg = RegExp(r'[_a-zA-Z]\w*(\.\w+)*');

  String _prefix(String expr) => "$domain$expr";

  String _parseField(String expr) {
    return expr.replaceAllMapped(_reg, (m) => "$domain${m[0]}");
  }

  String _parseCall(String expr) => "page.$expr();";

  @override
  String eval(String statement, {StatementType type = StatementType.expression}) {
    final fn = _exprHandler[type];
    final code = fn?.call(statement) ?? statement;
    final result = _rt.evaluate(code);
    if (result.isError) {
      final str = code.length > 1024 ? code.substring(0, 1024) : code;
      print("eval error($type): '$str' -> '${result.stringResult}'");
      return '';
    }
    return result.stringResult;
  }

  @override
  void registerBridge(String name, void Function(Map<String, dynamic> result) bridge) {
    _rt.onMessage(name, (args) {
      final result = args as Map<String, dynamic>? ?? const <String, dynamic>{};
      bridge.call(result);
    });
  }
}
