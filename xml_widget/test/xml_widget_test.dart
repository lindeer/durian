import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:xml_widget/xml_widget.dart';

void main() {
  test('test text widget - plain text', () {
    const xml = """
<Text>
widget from xml
</Text>
""";
    final assembler = WidgetAssembler();
    final widget = assembler.fromSource(xml);
    expect(widget is Text, true);
    final w = widget as Text;
    expect(w.data, 'widget from xml');
  });

  test('test text widget - rich text', () {
    const xml = '<Text>widget <span>from</span> xml</Text>';
    final assembler = WidgetAssembler();
    final widget = assembler.fromSource(xml);
    expect(widget is RichText, true);
    final w = widget as RichText;
    expect(w.text.toPlainText(), 'widget from xml');
    final span = w.text;
    final children = <InlineSpan>[];
    span.visitChildren((span) {
      children.add(span);
      return true;
    });
    expect(children.length, 3);
  });
}
