library durian;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';
import 'xml_context.dart';
import 'model_widget.dart';
import 'xml_resource.dart';
import 'script_engine.dart';
import 'src/_icons.dart';

part 'src/const.dart';
part 'src/property.dart';
part 'src/assemble_leaf.dart';
part 'src/assemble_group.dart';
part 'src/assemble_container.dart';
part 'src/assemble_res.dart';
part 'src/binding_loop.dart';
part 'src/binding_condition.dart';
part 'src/assemble_list.dart';
part 'src/binding_data.dart';

typedef AssembleWidgetBuilder = Widget Function(AssembleElement element, List<AssembleChildElement> descendant);

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

  final Map<String, XmlWidgetBuilder> _builders;
  final CallbackHolder _holder;
  final _ResImpl _res;

  WidgetAssembler._(this._builders, this._holder, this._res);

  factory WidgetAssembler({
    required BuildContext buildContext,
    void onPressed(String value)?,
    void onLongPressed(String value)?,
    List<XmlWidgetBuilder>? builders,
  }) {
    final xmlBuilders = {
      for (final builder in _builtinBuilders) builder.name: builder
    };
    if (builders != null && builders.isNotEmpty) {
      builders.forEach((b) {
        xmlBuilders[b.name] = b;
      });
    }
    final _info = CallbackHolder();
    _info.onPressed = onPressed;
    _info.onLongPressed = onLongPressed;
    final res = _ResImpl(buildContext);
    return WidgetAssembler._(xmlBuilders, _info, res);
  }

  AssembleContext get assembleContext => AssembleContext(_res, _holder, _assembleByElement);

  _ResImpl get resource => _res;

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
    const _XmlListViewBuilder(),
    const _XmlFlexibleBuilder(),
    const _XmlExpandedBuilder(),
    const _XmlClipOvalBuilder(),
  ];

  Widget _assembleByElement(AssembleElement element) {
    final name = element.name;
    final builder = _builders[name] ?? const _XmlWrapBuilder();

    final rawChildren = element.children;

    int pos;
    if (name == 'ListView' && (pos = _ElementUtils.loopPosition(rawChildren)) != -1) {
      return LoopWidget(element, pos);
    }

    final childrenElements = builder.childless ? _noChild
        : rawChildren.map((e) => AssembleChildElement(e, _assembleByElement(e))).toList(growable: false);

    bool containIf = _ElementUtils.containIf(rawChildren);

    final words = DataBinding.hasMatch(element) ? DataBinding.matchKeys(element) : null;
    final fn = builder.build;
    Widget w;
    if (containIf) {
      w = ConditionWidget(element: element,
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
            return fn.call(element, children);
          },
        );
      } else {
        w = fn.call(element, children);
      }
    }

    return w;
  }

  Widget fromFile(String path) {
    final file = File('colors.xml');
    if (file.existsSync()) {
      _res.loadResource(file.readAsStringSync());
    }
    final f = File(path);
    return fromSource(f.readAsStringSync());
  }

  Widget fromSource(String source) {
    final doc = XmlDocument.parse(source);
    final root = doc.rootElement;
    final element = AssembleElement.fromXml(root, assembleContext);
    return _assembleByElement(element);
  }

  Future<AssembleElement> _elementFromStream(Stream<List<int>> stream) async {
    final stack = <AssembleElement>[];
    final context = assembleContext;
    late AssembleElement root;
    await stream
        .transform(utf8.decoder)
        .toXmlEvents()
        .normalizeEvents()
        .forEachEvent(
      onStartElement: (event) {
        final map = event.attributes.map(
                (attr) => MapEntry(attr.name, attr.value));
        final raw = Map.fromEntries(map.map((entry) => MapEntry(entry.key, entry.value)));
        final element = AssembleElement(event.name, context, raw, []);
        if (stack.isEmpty) {
          root = element;
        } else {
          final parent = stack.last;
          parent.children.add(element);
        }
        if (!event.isSelfClosing) {
          stack.add(element);
        }
      },
      onEndElement: (event) {
        stack.removeLast();
      },
    );
    return root;
  }

  Future<Widget> fromStream(Stream<List<int>> stream) async {
    final element = await _elementFromStream(stream);
    return _assembleByElement(element);
  }
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
