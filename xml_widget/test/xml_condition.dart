import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/xml_widget.dart';
import 'package:mockito/mockito.dart';

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  testWidgets('test template-if', (WidgetTester tester) async {
    const xml = """
    <Column>
      <Text
        flutter:if="false"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text flutter:data="good"/>
    </Column>
""";
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (ctx) {
        final assembler = WidgetAssembler(buildContext: ctx);
        return assembler.fromSource(xml);
      },),
    ));
    final target = find.byType(ConditionWidget);
    expect(target, findsOneWidget);
    expect(find.text('{{message}}'), findsNothing);
    expect(find.text('good'), findsOneWidget);
    await tester.pump();
  });
  /*
  test('test template-if', () {
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
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 2);
    expect(widget.children[0] is ConditionWidget, true);
    expect(widget.children[1] is Text, true);
    final condition = widget.children[0] as ConditionWidget;
    expect(condition.children.length, 1);
    expect(condition.children[0].raw['flutter:if'], "condition == 1");
  });

  test('test template-if-else', () {
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
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 1);
    expect(widget.children[0] is ConditionWidget, true);
    final condition = widget.children[0] as ConditionWidget;
    expect(condition.children.length, 2);
    expect(condition.children[0].raw['flutter:if'], "condition == 1");
    expect(condition.children[1].raw['flutter:else'], "");
  });

  test('test template-if-elseif', () {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <VGroup flutter:elseif="condition == 2">
        <Text
          flutter:data="{{message}}"
          flutter:maxLines="3"
          flutter:softWrap="true"
          flutter:textDirection="rtl"/>
        <Text flutter:data="good"/>
      </VGroup>
      <Image flutter:src="http://flutter.dev" />
    </Column>
""";
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 2);
    expect(widget.children[0] is ConditionWidget, true);
    expect(widget.children[1] is Image, true);
  });

  test('test template-if-elseif2', () {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <VGroup flutter:elseif="condition == 2">
        <Text
          flutter:data="{{message}}"
          flutter:maxLines="3"
          flutter:softWrap="true"
          flutter:textDirection="rtl"/>
        <Text flutter:data="good"/>
      </VGroup>
      <Image flutter:elseif="condition == 3" flutter:src="{{url}}" />
    </Column>
""";
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 1);
    expect(widget.children[0] is ConditionWidget, true);
    final condition = widget.children[0] as ConditionWidget;
    expect(condition.children.length, 3);
    expect(condition.children[0].raw['flutter:if'], "condition == 1");
    expect(condition.children[1].raw['flutter:elseif'], "condition == 2");
    expect(condition.children[2].raw['flutter:elseif'], "condition == 3");
  });

  test('test template-if-elseif-else', () {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <VGroup flutter:elseif="condition == 2">
        <Text
          flutter:data="{{message}}"
          flutter:maxLines="3"
          flutter:softWrap="true"
          flutter:textDirection="rtl"/>
        <Text flutter:data="good"/>
      </VGroup>
      <Image flutter:else="" flutter:src="{{url}}" />
    </Column>
""";
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 1);
    expect(widget.children[0] is ConditionWidget, true);
    final condition = widget.children[0] as ConditionWidget;
    expect(condition.children.length, 3);
    expect(condition.children[0].raw['flutter:if'], "condition == 1");
    expect(condition.children[1].raw['flutter:elseif'], "condition == 2");
    expect(condition.children[2].raw['flutter:else'], "");
  });
  test('test if-if', () {
    const xml = """
    <Column>
      <Text
        flutter:if="condition == 1"
        flutter:data="{{message}}"
        flutter:maxLines="3"
        flutter:softWrap="true"
        flutter:textDirection="rtl"/>
      <Text flutter:data="good"/>
      <Image flutter:if="condition == 2" flutter:src="{{url}}" />
    </Column>
""";
    final widget = assembler.fromSource(xml) as Column;
    expect(widget.children.length, 3);
    expect(widget.children[0] is ConditionWidget, true);
    expect(widget.children[2] is ConditionWidget, true);
    final condition = widget.children[0] as ConditionWidget;
    expect(condition.children.length, 1);
    final c2 = widget.children[2] as ConditionWidget;
    expect(c2.children.length, 1);
    expect(c2.children[0].raw['flutter:if'], "condition == 2");
  });

   */
}
