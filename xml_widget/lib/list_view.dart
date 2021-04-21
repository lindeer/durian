part of durian;

class _XmlListViewBuilder extends CommonWidgetBuilder {
  const _XmlListViewBuilder() : super('ListView');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    final res = element.context.resource;
    return ListView(
      children: children,
      scrollDirection: _axis[attrs['scrollDirection']] ?? Axis.vertical,
      reverse: attrs['reverse'] == "true",
      primary: attrs['primary']?.let((it) => it == "false"),
      shrinkWrap: attrs['shrinkWrap'] == "true",
      padding: _PropertyStruct.padding(res, attrs),
      itemExtent: attrs['itemExtent']?.toDouble(),
      addAutomaticKeepAlives: attrs['addAutomaticKeepAlives'] == "false",
      addRepaintBoundaries: attrs['addRepaintBoundaries'] == "false",
      addSemanticIndexes: attrs['addSemanticIndexes'] == "false",
      cacheExtent: attrs['cacheExtent']?.toDouble(),
      semanticChildCount: attrs['semanticChildCount']?.toInt(),
      dragStartBehavior: _drawerDragStartBehavior[attrs['dragStartBehavior']] ?? DragStartBehavior.start,
      keyboardDismissBehavior: _scrollViewKeyboardDismissBehavior[attrs['keyboardDismissBehavior']]
          ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: attrs['restorationId'],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.hardEdge,
    );
  }
}

class LoopWidget extends StatefulWidget {
  final AssembleElement element;
  final AssembleElement item;
  final List<_ChildMaker>? _headers;
  final List<_ChildMaker>? _footers;
  final String word;

  const LoopWidget._(this.element, this.item, this.word, this._headers, this._footers) : super();

  factory LoopWidget(AssembleElement element, int pos) {
    final children = element.children;
    final item = children[pos];
    final assembleFn = element.context.assemble;
    final headers = pos > 0 ? _ChildMaker.merge(children.sublist(0, pos)
        .map((e) => AssembleChildElement(element, assembleFn.call(e)))
        .toList(growable: false))
        : null;
    final footers = pos < children.length - 1 ? _ChildMaker.merge(children.sublist(pos + 1)
        .map((e) => AssembleChildElement(element, assembleFn.call(e)))
        .toList(growable: false))
        : null;
    final word = DataBinding.matchKey(item.raw['flutter:for']) ?? '';
    return LoopWidget._(element, item, word, headers, footers);
  }

  @override
  _LoopState createState() => _LoopState();
}

class _LoopState extends State<LoopWidget> {

  String _from = 'create';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final word = widget.word;
    final engine = ExeEngineWidget.of(context);
    if (word.isNotEmpty) {
      engine.registerNotifier([word], () { _onNotify('loop'); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final headers = widget._headers?.map((e) => e.make(context)).toList(growable: false);
    final footers = widget._footers?.map((e) => e.make(context)).toList(growable: false);
    final head = headers?.length ?? 0;

    final engine = ExeEngineWidget.of(context);
    final size = int.tryParse(engine.eval('${widget.word}.length')) ?? 0;

    final len = head + size;
    final tail = footers?.length ?? 0;

    print("LoopState build from $_from");
    return ListView.builder(
      itemCount: len + tail,
      itemBuilder: (BuildContext ctx, int index) {
        if (index < head) {
          return headers![index].child;
        } else if (index < len) {
          int pos = index - head;
          engine.eval("var item = ${widget.word}[$pos];");
          return _buildItem(engine, pos);
        } else {
          int pos = index - len;
          return footers![pos].child;
        }
      },
    );
  }

  Widget _buildItem(ScriptEngine engine, int index) {
    final item = widget.item;
    final at = DateTime.now().millisecondsSinceEpoch;
    try {
      return widget.element.context.assemble.call(item);
    } finally {
      final cost = DateTime.now().millisecondsSinceEpoch - at;
      print("_buildItem($index) cost $cost ms");
    }
  }

  void _onNotify(String from) {
    setState(() {
      _from = from;
    });
  }
}
