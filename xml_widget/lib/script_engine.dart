enum StatementType {
  assign,
  call,
  condition,
  declaration,
  expression,
  expression2,
}

abstract class ScriptEngine {
  String eval(String statement, {StatementType type = StatementType.expression});

  void registerBridge(String name, void bridge(Map<String, dynamic> result));
}
