import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/model_widget.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_resource.dart';
import 'package:xml_widget/xml_widget.dart';

class _TestEngine implements ScriptEngine {
  final Map<String, String> map;

  _TestEngine(this.map);

  @override
  String eval(
    String statement, {
    StatementType type = StatementType.expression,
  }) {
    return map[statement] ?? "{{$statement}}";
  }

  @override
  void registerBridge(String name, void bridge(Map<String, dynamic> result)) {}
}

class _TestMode extends NotifierModel {
  final _TestEngine _engine;
  final WidgetAssembler _assembler;
  final _res = AssembleResource.fake();
  _TestMode(this._engine, this._assembler);

  @override
  ScriptEngine get engine => _engine;

  void operator []=(String key, String value) {
    final map = _engine.map;
    if (map[key] != value) {
      map[key] = value;
      notifyDataChanged({key: value});
    }
  }

  @override
  WidgetAssembler get assemble => _assembler;

  @override
  InterOperation get interaction => throw UnimplementedError();

  @override
  AssembleResource get resource => _res;

  @override
  int sizeOf(String key) => (_engine.map[key] as List?)?.length ?? 0;
}

void main() {
  final assembler = WidgetAssembler();
  testWidgets('test list normal', (WidgetTester tester) async {
    const xml = """
    <ListView>
      <Text
        flutter:data="nice"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text
        flutter:data="good"/>
      <Container flutter:src="http://flutter.dev" />
    </ListView>
""";
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestModelWidget(
        _TestMode(_TestEngine({}), assembler),
        AssembleReader.fromSource(xml),
      ),
    ));
    final target = find.byType(ListView);
    expect(target, findsOneWidget);
  });

  testWidgets('test list with if', (WidgetTester tester) async {
    const xml = """
    <ListView>
      <Text
       flutter:data="nice"/>
      <Text
        flutter:if="condition == 1"
        flutter:data="good"/>
      <Text
        flutter:if="condition == 2"
        flutter:data="great"/>
      <Text
        flutter:elseif="condition == 3"
        flutter:data="excellent"/>
      <Container flutter:src="http://flutter.dev" />
    </ListView>
""";

    final e = _TestEngine({
      "condition == 1": "false",
      "condition == 2": "true",
      "condition == 3": "true",
    });
    final engine = _TestMode(e, assembler);

    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestModelWidget(
        engine,
        AssembleReader.fromSource(xml),
      ),
    ));
    await tester.pumpAndSettle();
    final target = find.byType(ListView);
    expect(target, findsOneWidget);
    expect(find.text('nice'), findsOneWidget);
    expect(find.text('good'), findsNothing);
    expect(find.text('great'), findsOneWidget);
    expect(find.text('excellent'), findsNothing);

    engine["condition == 2"] = "false";
    await tester.pump();
    expect(find.text('great'), findsNothing);
    expect(find.text('excellent'), findsOneWidget);
  });
}
