part of durian;

abstract class _ChildMaker {

  AssembleChildElement get child;

  factory _ChildMaker.single(AssembleChildElement element) => _NormalMaker(element);

  factory _ChildMaker.condition(List<AssembleChildElement> conditions) => _ConditionMaker(conditions);


  static List<AssembleChildElement> merge(List<AssembleChildElement> elements) {
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
    return makers.map((m) => m.child).toList(growable: false);
  }
}

class _NormalMaker implements _ChildMaker {
  final AssembleChildElement _child;

  const _NormalMaker(this._child);

  @override
  AssembleChildElement get child => _child;

}

class _ConditionMaker implements _ChildMaker {
  final List<AssembleChildElement> children;

  _ConditionMaker(this.children);

  @override
  AssembleChildElement get child => AssembleChildElement.widget(ConditionWidget(children: children,));
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

class ConditionWidget extends StatelessWidget {
  final List<AssembleChildElement> children;

  const ConditionWidget({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (final child in children) {
      final condition = child.attrs['flutter:if'] ?? child.attrs['flutter:elseif'] ?? child.attrs['flutter:else'];
      if (condition == "true") {
        return child.child;
      }
    }
    return SizedBox.shrink();
  }
}
