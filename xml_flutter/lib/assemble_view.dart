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
    final display = style['display'];
    final flex = style['flex-direction'];
    final useRow = display == 'flex' && flex != 'column';

    if (useRow) {
      return Row(
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: align == 'center'
          ? CrossAxisAlignment.center
          : align == 'right' ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: children,
    );
  }
}
