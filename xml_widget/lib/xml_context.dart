
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
import 'xml_resource.dart';

typedef void OnClickListener(BuildContext context, String value);

class CallbackHolder {
  OnClickListener? onPressed;
  OnClickListener? onLongPressed;
}

class InterOperation {
  OnClickListener? onPressed;
  OnClickListener? onLongPressed;
}

typedef AssembleFn = Widget Function(AssembleElement element);
typedef AssembleHatch = Widget Function(BuildContext context, AssembleElement element);
typedef AssembleWidgetBuilder = Widget Function(BuildContext buildContext, AssembleElement element,
    List<AssembleChildElement> descendant);

class AssembleContext {
  final AssembleResource resource;
  final CallbackHolder _info;
  final AssembleFn assemble;
  final AssembleHatch hatch;

  const AssembleContext(this.resource, this._info, this.assemble, this.hatch);

  OnClickListener? get onPressed => _info.onPressed;

  OnClickListener? get onLongPressed => _info.onLongPressed;
}

class AssembleElement {
  final String name;
  final AssembleContext context;
  final Map<String, String> attrs;
  final Map<String, String> raw;
  final List<AssembleElement> children;

  const AssembleElement._(this.name, this.context, this.attrs, this.raw, this.children);

  factory AssembleElement(String name, AssembleContext context, Map<String, String> raw,
      List<AssembleElement> children) {
    final attrs = raw.map((key, value) => MapEntry(key.replaceAll('flutter:', ''), value));
    return AssembleElement._(name, context, attrs, raw, children);
  }


  @override
  String toString() => '<$name $raw>';

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
