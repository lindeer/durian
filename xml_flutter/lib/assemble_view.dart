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
  XmlElement assemble(_AssembleElement e, Iterable<XmlElement> children) {
    final style = e.style;
    if (style.isEmpty) {
      final attrs = {
        'crossAxisAlignment': 'stretch',
      };
      return AssembleBuilder.element('Column', attrs, children);
    }
    final align = style['text-align'];
    final crossAlign = style['align-items'] ?? align;
    final display = style['display'];
    final flex = style['flex-direction'];
    final useRow = display == 'flex' && flex != 'column';

    if (useRow) {
      final attrs = {
        'mainAxisAlignment': 'center',
      };
      return AssembleBuilder.element('Row', attrs, children);
    }

    final inlineChildren = e.children.where((e) => e.style['display']?.startsWith('inline') ?? false);
    if (inlineChildren.length > 0) {
      return AssembleBuilder.element('Wrap', {}, children);
    }

    final alignChildren = e.children.where((e) => e.style['position'] == 'absolute');
    if (alignChildren.length > 0) {
      return AssembleBuilder.element('Stack', {}, children);
    }

    final attrs = {
      'mainAxisAlignment': align ?? 'start',
      'crossAxisAlignment': crossAlign ?? 'start',
    };
    return AssembleBuilder.element('Column', attrs, children);
  }
}
