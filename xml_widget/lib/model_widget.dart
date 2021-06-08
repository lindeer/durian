import 'package:async/async.dart' show CancelableCompleter;
import 'package:flutter/material.dart';
import 'package:xml_widget/build_item_widget.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_resource.dart';
import 'package:xml_widget/xml_widget.dart';

import 'model.dart';
export 'model.dart';

class PageModelWidget extends StatefulWidget {
  final ScriptEngine engine;
  final String path;
  final bool? assets;
  final AssembleResource? resource;
  final InterOperation? operation;
  final WidgetAssembler? assembler;

  PageModelWidget({
    required this.engine,
    required this.path,
    this.assets,
    this.resource,
    this.operation,
    this.assembler,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState(AssembleReader(path: path, assets: assets));

  static PageModel of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_SharedModelWidget>()?.widget as _SharedModelWidget?;
    return widget?.model ?? PageModel.fake();
  }
}

class _ModelState extends State<PageModelWidget> {
  final _dialogs = <String, AssembleElement>{};
  final AssembleReader _reader;
  final _modelCompleter = CancelableCompleter<ScriptModel>();
  final _assembleCompleter = CancelableCompleter<AssembleElement>();

  _ModelState(this._reader);

  @override
  void initState() {
    super.initState();

    _makeModel();
    _prepareAssemble();
  }

  void _onPageCreated(Map<String, dynamic> result) {
  }

  void _onPageBuilt() {
  }

  Future<ScriptEngine> _prepareEngine() async {
    final t1 = DateTime.now().microsecondsSinceEpoch;
    final js = await _reader.loadJS();
    final t2 = DateTime.now().microsecondsSinceEpoch;
    final engine = widget.engine;
    engine.registerBridge('_onPageCreated', _onPageCreated);
    engine.eval(js, type: StatementType.declaration);
    engine.eval("""
function notifyChange(data) {
  sendMessage('_onDataChanged', JSON.stringify(data));
}
    """,
      type: StatementType.declaration,
    );
    final t3 = DateTime.now().microsecondsSinceEpoch;
    print("_prepareEngine: js=${t2 - t1} us, eval=${t3 - t2} us");
    return engine;
  }

  void _makeModel() async {
    final requirement = await Future.wait([
      _prepareEngine(),
      _reader.loadResource(),
    ]);
    final engine = requirement[0] as ScriptEngine;
    final res = requirement[1] as AssembleResource;
    final op = InterOperation()
      ..onPressed = _onPressed;
    final assembler = widget.assembler ?? WidgetAssembler();

    final model = ScriptModel(engine, res, op, assembler);
    engine.registerBridge('_onDataChanged', (data) => model.notifyDataChanged(data));
    engine.registerBridge('_showAlertDialog', _showAlertDialog);
    engine.registerBridge('_showDialog', (data) => _showAssembleDialog(DialogModel(data, model)));
    _modelCompleter.complete(model);
  }

  void _prepareAssemble() async {
    final element = await _reader.loadElement();
    final view = _saveDialogElement(element);
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
    return AssembleElement(element.name, element.attrs, element.raw, children);
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
    final item = BuildItemWidget.of(ctx);
    final model = PageModelWidget.of(ctx);
    final _engine = widget.engine;
    if (uri.contains('item.') && item != null) {
      final expr = uri.replaceAll('item', '$item');
      _engine.eval('$expr();');
    } else if (model is DialogModel) {
      Navigator.of(context).pop(uri);
    } else {
      _engine.eval(uri, type: StatementType.call);
    }
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
        child: _makeFutureWidget<AssembleElement>(_assembleCompleter.operation.value, (ctx, e) {
          final assembler = ctx.assemble;
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

class _AssemblePage extends StatelessWidget {
  final PageModel model;
  final AssembleElement element;

  const _AssemblePage(this.model, this.element, {Key? key}) : super(key: key);

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
              final assemble = ctx.assemble;
              return assemble.build(ctx, element);
            },
          ),
        ),
      ),
    );
  }
}

class _DialogWidget extends _AssemblePage {
  const _DialogWidget({required DialogModel model, required AssembleElement element}) : super(model, element);
}

@visibleForTesting
class TestModelWidget extends _AssemblePage {
  const TestModelWidget(PageModel model, AssembleElement element) : super(model, element);
}

extension BuildContextExt on BuildContext {
  WidgetAssembler get assemble {
    final model = PageModelWidget.of(this);
    return model.assemble;
  }

  AssembleResource get resource {
    final model = PageModelWidget.of(this);
    return model.resource;
  }

  InterOperation get interaction {
    final model = PageModelWidget.of(this);
    return model.interaction;
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
