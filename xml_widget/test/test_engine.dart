import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/exe_engine.dart';
import 'package:xml_widget/xml_widget.dart';

void main() {
  testWidgets('js engine basic', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:style="@theme/textTheme.headline4"
        flutter:data="start"/>
      <Text
        flutter:if="size < 0"
        flutter:data="size < 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:if="size == 0"
        flutter:data="size == 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:if="size > 0"
        flutter:data="size > 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:style="@theme/textTheme.headline4"
        flutter:data="end"/>
    </Column>
""";

    final engine = ScriptEngine(
      code: """
let size = 0;
      """,
    );
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
    expect(find.text('size < 0'), findsNothing);
    expect(find.text('size == 0'), findsOneWidget);
    expect(find.text('size > 0'), findsNothing);

    engine.eval('size = 1; notifyChange(["size"]);');
    await tester.pump();
    expect(find.text('size < 0'), findsNothing);
    expect(find.text('size == 0'), findsNothing);
    expect(find.text('size > 0'), findsOneWidget);

    engine.eval('size = -1; notifyChange(["size"]);');
    await tester.pump();
    expect(find.text('size < 0'), findsOneWidget);
    expect(find.text('size == 0'), findsNothing);
    expect(find.text('size > 0'), findsNothing);
  });
}
