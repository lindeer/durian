
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
import 'xml_widget.dart';

abstract class OnPressHandler {
  void onPressed(String uri);

  void onLongPressed(String uri);
}

typedef AssembleFn = Widget Function(AssembleElement element);

class AssembleContext {
  final ThemeData theme;
  final ResColor color;
  final OnPressHandler? onPressHandler;
  final AssembleFn assemble;

  AssembleContext(BuildContext context, this.color, this.onPressHandler, this.assemble)
      : theme = Theme.of(context);
}

class AssembleElement {
  final String name;
  final AssembleContext context;
  final Map<String, String> attrs;
  final Map<String, String> raw;
  final List<AssembleElement> children;

  const AssembleElement._(this.name, this.context, this.attrs, this.raw, this.children);

  static AssembleElement fromXml(XmlElement e, AssembleContext context) {
    final children = e.children.where((child) => child.nodeType == XmlNodeType.ELEMENT)
        .map((child) => fromXml(child as XmlElement, context)).toList(growable: false);
    final map = e.attributes.map(
            (attr) => MapEntry(attr.name, attr.value));
    final raw = Map.fromEntries(map.map((entry) => MapEntry(entry.key.qualified, entry.value)));
    final attrs = Map.fromEntries(map.map((entry) => MapEntry(entry.key.local, entry.value)));
    final name = e.name.qualified;
    return AssembleElement._(name, context, attrs, raw, children);
  }
}

class AssembleChildElement {
  final AssembleElement element;
  final Widget child;

  const AssembleChildElement(this.element, this.child);

  Map<String, String> get raw => element.raw;

  Map<String, String> get attrs => element.attrs;
}
