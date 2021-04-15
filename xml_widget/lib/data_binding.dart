part of durian;

class DataBinding {

  static final _reg = RegExp(r'{{(.+?)}}');
  static final _wordReg = RegExp(r'[a-zA-Z_]\w*(\.\w+)*');

  static bool hasMatch(AssembleElement element) {
    final values = element.raw.values;
    for (final v in values) {
      if (_reg.hasMatch(v)) {
        return true;
      }
    }
    return false;
  }

  static List<String> matchKeys(AssembleElement element) {
    final values = element.raw.values;
    final keys = <String>{};
    for (final value in values) {
      final matches = _reg.allMatches(value);
      final items = matches.map((m) => m[0]).whereType<String>();
      for (final item in items) {
        final words = _wordReg.allMatches(item).map((m) => m[0]).whereType<String>();
        keys.addAll(words);
      }
    }
    return keys.toList(growable: false);
  }

  static void bind(AssembleElement element, String getter(String code)) {
    final attrs = Map.of(element.raw);
    attrs.forEach((key, value) {
      if (value.contains("{{")) {
        final matches = _reg.allMatches(value);
        for (final m in matches) {
          final statement = m[1];
          if (statement != null) {
            final v = getter.call(statement);
            value = value.replaceAll("{{$statement}}", v);
          }
        }
        final k = key.replaceAll('flutter:', '');
        element.attrs[k] = value;
      }
    });
  }
}

class BindingWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final List<String> words;

  const BindingWidget({Key? key,
    required this.builder,
    required this.words,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataBindingState();
}

class _DataBindingState extends State<BindingWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final engine = ExeEngineWidget.of(context);
    engine.registerNotifier(widget.words, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
