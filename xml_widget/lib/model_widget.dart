import 'package:flutter/material.dart';

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
