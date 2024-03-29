import 'package:flutter/material.dart';
import 'package:xml_widget/model_widget.dart';

import 'js_engine.dart';

class NameCardJSPage extends StatefulWidget {
  @override
  _NameCardState createState() => _NameCardState();
}

class _NameCardState extends State<NameCardJSPage> {
  final _engine = JSEngine(prefixData: false);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PageModelWidget(
        engine: _engine,
        path: 'assets',
        assets: true,
      ),
    );
  }
}
