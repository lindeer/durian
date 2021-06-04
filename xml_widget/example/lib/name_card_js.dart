
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml_widget/js_engine.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_widget.dart';
import 'package:xml_widget/build_item_widget.dart';
import 'package:xml_widget/model_widget.dart';

class NameCardJSPage extends StatefulWidget {
  @override
  _NameCardState createState() => _NameCardState();
}

class _NameCardState extends State<NameCardJSPage> {
  late Future<List<String>> _future;
  final _engine = JSEngine();

  void initState() {
    super.initState();

    _future = Future.wait([
      rootBundle.loadString('assets/app.xml'),
      rootBundle.loadString('assets/app.js'),
    ]);
  }

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
    var at = DateTime.now().microsecondsSinceEpoch;
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Text('error: ${snapshot.error}\n${snapshot.stackTrace}'),
              ),
            );
          } else {
            var t = DateTime.now().microsecondsSinceEpoch;
            print("------- 000 ${t - at}us");
            at = t;
            final data = snapshot.requireData;
            final xml = data[0];
            final js = data[1];
            final assembler = WidgetAssembler(
              buildContext: context,
              onPressed: _onPressed,
            );
            t = DateTime.now().microsecondsSinceEpoch;
            print("------- 111 ${t - at}us");
            at = t;

            final root = assembler.elementFromSource(xml);

            t = DateTime.now().microsecondsSinceEpoch;
            print("------- 222 ${t - at}us");
            at = t;
            return Material(
              child: PageModelWidget(
                model: ScriptModel(js, _engine),
                element: root,
              ),
            );
          }
        } else {
          return _loading;
        }
      },
    );
  }
}

final _loading = Container(
  color: Colors.white,
  constraints: const BoxConstraints.tightFor(
    width: 128,
    height: 128,
  ),
  alignment: Alignment.center,
  child: const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(
      Colors.deepOrangeAccent,
    ),
  ),
);
