library durian;

import 'dart:io';

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';
import 'build_item_widget.dart' show ItemMetaData;
import 'model_widget.dart';
import 'src/_icons.dart';
import 'xml_context.dart';
import 'xml_resource.dart';
import 'src/binding.dart';

part 'assemble_reader.dart';
part 'src/assemble_container.dart';
part 'src/assemble_leaf.dart';
part 'src/assemble_list.dart';
part 'src/assemble_group.dart';
part 'src/assemble_res.dart';
part 'src/const.dart';
part 'src/property.dart';

abstract class XmlWidgetBuilder {
  String get name;

  bool get childless;

  /// build a widget given parent and children
  Widget build(BuildContext buildContext, AssembleElement element, List<AssembleChildElement> descendant);
}

abstract class CommonWidgetBuilder implements XmlWidgetBuilder {
  final String _name;

  const CommonWidgetBuilder(this._name);

  String get name => _name;

  bool get childless => false;
}

const _builtinBuilders = _Assembler._builtinBuilders;

abstract class WidgetAssembler {
  Widget build(BuildContext buildContext, AssembleElement element);

  factory WidgetAssembler({
    List<XmlWidgetBuilder>? builders,
  }) {
    final xmlBuilders = {for (final builder in _builtinBuilders) builder.name: builder};
    if (builders != null && builders.isNotEmpty) {
      builders.forEach((b) {
        xmlBuilders[b.name] = b;
      });
    }
    return _Assembler._(xmlBuilders);
  }
}

class _Assembler implements WidgetAssembler {
  final Map<String, XmlWidgetBuilder> _builders;

  const _Assembler._(this._builders);

  static const _noChild = const <AssembleChildElement>[];
  static const _supportFor = const [
    'Column',
    'Row',
    'Wrap',
    'ListView',
    'ListBody',
  ];
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
    const _XmlListViewBuilder(),
    const _XmlFlexibleBuilder(),
    const _XmlExpandedBuilder(),
    const _XmlClipOvalBuilder(),
    const _XmlClipRRectBuilder(),
  ];

  Widget _assembleByElement(BuildContext buildContext, AssembleElement element) {
    final name = element.name;
    final builder = _builders[name] ?? const _XmlWrapBuilder();

    final rawChildren = element.children;
    List<AssembleChildElement> childrenElements;

    int pos;
    if (_supportFor.contains(name) && (pos = _ElementUtils.loopPosition(rawChildren)) != -1) {
      final model = PageModelWidget.of(buildContext);
      final assemble = model.assemble;
      final children = element.children;
      final headers = pos > 0
          ? children
              .sublist(0, pos)
              .map((e) => AssembleChildElement(e, assemble.build(buildContext, e)))
              .toList(growable: false)
          : null;
      final footers = pos < children.length - 1
          ? children
              .sublist(pos + 1)
              .map((e) => AssembleChildElement(e, assemble.build(buildContext, e)))
              .toList(growable: false)
          : null;
      final item = children[pos];
      final key = DataBinding.matchKey(item.raw['flutter:for']) ?? '';
      if (name == 'ListView') {
        return LoopWidget(
          item,
          key,
          headers: headers,
          footers: footers,
        );
      }

      final size = model.sizeOf(key);
      childrenElements = [
        ...?headers,
        for (int i = 0; i < size; i++)
          AssembleChildElement(item, LoopWidget.makeItemWidget(buildContext, item, ItemMetaData(key, i))),
        ...?footers,
      ];
    } else {
      childrenElements = builder.childless
          ? _noChild
          : rawChildren
              .map((e) => AssembleChildElement(e, _assembleByElement(buildContext, e)))
              .toList(growable: false);
    }

    bool containIf = _ElementUtils.containIf(rawChildren);

    final words = DataBinding.hasMatch(element) ? DataBinding.matchKeys(element) : null;
    final fn = builder.build;
    Widget w;
    if (containIf) {
      w = ConditionWidget(
        element: element,
        children: childrenElements,
        builder: fn,
        bindingWords: words,
      );
    } else {
      final children = childrenElements;
      if (words != null && words.isNotEmpty) {
        w = BindingWidget(
          words: words,
          builder: (ctx) {
            final engine = PageModelWidget.of(ctx).engine;
            DataBinding.bind(element, engine.eval);
            return fn.call(ctx, element, children);
          },
        );
      } else {
        w = fn.call(buildContext, element, children);
      }
    }

    return w;
  }

  Widget build(BuildContext context, AssembleElement element) => _assembleByElement(context, element);
}

class _ElementUtils {
  static bool containIf(List<AssembleElement> elements) {
    for (final e in elements) {
      final ifStat = e.raw['flutter:if'];
      if (ifStat?.isNotEmpty ?? false) {
        return true;
      }
    }
    return false;
  }

  static bool hasLoop(Map<String, String> attr) => attr['flutter:for']?.isNotEmpty ?? false;

  static int loopPosition(List<AssembleElement> elements) {
    int pos = 0;
    for (final e in elements) {
      if (hasLoop(e.raw)) {
        return pos;
      }
      pos++;
    }
    return -1;
  }
}
