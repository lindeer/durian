part of durian.binding;

class LoopWidget extends StatefulWidget {
  final AssembleElement item;
  final List<AssembleChildElement>? headers;
  final List<AssembleChildElement>? footers;
  final String word;

  const LoopWidget(this.item, this.word, {Key? key, this.headers, this.footers}) : super(key: key);

  static Widget makeItemWidget(BuildContext context, AssembleElement item, ItemMetaData data) {
    return BuildItemWidget(
      data: data,
      builder: (ctx) {
        final at = DateTime.now().microsecondsSinceEpoch;
        try {
          final engine = PageModelWidget.of(ctx).engine;
          engine.eval(
            "var item = ${data.name}[${data.pos}];",
            type: StatementType.assign,
          );
          return ctx.assemble.build(ctx, item);
        } finally {
          final cost = DateTime.now().microsecondsSinceEpoch - at;
          print("_buildItem(${data.pos}) cost $cost us");
        }
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _LoopState();
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
    final headers = widget.headers;
    final footers = widget.footers;
    final head = headers?.length ?? 0;

    final model = PageModelWidget.of(context);
    final size = model.sizeOf(widget.word);
    final len = head + size;
    final tail = footers?.length ?? 0;

    print("LoopState(${widget.word}) build from $_from");
    return ListView.builder(
      itemCount: len + tail,
      itemBuilder: (BuildContext ctx, int index) {
        if (index < head) {
          return headers![index].child;
        } else if (index < len) {
          int pos = index - head;
          return LoopWidget.makeItemWidget(ctx, widget.item, ItemMetaData(widget.word, pos));
        } else {
          int pos = index - len;
          return footers![pos].child;
        }
      },
    );
  }

  void _update() {
    setState(() {
      _from++;
    });
  }
}
