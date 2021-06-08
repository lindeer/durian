import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/js_engine.dart';
import 'package:xml_widget/model_widget.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/src/binding.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_resource.dart';
import 'package:xml_widget/xml_widget.dart';

void main() {
  testWidgets('js engine basic', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:style="@theme/textTheme.headline4"
        flutter:data="start"/>
      <Text
        flutter:if="{{size < 0}}"
        flutter:data="size < 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:if="{{size == 0}}"
        flutter:data="size == 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:if="{{size > 0}}"
        flutter:data="size > 0"
        flutter:style="@theme/textTheme.headline4"/>
      <Text
        flutter:style="@theme/textTheme.headline4"
        flutter:data="end"/>
    </Column>
""";

    final model = ScriptModel(
      """
let size = 0;
      """,
      JSEngine(prefix: ''),
      AssembleResource.fake(),
      InterOperation(),
      WidgetAssembler(),
    );
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestModelWidget(
        model,
        AssembleReader.fromSource(xml),
      ),
    ));
    await tester.pumpAndSettle();
    final engine = model.engine;
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('size < 0'), findsNothing);
    expect(find.text('size == 0'), findsOneWidget);
    expect(find.text('size > 0'), findsNothing);

    engine.eval('size = 1; notifyChange({size: size});', type: StatementType.declaration,);
    await tester.pump();
    expect(find.text('size < 0'), findsNothing);
    expect(find.text('size == 0'), findsNothing);
    expect(find.text('size > 0'), findsOneWidget);

    engine.eval('size = -1; notifyChange({size: size});', type: StatementType.declaration);
    await tester.pump();
    expect(find.text('size < 0'), findsOneWidget);
    expect(find.text('size == 0'), findsNothing);
    expect(find.text('size > 0'), findsNothing);
  });
}
