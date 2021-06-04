import 'package:flutter/material.dart';
import 'package:xml_widget/script_engine.dart';
import 'package:xml_widget/xml_context.dart';
import 'package:xml_widget/xml_widget.dart';
import 'package:xml_widget/xml_resource.dart';

import 'model.dart';
export 'model.dart';

class PageModelWidget extends StatefulWidget {
  final PageModel model;
  final AssembleElement element;
  final String path = 'assets';

  PageModelWidget({required this.model, required this.element, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelState(AssembleReader(path));

  static PageModel of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_SharedModelWidget>()?.widget as _SharedModelWidget?;
    return widget?.model ?? PageModel.fake();
  }
}

class _ModelState extends State<PageModelWidget> {
  late AssembleElement root;
  final _dialogs = <String, AssembleElement>{};
  final AssembleReader _reader;

  _ModelState(this._reader);

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
    final model = widget.model;
    return _SharedModelWidget(
      model: model,
      child: _makeFutureWidget<AssembleResource>(_reader.loadResource(), (c, res) {
        final callbacks = CallbackHolder();
        final assembleContext = AssembleContext(res, callbacks, (e)=>_loading, (ctx, e)=>_loading);
        return _AssembleContextWidget(assembleContext, _makeFutureWidget<AssembleElement>(_reader.parseElement(), (ctx, element) {
          final ac = ctx.assembleContext;
          /*
          ac.attach((e) => assembler.build(ctx, e), assembler.build);
           */
          return Center(
            child: Container(
              width: 120,
              height: 120,
              color: Colors.blueAccent,
            ),
          );
        }));
      }),
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

class _AssembleContextWidget extends InheritedWidget {
  final AssembleContext _context;

  _AssembleContextWidget(this._context, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant _AssembleContextWidget oldWidget) {
    return oldWidget._context != _context;
  }

  static Widget _build(AssembleElement e) {
    return SizedBox.shrink();
  }

  static Widget _build2(BuildContext ctx, AssembleElement e) => _build(e);

  static AssembleContext _createFake() {
    return AssembleContext(AssembleResource.fake(), CallbackHolder(), _build, _build2);
  }
}

extension BuildContextExt on BuildContext {
  AssembleContext get assembleContext {
    final w = getElementForInheritedWidgetOfExactType<_AssembleContextWidget>()?.widget as _AssembleContextWidget?;
    return w?._context ?? _AssembleContextWidget._createFake();
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
