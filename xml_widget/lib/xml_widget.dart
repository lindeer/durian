library durian;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'element.dart';
export 'element.dart';

part 'basic.dart';
part 'text.dart';
part 'group.dart';
part 'container.dart';
part 'xml_resource.dart';

abstract class XmlWidgetBuilder {
  String get name;

  bool get childless;

  // children would be empty if childless is false
  Widget build(AssembleElement element, List<Widget> children);
}

abstract class CommonWidgetBuilder implements XmlWidgetBuilder {
  final String _name;

  const CommonWidgetBuilder(this._name);

  String get name => _name;

  bool get childless => false;

}

class WidgetAssembler {

  final _builders = Map.of(_defaultBuilders);
  final AssembleContext context;

  WidgetAssembler({
    required BuildContext buildContext,
    OnPressHandler? onPressHandler,
    List<XmlWidgetBuilder>? builders,
  }) : context = AssembleContext(buildContext, onPressHandler) {
    if (builders != null && builders.isNotEmpty) {
      final map = {
        for (final b in builders) b.name: b
      };
      _builders.addAll(map);
    }
  }

  static const _noChild = const <Widget>[];
  static const _builtinBuilders = <XmlWidgetBuilder>[
    const _XmlTextBuilder(),
    const _XmlColumnBuilder(),
    const _XmlRowBuilder(),
    const _XmlWrapBuilder(),
    const _XmlContainerBuilder(),
    const _XmlInkBuilder(),
    const _XmlRaisedButtonBuilder(),
    const _XmlFlatButtonBuilder(),
    const _XmlMaterialButtonBuilder(),
    const _XmlElevatedButtonBuilder(),
    const _XmlTextButtonBuilder(),
    const _XmlPaddingBuilder(),
    const _XmlInkWellBuilder(),
  ];

  static final _defaultBuilders = {
    for (final builder in _builtinBuilders) builder.name: builder
  };

  Widget _assembleDefaultWidget(AssembleElement element, List<Widget> children) {
    return Row(
      children: children,
    );
  }

  Widget _assembleByElement(AssembleElement element) {
    final e = element.e;
    final name = e.name.qualified;
    final builder = _builders[name];

    Widget w;
    if (builder != null) {
      final children = builder.childless ? _noChild
          : _inflateChildren(element);
      w = builder.build(element, children);
    } else {
      w = _assembleDefaultWidget(element, _inflateChildren(element));
    }
    return w;
  }

  List<Widget> _inflateChildren(AssembleElement element) => element.e.children
      .where((node) => node.nodeType == XmlNodeType.ELEMENT)
      .map((e) => AssembleElement(e as XmlElement, element.context))
      .map((e) => _assembleByElement(e))
      .toList(growable: false);

  Widget fromFile(String path) {
    final f = File(path);
    return fromSource(f.readAsStringSync());
  }

  Widget fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    final element = AssembleElement(root, context);
    return _assembleByElement(element);
  }
}
