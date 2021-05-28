part of durian;

class _XmlListViewBuilder extends CommonWidgetBuilder {
  const _XmlListViewBuilder() : super('ListView');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    final res = element.context.resource;
    return ListView(
      children: children,
      scrollDirection: _axis[attrs['scrollDirection']] ?? Axis.vertical,
      reverse: attrs['reverse'] == "true",
      primary: attrs['primary']?.let((it) => it == "false"),
      shrinkWrap: attrs['shrinkWrap'] == "true",
      padding: _PropertyStruct.padding(res, attrs),
      itemExtent: attrs['itemExtent']?.toDouble(),
      addAutomaticKeepAlives: attrs['addAutomaticKeepAlives'] == "false",
      addRepaintBoundaries: attrs['addRepaintBoundaries'] == "false",
      addSemanticIndexes: attrs['addSemanticIndexes'] == "false",
      cacheExtent: attrs['cacheExtent']?.toDouble(),
      semanticChildCount: attrs['semanticChildCount']?.toInt(),
      dragStartBehavior: _drawerDragStartBehavior[attrs['dragStartBehavior']] ?? DragStartBehavior.start,
      keyboardDismissBehavior: _scrollViewKeyboardDismissBehavior[attrs['keyboardDismissBehavior']]
          ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: attrs['restorationId'],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.hardEdge,
    );
  }
}
