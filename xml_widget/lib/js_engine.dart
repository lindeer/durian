import 'package:flutter_js/flutter_js.dart' as js;
import 'script_engine.dart';

class JSEngine implements ScriptEngine {
  final js.JavascriptRuntime _rt;

  JSEngine._(this._rt);
  factory JSEngine() {
    final runtime = js.getJavascriptRuntime(xhr: false);
    return JSEngine._(runtime);
  }

  @override
  String eval(String statement, {StatementType type = StatementType.expression}) {
    final code = type == StatementType.expression ? "page.data.$statement" : statement;
    final result = _rt.evaluate(code);
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
