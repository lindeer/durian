library durian;

import 'dart:io';

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'element.dart';
export 'element.dart';

part 'basic.dart';
part 'text.dart';
part 'group.dart';
part 'container.dart';
part 'resource.dart';
part 'condition.dart';

abstract class XmlWidgetBuilder {
  String get name;

  bool get childless;

  // children would be empty if childless is false
  Widget build(AssembleElement element, List<AssembleChildElement> descendant);
}

abstract class CommonWidgetBuilder implements XmlWidgetBuilder {
  final String _name;

  const CommonWidgetBuilder(this._name);

  String get name => _name;

  bool get childless => false;

}

class WidgetAssembler {

  final _builders = Map.of(_defaultBuilders);
  final _colors = XmlResColor();
  late final AssembleContext context;

  WidgetAssembler({
    required BuildContext buildContext,
    OnPressHandler? onPressHandler,
    List<XmlWidgetBuilder>? builders,
  }) {
    context = AssembleContext(buildContext, _colors, onPressHandler);
    if (builders != null && builders.isNotEmpty) {
      final map = {
        for (final b in builders) b.name: b
      };
      _builders.addAll(map);
    }
  }

  static const _noChild = const <AssembleChildElement>[];
  static const _builtinBuilders = <XmlWidgetBuilder>[
    const _XmlTextBuilder(),
    const _XmlColumnBuilder(),
    const _XmlRowBuilder(),
    const _XmlWrapBuilder(),
    const _XmlContainerBuilder(),
    const _XmlInkBuilder(),
    const _XmlRaisedButtonBuilder(),
    const _XmlFlatButtonBuilder(),
    const _XmlOutlineButtonBuilder(),
    const _XmlMaterialButtonBuilder(),
    const _XmlElevatedButtonBuilder(),
    const _XmlTextButtonBuilder(),
    const _XmlOutlinedButtonBuilder(),
    const _XmlPaddingBuilder(),
    const _XmlInkWellBuilder(),
    const _XmlStackBuilder(),
    const _XmlFlexBuilder(),
    const _XmlScaffoldBuilder(),
    const _XmlFloatingActionButtonBuilder(),
    const _XmlAppBarBuilder(),
    const _XmlIconBuilder(),
    const _XmlCenterBuilder(),
    const _XmlIntrinsicWidthBuilder(),
    const _XmlIntrinsicHeightBuilder(),
    const _XmlImageBuilder(),
    const _XmlAlignBuilder(),
    const _XmlAspectRatioBuilder(),
    const _XmlFittedBoxBuilder(),
    const _XmlBaselineBuilder(),
    const _XmlPositionedBuilder(),
    const _XmlSizedBoxBuilder(),
    const _XmlOpacityBuilder(),
  ];

  static final _defaultBuilders = {
    for (final builder in _builtinBuilders) builder.name: builder
  };

  Widget _assembleDefaultWidget(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    return Row(
      children: children,
    );
  }

  Widget _assembleByElement(AssembleElement element) {
    final e = element.e;
    final name = e.name.qualified;
    final builder = _builders[name];

    final childrenElements = builder != null && builder.childless ? _noChild
        : _inflateChildren(element);

    bool containIf = false;
    for (final e in childrenElements) {
      final ifStat = e.raw['flutter:if'];
      containIf = ifStat?.isNotEmpty ?? false;
      if (containIf) {
        break;
      }
    }

    final children = containIf ? _ChildMaker.merge(childrenElements) : childrenElements;
    Widget w;
    if (builder != null) {
      w = builder.build(element, children);
    } else {
      w = _assembleDefaultWidget(element, children);
    }

    return w;
  }

  List<AssembleChildElement> _inflateChildren(AssembleElement element) => element.e.children
      .where((node) => node.nodeType == XmlNodeType.ELEMENT)
      .map((e) => AssembleElement(e as XmlElement, element.context))
      .map((e) => AssembleChildElement(e.attrs, e.raw, _assembleByElement(e)))
      .toList(growable: false);

  Widget fromFile(String path) {
    final file = File('colors.xml');
    if (file.existsSync()) {
      _colors.loadResource(file.readAsStringSync());
    }
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
