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
      home: Builder(builder: (ctx) {
        final assembler = WidgetAssembler(buildContext: ctx);
        return assembler.fromSource(xml);
      }),
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
