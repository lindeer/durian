library durian;

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
part 'basic.dart';
part 'text.dart';

abstract class XmlWidgetBuilder {
  String get name;

  bool get childless;

  Widget build(XmlElement element, List<Widget> children);
}

abstract class CommonWidgetBuilder implements XmlWidgetBuilder {
  final String _name;

  const CommonWidgetBuilder(this._name);

  String get name => _name;

  bool get childless => false;

}

class WidgetAssembler {
  final _builders = Map.of(_defaultBuilders);

  WidgetAssembler({
    List<XmlWidgetBuilder>? builders,
  }) {
    if (builders != null && builders.isNotEmpty) {
      final map = {
        for (final b in builders) b.name: b
      };
      _builders.addAll(map);
    }
  }

  static const _builtinBuilders = <XmlWidgetBuilder>[
    const _XmlTextBuilder(),
  ];

  static final _defaultBuilders = {
    for (final builder in _builtinBuilders) builder.name: builder
  };

  Widget _assembleDefaultWidget(XmlElement element, List<Widget> children) {
    return Row(
      children: children,
    );
  }

  Widget _assembleByElement(XmlElement element) {
    final name = element.name.qualified;
    final builder = _builders[name];

    Widget w;
    if (builder != null) {
      final children = builder.childless ? const <Widget>[]
          : _inflateChildren(element);
      w = builder.build(element, children);
    } else {
      w = _assembleDefaultWidget(element, _inflateChildren(element));
    }
    return w;
  }

  List<Widget> _inflateChildren(XmlElement element) => element.children
      .where((node) => node.nodeType == XmlNodeType.ELEMENT)
      .map((e) => e as XmlElement)
      .map((e) => _assembleByElement(e))
      .toList(growable: false);

  static Widget parseFile(String path) {
    final f = File(path);
    final doc = XmlDocument.parse(f.readAsStringSync());
    final root = doc.rootElement;
    final assembler = WidgetAssembler();
    return assembler._assembleByElement(root);
  }
}
