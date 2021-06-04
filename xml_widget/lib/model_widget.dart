import 'package:flutter/material.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_widget.dart';

import 'model.dart';
export 'model.dart';

class PageModelWidget extends StatefulWidget {
  final PageModel model;
  final AssembleElement element;

  PageModelWidget({required this.model, required this.element, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState();

  static PageModel of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_SharedModelWidget>()?.widget as _SharedModelWidget?;
    return widget?.model ?? PageModel.fake();
  }
}

class _ModelState extends State<PageModelWidget> {
  late AssembleElement root;
  final _dialogs = <String, AssembleElement>{};

  @override
  void initState() {
    super.initState();

    widget.model.engine.registerBridge('_showAlertDialog', _showAlertDialog);
    widget.model.engine.registerBridge('_showDialog', _showNormalDialog);
    root = _saveDialogElement(widget.element);
  }

  AssembleElement _saveDialogElement(AssembleElement element) {
    final children = List.of(element.children);
    children.removeWhere((e) {
      final yes = e.name == 'Dialog';
      final name = e.raw['flutter:name'];
      if (yes && name != null) {
        _dialogs[name] = e.children.first;
      }
      return yes;
    });
    return AssembleElement(element.name, element.context, element.raw, children);
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
    final action = ret ?? 'cancel';
    widget.model.engine.eval("dismissDialog({action:'$action'});", type: StatementType.expression2);
  }

  Future<String?> _showNormalDialog(Map<String, dynamic> data) => _showAssembleDialog(DialogModel.json(data));

  Future<String?> _showAssembleDialog(DialogModel model) async {
    final element = _dialogs[model["name"]];
    if (element == null) return null;

    final ret = await showDialog<String>(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              type: MaterialType.transparency,
              child: PageModelWidget(
                model: model,
                element: element,
              ),
            ),
          );
        }
    );
    final action = ret ?? 'cancel';
    widget.model.engine.eval("dismissDialog({action:'$action'});", type: StatementType.expression2);
    return ret;
  }

  void _onPressed(BuildContext ctx, String uri) {
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final assembler = WidgetAssembler(
      buildContext: context,
      onPressed: _onPressed,
    );
    return _SharedModelWidget(
      model: model,
      child: Builder(
        builder: (ctx) => assembler.build(ctx, root),
      ),
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
