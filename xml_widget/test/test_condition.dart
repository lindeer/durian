import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/model_widget.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_resource.dart';
import 'package:xml_widget/xml_widget.dart';
import 'package:xml_widget/src/binding.dart';

class _TestEngine implements ScriptEngine {
  final Map<String, String> map;

  _TestEngine(this.map);

  @override
  String eval(String statement, {StatementType type = StatementType.expression}) {
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
  testWidgets('test template-if', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text flutter:data="good"/>
    </Column>
""";
    final e = _TestEngine({
      "condition == 1": "false",
      "condition == 2": "true",
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);

    engine['condition == 1'] = "true";
    await tester.pump();
    expect(find.text('{{message}}'), findsOneWidget);

    engine['condition == 1'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
  });

  testWidgets('test template-if-else', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text flutter:else="" flutter:data="good"/>
    </Column>
""";
    final e = _TestEngine({
      "condition == 1": "false",
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);

    engine['condition == 1'] = "true";
    await tester.pump();
    expect(find.text('{{message}}'), findsOneWidget);
    expect(find.text('good'), findsNothing);
  });

  testWidgets('test template-elseif', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text
        flutter:elseif="condition == 2"
        flutter:data="good"/>
      <Container flutter:src="http://flutter.dev" />
    </Column>
""";
    final e = _TestEngine({
      "condition == 1": "false",
      "condition == 2": "true",
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    engine['condition == 1'] = "true";
    await tester.pump();
    expect(find.text('{{message}}'), findsOneWidget);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('test template-elseif2', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text
        flutter:elseif="condition == 2"
        flutter:data="good"/>
      <Container flutter:elseif="condition == 3" />
    </Column>
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsNothing);

    engine['condition == 1'] = "true";
    await tester.pump();
    expect(find.text('{{message}}'), findsOneWidget);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsNothing);

    engine['condition == 1'] = "false";
    engine['condition == 2'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsOneWidget);

    engine['condition == 3'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('test template-elseif-else', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text
        flutter:elseif="condition == 2"
        flutter:data="good"/>
      <Container flutter:else="" />
    </Column>
""";
    final e = _TestEngine({
      "condition == 1": "true",
      "condition == 2": "false",
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsOneWidget);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsNothing);

    engine['condition == 1'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsNothing);
    expect(find.byType(Container), findsOneWidget);

    engine['condition == 2'] = "true";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('test template-elseif-else', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text
        flutter:data="good"/>
      <Container
        flutter:if="condition == 2"
        flutter:else="" />
    </Column>
""";
    final e = _TestEngine({
      "condition == 1": "true",
      "condition == 2": "true",
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
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsOneWidget);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    engine['condition == 1'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    engine['condition == 2'] = "false";
    await tester.pump();
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Container), findsNothing);
  });
}
