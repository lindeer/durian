part of durian;

class ViewAssembleBuilder implements AssembleBuilder {
  const ViewAssembleBuilder();

  @override
  Widget build(_AssembleElement e, List<Widget> children) {
    final style = e.style;
    if (style.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    final align = style['text-align'];
    final crossAlign = style['align-items'] ?? align;
    final display = style['display'];
    final flex = style['flex-direction'];
    final useRow = display == 'flex' && flex != 'column';

    if (useRow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
    final inlineChildren = e.children.where((e) => e.style['display']?.startsWith('inline') ?? false);
    if (inlineChildren.length > 0) {
      return Wrap(
        children: children,
      );
    }
    final alignChildren = e.children.where((e) => e.style['position'] == 'absolute');
    if (alignChildren.length > 0) {
      return Stack(
        children: children,
      );
    }

    final main = align == 'center'
        ? MainAxisAlignment.center
        : align == 'end' ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final cross = crossAlign == 'center'
        ? CrossAxisAlignment.center
        : crossAlign == 'end' ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Column(
      mainAxisAlignment: main,
      crossAxisAlignment: cross,
      children: children,
    );
  }

  @override
  String generate(_AssembleElement e, List<String> children) {
    final style = e.style;
    if (style.isEmpty) {
      return """
<Column
  flutter:crossAxisAlignment="stretch">
${children.join('\n')}
</Column>
""";
    }
    final align = style['text-align'];
    final crossAlign = style['align-items'] ?? align;
    final display = style['display'];
    final flex = style['flex-direction'];
    final useRow = display == 'flex' && flex != 'column';

    if (useRow) {
      return """
<Row
  flutter:mainAxisAlignment="center">
${children.join('\n')}
</Row>
""";
    }

    final inlineChildren = e.children.where((e) => e.style['display']?.startsWith('inline') ?? false);
    if (inlineChildren.length > 0) {
      return """
<Wrap>
${children.join('\n')}
</Wrap>
""";
    }

    final alignChildren = e.children.where((e) => e.style['position'] == 'absolute');
    if (alignChildren.length > 0) {
      return """
<Stack>
${children.join('\n')}
</Stack>
""";
    }

    final main = align == 'center'
        ? MainAxisAlignment.center
        : align == 'end' ? MainAxisAlignment.end
        : MainAxisAlignment.start;
    final cross = crossAlign == 'center'
        ? CrossAxisAlignment.center
        : crossAlign == 'end' ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return """
<Column
  flutter:mainAxisAlignment="${_mainAxisAlignment[main]}"
  flutter:crossAxisAlignment="${_crossAxisAlignment[cross]}">
${children.join('\n')}
</Column>
""";
  }
}
