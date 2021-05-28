part of durian;

class DataBinding {

  static final _reg = RegExp(r'{{(.+?)}}');

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
      final items = matches.map((m) => m[1]).whereType<String>();
      keys.addAll(items);
    }
    return keys.toList(growable: false);
  }

  static String? matchKey(String? text) => text == null ? null : _reg.firstMatch(text)?[1];

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
