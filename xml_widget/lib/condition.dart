part of durian;

class _ChildMaker {
  final AssembleChildElement child;
  final List<AssembleChildElement>? elseifChildren;
  final AssembleChildElement? elseChild;

  _ChildMaker({required this.child, this.elseifChildren, this.elseChild});

  AssembleChildElement make(BuildContext context) {
    final engine = ExeEngineWidget.of(context);
    final conditionIf = child.raw['flutter:if'];
    if (conditionIf == null || engine.run(conditionIf) == "true") {
      return child;
    }
    final middle = elseifChildren ?? const [];
    for (final child in middle) {
      final condition = child.raw['flutter:elseif'];
      if (condition == null || engine.run(condition) == "true") {
        return child;
      }
    }
    if (elseChild != null) {
      return elseChild!;
    }
    return AssembleChildElement.zero;
  }

  static List<_ChildMaker> merge(List<AssembleChildElement> elements) {
    final children = <_ChildMaker>[];
    final length = elements.length;
    int pos = 0;
    while (pos < length) {
      final first = elements[pos++];
      final containIf = first.raw['flutter:if']?.isNotEmpty ?? false;

      int start = 0, end = 0;
      AssembleChildElement? elseChild;
      if (containIf) {
        start = pos;
        while (pos < length && elements[pos].raw.containsKey('flutter:elseif')) {
          pos++;
        }
        end = pos;
        if (pos < length && elements[pos].raw.containsKey('flutter:else')) {
          elseChild = elements[pos++];
        }
      }
      children.add(_ChildMaker(
        child: first,
        elseifChildren: start < end ? elements.sublist(start, end) : null,
        elseChild: elseChild,
      ));
    }
    return children;
  }
}

class ConditionWidget extends StatefulWidget {
  final AssembleElement element;
  final List<_ChildMaker> makers;
  final AssembleWidgetBuilder builder;
  final List<String> variables;

  const ConditionWidget._(this.element, this.makers, this.builder, this.variables, {Key? key,}) : super(key: key);

  factory ConditionWidget({
    required AssembleElement element,
    required List<AssembleChildElement> children,
    required AssembleWidgetBuilder builder,
  }) {
    final makers = _ChildMaker.merge(children);
    final variables = <String>{};
    final reg = RegExp(r'\w+(.\w+)*');
    for (final child in children) {
      final condition = child.raw['flutter:if'] ?? child.raw['flutter:elseif'];
      if (condition != null && condition.isNotEmpty) {
        final matches = reg.allMatches(condition);
        variables.addAll(matches.map((m) => m[0]).whereType<String>());
      }
    }
    return ConditionWidget._(element, makers, builder, List.of(variables, growable: false));
  }

  @override
  ConditionState createState() => ConditionState();
}

class ConditionState extends State<ConditionWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final engine = ExeEngineWidget.of(context);
    engine.registerNotifier(widget.variables, _onNotified);
  }

  @override
  Widget build(BuildContext context) {
    final makers = widget.makers;
    final builder = widget.builder;
    final element = widget.element;
    final children = makers.map((e) => e.make(context)).toList(growable: false);
    return builder.call(element, children);
  }

  void _onNotified() {
    setState(() {});
  }
}
