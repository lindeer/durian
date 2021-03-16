import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/xml_widget.dart';

void main() {
  final assembler = WidgetAssembler();

  test('test text widget - plain text', () {
    const xml = """
<Text flutter:data="widget from xml"></Text>
""";
    final widget = assembler.fromSource(xml);
    expect(widget is Text, true);
    final w = widget as Text;
    expect(w.data, 'widget from xml');
  });

  test('test text widget - property', () {
    const xml = """
<Text
  flutter:data="widget from xml"
  flutter:maxLines="3"
  flutter:softWrap="true"
  flutter:textDirection="rtl"/>
""";
    final widget = assembler.fromSource(xml);
    expect(widget is Text, true);
    final w = widget as Text;
    expect(w.data, 'widget from xml');
    expect(w.maxLines, 3);
    expect(w.softWrap, true);
    expect(w.textDirection, TextDirection.rtl);
    expect(w.textAlign, null);
  });

  test('test text style', () {
    const xml = """
<Text
  flutter:data="widget from xml"
  flutter:style.color="#777"
  flutter:style.fontSize="14sp"/>
""";
    final widget = assembler.fromSource(xml);
    expect(widget is Text, true);
    final w = widget as Text;
    final style = w.style;
    expect(style?.fontSize, 14);
  });
}
