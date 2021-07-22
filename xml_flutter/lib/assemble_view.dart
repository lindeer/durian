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

    return Column(
      mainAxisAlignment: align == 'center'
          ? MainAxisAlignment.center
          : align == 'end' ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: crossAlign == 'center'
          ? CrossAxisAlignment.center
          : crossAlign == 'end' ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: children,
    );
  }
}
