
import 'package:flutter/material.dart';
import 'package:xml_widget/js_engine.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/build_item_widget.dart';
import 'package:xml_widget/model_widget.dart';

class NameCardJSPage extends StatefulWidget {
  @override
  _NameCardState createState() => _NameCardState();
}

class _NameCardState extends State<NameCardJSPage> {
  final _engine = JSEngine();

  void _onPressed(BuildContext ctx, String uri) {
    final item = BuildItemWidget.of(ctx);
    final model = PageModelWidget.of(ctx);
    if (uri.contains('item.') && item != null) {
      final expr = uri.replaceAll('item', '$item');
      _engine.eval('$expr();');
    } else if (model is DialogModel) {
      Navigator.of(context).pop(uri);
    } else {
      _engine.eval(uri, type: StatementType.call);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PageModelWidget(
        engine: _engine,
        path: 'assets',
      ),
    );
  }
}
