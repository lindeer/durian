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

    final display = style['display'];
    final flex = style['flex-direction'];
    final useRow = display == 'flex' && flex != 'column';

    if (useRow) {
      return Row(
        children: children,
      );
    }

    return Column(
      children: children,
    );
  }
}
