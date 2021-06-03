import 'package:flutter/material.dart';
import 'package:xml_widget/script_engine.dart';

import 'model.dart';
export 'model.dart';

class PageModelWidget extends StatefulWidget {
  final PageModel model;
  final Widget child;

  PageModelWidget({required this.model, required this.child, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState();

  static PageModel of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_SharedModelWidget>()?.widget as _SharedModelWidget?;
    return widget?.model ?? PageModel.fake();
  }
}

class _ModelState extends State<PageModelWidget> {

  @override
  void initState() {
    super.initState();

    widget.model.engine.registerBridge('_showAlertDialog', _showAlertDialog);
  }

  void _showAlertDialog(Map<String, dynamic> data) async {
    print("_showDialog: data=$data");
    final items = data['items'] as List;
    final ret = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['title']),
          content: SingleChildScrollView(
            child: ListBody(
              children: items.map((e) => Text(e.toString())).toList(growable: false),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(data['confirmText']),
              onPressed: () {
                Navigator.of(context).pop('success');
              },
            ),
          ],
        );
      },
    );
    print("_showDialog: ret=$ret");
    final action = ret ?? 'cancel';
    widget.model.engine.eval("dismissDialog({action:'$action'});", type: StatementType.expression2);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return _SharedModelWidget(
      model: model,
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(PageModelWidget oldWidget) {
    if (widget.model.engine != oldWidget.model.engine) {
      oldWidget.model.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    widget.model.dispose();
  }
}

class _SharedModelWidget extends InheritedWidget {
  final PageModel model;

  _SharedModelWidget({required this.model, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_SharedModelWidget oldWidget) {
    return oldWidget.model != model;
  }
}
