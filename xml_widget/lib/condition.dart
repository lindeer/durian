part of durian;

abstract class _ChildMaker {

  AssembleChildElement make(BuildContext context);

  factory _ChildMaker.single(AssembleChildElement element) => _NormalMaker(element);

  factory _ChildMaker.condition(List<AssembleChildElement> conditions) => _ConditionMaker(conditions);


  static List<_ChildMaker> merge(List<AssembleChildElement> elements) {
    final makers = <_ChildMaker>[];
    final group = <AssembleChildElement>[];
    final parser = _IfParse();
    elements.forEach((e) {
      switch (parser.hitTest(e.raw)) {
        case _IfParseState.none:
          if (group.isNotEmpty) {
            makers.add(_ChildMaker.condition(List.of(group)));
            group.clear();
          }
          makers.add(_ChildMaker.single(e));
          break;
        case _IfParseState.if_:
          if (group.isNotEmpty) {
            makers.add(_ChildMaker.condition(List.of(group)));
            group.clear();
          }
          group.add(e);
          break;
        case _IfParseState.else_:
        case _IfParseState.elseif_:
          group.add(e);
          break;
      }
    });

    if (group.isNotEmpty) {
      makers.add(_ChildMaker.condition(List.of(group)));
      group.clear();
    }
    return makers;
  }
}

class _NormalMaker implements _ChildMaker {
  final AssembleChildElement _child;

  const _NormalMaker(this._child);

  @override
  AssembleChildElement make(BuildContext context) => _child;

}

class _ConditionMaker implements _ChildMaker {
  final List<AssembleChildElement> children;

  _ConditionMaker(this.children);

  @override
  AssembleChildElement make(BuildContext context) {
    final engine = ExeEngineWidget.of(context);
    for (final child in children) {
      final attrs = child.raw;
      final condition = attrs['flutter:if'] ?? attrs['flutter:elseif'] ?? attrs['flutter:else'];
      if (condition == null || condition.isEmpty) {
        return child;
      }
      if (engine.run(condition) == "true") {
        return child;
      }
    }
    return AssembleChildElement.zero;
  }
}

enum _IfParseState {
  none,
  if_,
  elseif_,
  else_,
}
class _IfParse {
  _IfParseState _state = _IfParseState.none;


  _IfParseState hitTest(Map<String, String> attrs) {
    switch (_state) {
      case _IfParseState.none: {
        final ifStat = attrs['flutter:if'];
        if (ifStat?.isNotEmpty ?? false) {
          _state = _IfParseState.if_;
        }
        break;
      }
      case _IfParseState.if_: {
        final ifStat = attrs['flutter:if'];
        final elseifStat = attrs['flutter:elseif'];
        final elseStat = attrs['flutter:else'];
        if (ifStat?.isNotEmpty ?? false) {
        } else if (elseifStat?.isNotEmpty ?? false) {
          _state = _IfParseState.elseif_;
        } else if (elseStat != null) {
          _state = _IfParseState.else_;
        } else {
          _state = _IfParseState.none;
        }
        break;
      }
      case _IfParseState.elseif_: {
        final ifStat = attrs['flutter:if'];
        final elseifStat = attrs['flutter:elseif'];
        final elseStat = attrs['flutter:else'];
        if (ifStat?.isNotEmpty ?? false) {
          _state = _IfParseState.if_;
        } else if (elseifStat?.isNotEmpty ?? false) {
        } else if (elseStat != null) {
          _state = _IfParseState.else_;
        } else {
          _state = _IfParseState.none;
        }
        break;
      }
      case _IfParseState.else_: {
        final ifStat = attrs['flutter:if'];
        final elseifStat = attrs['flutter:elseif'];
        final elseStat = attrs['flutter:else'];
        if (ifStat?.isNotEmpty ?? false) {
          _state = _IfParseState.if_;
        } else if (elseifStat?.isNotEmpty ?? false) {
          _state = _IfParseState.none;
        } else if (elseStat != null) {
          _state = _IfParseState.none;
        } else {
          _state = _IfParseState.none;
        }
        break;
      }
    }
    return _state;
  }
}

class ConditionWidget extends StatefulWidget {
  final AssembleElement element;
  final List<_ChildMaker> makers;
  final AssembleWidgetBuilder builder;

  const ConditionWidget._(this.element, this.makers, this.builder, {Key? key,}) : super(key: key);

  factory ConditionWidget({
    required AssembleElement element,
    required List<AssembleChildElement> children,
    required AssembleWidgetBuilder builder,
  }) {
    final makers = _ChildMaker.merge(children);
    final variables = <String>[];
    final reg = RegExp(r'\w+(.\w+)*');
    for (final child in children) {
      final condition = child.raw['flutter:if'] ?? child.raw['flutter:elseif'];
      if (condition != null && condition.isNotEmpty) {
        final matches = reg.allMatches(condition);
        variables.addAll(matches.map((m) => m[0]).whereType<String>());
      }
    }
    return ConditionWidget._(element, makers, builder,);
  }

  @override
  ConditionState createState() => ConditionState();
}

class ConditionState extends State<ConditionWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final engine = ExeEngineWidget.of(context);
    engine.registerNotifier([], _onNotified);
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
