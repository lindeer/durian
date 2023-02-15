
import 'dart:io';

import 'package:xml_flutter/xml_flutter.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    _printUsage();
    return;
  }
  final infile = args[0];
  final outfile = args.length == 1 ? null : args[1];

  final input = File(infile).readAsStringSync();
  final root = AssembleReader.fromSource(input);
  final tank = AssembleTank();
  final output = tank.assemble(root).toXmlString(pretty: true, indent: '  ');
  if (outfile != null) {
    File(outfile).writeAsStringSync(output);
  } else {
    stdout.writeln(output);
  }
}

void _printUsage() {
  print('''Usage: xml_flutter.dart input [output]

Parse [input] file of wxml to output of xml with flutter widgets defined.
If [file] is omitted, use stdout as output.
''');
}
