
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

  AssembleElement(this.e, this.context)
  : attrs = Map.fromEntries(e.attributes.map(
          (attr) => MapEntry(attr.name.local, attr.value)));
}

class AssembleChildElement {
  final Map<String, String> attrs;
  final Widget child;

  AssembleChildElement(this.attrs, this.child);
}
