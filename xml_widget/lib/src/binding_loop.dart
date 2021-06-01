part of durian.binding;

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
    final key = item.raw['flutter:for'] ?? '';
    final word = DataBinding.matchKey(key) ?? key;
    return LoopWidget._(element, item, word, headers, footers);
  }

  @override
  _LoopState createState() => _LoopState();
}

class _LoopState extends State<LoopWidget> {
  int _from = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final word = widget.word;
    final model = PageModelWidget.of(context);
    if (word.isNotEmpty) {
      model.addListener([word], _update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headers = widget._headers?.map((e) => e.make(context)).toList(growable: false);
    final footers = widget._footers?.map((e) => e.make(context)).toList(growable: false);
    final head = headers?.length ?? 0;

    final engine = PageModelWidget.of(context).engine;
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
          engine.eval("var item = ${widget.word}[$pos];", type: StatementType.assign,);
          return BuildItemWidget(
            data: ItemMetaData(widget.word, pos),
            builder: (BuildContext ctx) => _buildItem(ctx, pos),
          );
        } else {
          int pos = index - len;
          return footers![pos].child;
        }
      },
    );
  }

  Widget _buildItem(BuildContext buildContext, int index) {
    final at = DateTime.now().microsecondsSinceEpoch;
    final itemContext = widget.item.context;
    final holder = CallbackHolder();
    holder.onPressed = (value) {
      itemContext.onPressed2?.call(buildContext, value);
    };
    final newContext = AssembleContext(itemContext.resource, holder, itemContext.assemble);
    final item = AssembleElement.attachContext(widget.item, newContext);

    try {
      return widget.element.context.assemble.call(item);
    } finally {
      final cost = DateTime.now().microsecondsSinceEpoch - at;
      print("_buildItem($index) cost $cost us");
    }
  }

  void _update() {
    setState(() {
      _from++;
    });
  }
}
