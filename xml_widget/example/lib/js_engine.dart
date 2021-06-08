import 'package:flutter_js/flutter_js.dart' as js;
import 'package:xml_widget/script_engine.dart';

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
    engine._exprHandler[StatementType.expression2] = engine._prefix2;
    engine._exprHandler[StatementType.assign] = engine._parseAssign;
    return engine;
  }

  static final _reg = RegExp(r'[_a-zA-Z]\w*(\.\w+)*');

  String _prefix(String expr) => expr.startsWith('item.') ? expr : "$domain$expr";

  String _parseField(String expr) {
    return expr.replaceAllMapped(_reg, (m) {
      final name = m[0] ?? '';
      return name == 'item' ? name : "$domain$name";
    });
  }

  String _parseCall(String expr) => expr.startsWith('item.') ?  '$expr();' :  "page.$expr();";

  String _parseAssign(String expr) {
    int pos = expr.indexOf('=') + 1;

    if (pos > 0) {
      final r = _parseField(expr.substring(pos));
      final ret = "${expr.substring(0, pos)}$r";
      return ret;
    } else {
      return expr;
    }
  }

  String _prefix2(String expr) => "page.$expr";

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
