
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
import 'xml_widget.dart';

abstract class OnPressHandler {
  void onPressed(String uri);

  void onLongPressed(String uri);
}

class AssembleContext {
  final ThemeData theme;
  final ResColor color;
  final OnPressHandler? onPressHandler;

  AssembleContext(BuildContext context, this.color, this.onPressHandler)
      : theme = Theme.of(context);
}

class AssembleElement {
  final XmlElement e;
  final AssembleContext context;
  final Map<String, String> attrs;
  final Map<String, String> raw;

  const AssembleElement._(this.e, this.context, this.attrs, this.raw);

  factory AssembleElement(XmlElement e, AssembleContext context) {
    final map = Map.fromEntries(e.attributes.map(
            (attr) => MapEntry(attr.name, attr.value)));
    final raw = map.map((key, value) => MapEntry(key.qualified, value));
    final attrs = map.map((key, value) => MapEntry(key.local, value));
    return AssembleElement._(e, context, attrs, raw);
  }
}

class AssembleChildElement {
  final Map<String, String> attrs;
  final Map<String, String> raw;
  final Widget child;

  const AssembleChildElement(this.attrs, this.raw, this.child);

  const AssembleChildElement.widget(Widget child) : this(_emptyAttr, _emptyAttr, child);

  static const _emptyAttr = const <String, String>{};
}
