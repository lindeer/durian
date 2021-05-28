import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xml_widget/xml_widget.dart';
import 'package:mockito/mockito.dart';

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  final assembler = WidgetAssembler(buildContext: _MockBuildContext());

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

  test('test color resource', () {
    const xml = """
<resources>
  <color name="colorPrimary">#ffffff</color>
  <color name="colorAccent">#ff7d41</color>
  <color name="orange">@flutter:color/orange</color>

  <state name="color_state_text">
    <item flutter:color="@flutter:color/green" flutter:state="hovered|focused"/>
    <item flutter:color="@flutter:color/red" flutter:state="dragged"/>
    <item flutter:color="#f0f"/>
  </state>

</resources>
""";
    final res = assembler.resource;
    res.loadResource(xml);
    expect(res['colorPrimary'], Color(0xffffffff));
    expect(res['orange']?.value, testColors['orange']?.value);
    final state = res.state('color_state_text');
    final c1 = state?.resolve({MaterialState.hovered, MaterialState.disabled, MaterialState.focused});
    expect(c1?.value, testColors['green']?.value);

    final c2 = state?.resolve({MaterialState.hovered, MaterialState.disabled, MaterialState.pressed});
    expect(c2?.value, 0xffff00ff);

    final c3 = state?.resolve({MaterialState.dragged});
    expect(c3?.value, testColors['red']?.value);
  });

  test('test color resource2', () {
    const xml = """
<resources>
  <color name="colorPrimary">#ffffff</color>
  <color name="colorAccent">#ff7d41</color>
  <color name="orange">@flutter:color/orange</color>

  <state name="color_state_text">
    <item flutter:color="@color/orange" flutter:state="hovered|focused"/>
    <item flutter:color="@color/colorAccent" flutter:state="dragged"/>
    <item flutter:color="@color/colorPrimary"/>
  </state>

</resources>
""";
    final res = assembler.resource;
    res.loadResource(xml);

    final state = res.state('color_state_text');
    final c1 = state?.resolve({MaterialState.hovered, MaterialState.disabled, MaterialState.focused});
    expect(c1?.value, res['orange']?.value);

    final c2 = state?.resolve({MaterialState.dragged});
    expect(c2?.value, res['colorAccent']?.value);

  });
}
