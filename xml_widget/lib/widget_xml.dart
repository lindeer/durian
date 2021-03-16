import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

class WidgetXml {
  const WidgetXml();
}

const widgetXml = WidgetXml();

class XmlWidgetCollection extends GeneratorForAnnotation<WidgetXml> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    return '''
      // ${visitor.className}
      // ${visitor.fields}
      // ${visitor.metaData}
    ''';
  }
}

class ModelVisitor extends SimpleElementVisitor {
  late DartType className;
  Map<String, DartType> fields = {};
  Map<String, dynamic> metaData = {};

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
  }

  @override
  visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
    metaData[element.name] = element.metadata;
  }
}
