part of durian.binding;

class BindingWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final List<String> words;

  const BindingWidget({
    Key? key,
    required this.builder,
    required this.words,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataBindingState();
}

class _DataBindingState extends State<BindingWidget> {
  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final model = PageModelWidget.of(context);
    model.addListener(widget.words, _update);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
