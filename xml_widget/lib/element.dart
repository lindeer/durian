
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';

class AssembleElement {
  final XmlElement e;
  final BuildContext buildContext;
  final Map<String, String> attrs;

  AssembleElement(this.e, this.buildContext)
  : attrs = Map.fromEntries(e.attributes.map(
          (attr) => MapEntry(attr.name.local, attr.value)));
}
