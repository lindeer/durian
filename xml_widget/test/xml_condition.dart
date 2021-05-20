import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/exe_engine.dart';
import 'package:xml_widget/xml_widget.dart';

class _TestEngine implements ScriptEngine {
  final Map<String, String> map;
  VoidCallback? cb;

  _TestEngine(this.map);

  @override
  String eval(String statement) => map[statement] ?? "";

  @override
  void addListener(List<String> keywords, VoidCallback cb) {
    this.cb = cb;
  }

  @override
  Future<void> prepare(BuildContext context) => Future.value();

  @override
  void dispose() {
    this.cb = null;
  }

  void operator []=(String key, String value) {
    if (map[key] != value) {
      map[key] = value;
      cb?.call();
    }
  }
}

void main() {
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
    final engine = _TestEngine({
      "condition == 1" : "false",
      "condition == 2" : "true",
    });

    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
    final engine = _TestEngine({
      "condition == 1" : "false",
    });
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
    final engine = _TestEngine({
      "condition == 1" : "false",
      "condition == 2" : "true",
    });
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
    final engine = _TestEngine({
      "condition == 1" : "false",
      "condition == 2" : "true",
      "condition == 3" : "true",
    });
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
    final engine = _TestEngine({
      "condition == 1" : "true",
      "condition == 2" : "false",
    });
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
    final engine = _TestEngine({
      "condition == 1" : "true",
      "condition == 2" : "true",
    });
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExeEngineWidget(
        engine: engine,
        child: Builder(builder: (ctx) {
          final assembler = WidgetAssembler(buildContext: ctx);
          return assembler.fromSource(xml);
        },),
      ),
    ));
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
