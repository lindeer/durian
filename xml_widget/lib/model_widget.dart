import 'package:async/async.dart' show CancelableCompleter;
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_widget.dart';

import 'model.dart';
export 'model.dart';

class PageModelWidget extends StatefulWidget {
  final ScriptEngine engine;
  final String path;

  PageModelWidget({required this.engine, required this.path, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState(AssembleReader(path));

  static PageModel of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_SharedModelWidget>()?.widget as _SharedModelWidget?;
    return widget?.model ?? PageModel.fake();
  }
}

class _ModelState extends State<PageModelWidget> {
  final _dialogs = <String, AssembleElement>{};
  final AssembleReader _reader;
  final _modelCompleter = CancelableCompleter<ScriptModel>();
  final _assembleCompleter = CancelableCompleter<String>();

  _ModelState(this._reader);

  @override
  void initState() {
    super.initState();

    _makeModel(widget.engine);
    _prepareAssemble();
  }

  void _makeModel(ScriptEngine engine) async {
    final requirement = await Future.wait([
      _reader.loadJS(),
      _reader.loadResource(),
    ]);
    final js = requirement[0] as String;
    final model = ScriptModel(js, engine);
    engine.registerBridge('_showAlertDialog', _showAlertDialog);
    engine.registerBridge('_showDialog', _showNormalDialog);
    _modelCompleter.complete(model);
  }

  void _prepareAssemble() async {
    final view = await File('${widget.path}/app.xml').readAsString();
    _assembleCompleter.complete(view);
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
    widget.engine.eval("dismissDialog({action:'$action'});", type: StatementType.expression2);
  }

  Future<String?> _showNormalDialog(Map<String, dynamic> data) => _showAssembleDialog(DialogModel.json(data));

  Future<String?> _showAssembleDialog(DialogModel model) async {
    final element = _dialogs[model["name"]];
    if (element == null) return null;

    final ret = await showDialog<String>(
        context: context,
        builder: (ctx) => _DialogWidget(model: model, element: element,),
    );
    final action = ret ?? 'cancel';
    widget.engine.eval("dismissDialog({action:'$action'});", type: StatementType.expression2);
    return ret;
  }

  void _onPressed(BuildContext ctx, String uri) {
  }

  Widget _makeFutureWidget<T>(Future<T> future, Widget builder(BuildContext ctx, T data)) {
    return FutureBuilder<T>(
      future: future,
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
            final data = snapshot.requireData;
            return builder(ctx, data);
          }
        } else {
          return _loading;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _makeFutureWidget<ScriptModel>(_modelCompleter.operation.value, (_, model) {
      return _SharedModelWidget(
        model: model,
        child: _makeFutureWidget<String>(_assembleCompleter.operation.value, (ctx, data) {
          final assembler = WidgetAssembler(buildContext: ctx);
          final root = assembler.elementFromSource(data);
          final e = _saveDialogElement(root);
          return assembler.build(ctx, e);
        }),
      );
    });
  }

  @override
  void didUpdateWidget(PageModelWidget oldWidget) {
    if (widget.engine != oldWidget.engine) {
      // oldWidget.model.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    if (_modelCompleter.isCompleted) {
      _modelCompleter.operation.value.then((model) {
        model.dispose();
      });
    }
    _modelCompleter.operation.cancel();
    _assembleCompleter.operation.cancel();
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

class _DialogWidget extends StatelessWidget {
  final DialogModel model;
  final AssembleElement element;

  const _DialogWidget({Key? key, required this.model, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SharedModelWidget(
      model: model,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          type: MaterialType.transparency,
          child: Builder(
            builder: (ctx) {
              return _loading;
            },
          ),
        ),
      ),
    );
  }
}

extension BuildContextExt on BuildContext {
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
