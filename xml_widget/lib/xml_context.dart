
import 'package:flutter/material.dart';

typedef void OnClickListener(BuildContext context, String value);

class InterOperation {
  OnClickListener? onPressed;
  OnClickListener? onLongPressed;
}

typedef AssembleFn = Widget Function(AssembleElement element);
typedef AssembleWidgetBuilder = Widget Function(BuildContext buildContext, AssembleElement element,
    List<AssembleChildElement> descendant);

class AssembleElement {
  final String name;
  final Map<String, String> attrs;
  final Map<String, String> raw;
  final List<AssembleElement> children;

  const AssembleElement(this.name, this.attrs, this.raw, this.children);

  @override
  String toString() => '<$name $raw>';
}

class AssembleChildElement {
  final AssembleElement element;
  final Widget child;

  const AssembleChildElement(this.element, this.child);

  Map<String, String> get raw => element.raw;

  Map<String, String> get attrs => element.attrs;
}
