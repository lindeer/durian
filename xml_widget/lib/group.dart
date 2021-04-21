part of durian;

class _XmlColumnBuilder extends CommonWidgetBuilder {
  const _XmlColumnBuilder() : super('Column');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    return Column(
      children: children,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
      mainAxisSize: _mainAxisSize[attrs['mainAxisSize']] ?? MainAxisSize.max,
      crossAxisAlignment: _crossAxisAlignment[attrs['crossAxisAlignment']] ?? CrossAxisAlignment.center,
      textDirection: _textDirection[attrs['textDirection']],
      verticalDirection: _verticalDirection[attrs['textDirection']] ?? VerticalDirection.down,
      textBaseline: _textBaseline[attrs['textBaseline']],
    );
  }
}

class _XmlRowBuilder extends CommonWidgetBuilder {
  const _XmlRowBuilder() : super('Row');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    return Row(
      children: children,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
      mainAxisSize: _mainAxisSize[attrs['mainAxisSize']] ?? MainAxisSize.max,
      crossAxisAlignment: _crossAxisAlignment[attrs['crossAxisAlignment']] ?? CrossAxisAlignment.center,
      textDirection: _textDirection[attrs['textDirection']],
      verticalDirection: _verticalDirection[attrs['textDirection']] ?? VerticalDirection.down,
      textBaseline: _textBaseline[attrs['textBaseline']],
    );
  }
}

class _XmlWrapBuilder extends CommonWidgetBuilder {
  const _XmlWrapBuilder() : super('Wrap');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    return Wrap(
      children: children,
      direction: attrs['direction']?.toAxis() ?? Axis.horizontal,
      alignment: attrs['alignment']?.toWrapAlignment() ?? WrapAlignment.start,
      spacing: attrs['spacing']?.toDouble() ?? 0.0,
      runAlignment: attrs['runAlignment']?.toWrapAlignment() ?? WrapAlignment.start,
      runSpacing: attrs['runSpacing']?.toDouble() ?? 0.0,
      crossAxisAlignment: attrs['crossAxisAlignment']?.toWrapCrossAlignment() ?? WrapCrossAlignment.start,
      textDirection: attrs['textDirection']?.toTextDirection(),
      verticalDirection: attrs['verticalDirection']?.toVerticalDirection() ?? VerticalDirection.down,
      clipBehavior: attrs['clipBehavior']?.toClip() ?? Clip.none,
    );
  }
}

class _XmlStackBuilder extends CommonWidgetBuilder {
  const _XmlStackBuilder() : super('Stack');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    return Stack(
      children: children,
      alignment: _alignmentDirectional[attrs['alignment']] ?? AlignmentDirectional.topStart,
      textDirection: _textDirection[attrs['textDirection']],
      fit: _stackFit[attrs['fit']] ?? StackFit.loose,
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.hardEdge,
    );
  }
}


class _XmlFlexBuilder extends CommonWidgetBuilder {
  const _XmlFlexBuilder() : super('Flex');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final children = descendant.map((e) => e.child).toList(growable: false);
    final attrs = element.attrs;
    final direction = _axis[attrs['direction']];
    if (direction == null) {
      return ErrorWidget.withDetails(message: "'direction' is required!",);
    }
    return Flex(
      children: children,
      direction: direction,
      mainAxisAlignment: attrs['mainAxisAlignment']?.toMainAxisAlignment() ?? MainAxisAlignment.start,
      mainAxisSize: _mainAxisSize[attrs['mainAxisSize']] ?? MainAxisSize.max,
      crossAxisAlignment: _crossAxisAlignment[attrs['crossAxisAlignment']] ?? CrossAxisAlignment.center,
      textDirection: _textDirection[attrs['textDirection']],
      verticalDirection: _verticalDirection[attrs['textDirection']] ?? VerticalDirection.down,
      textBaseline: _textBaseline[attrs['textBaseline']],
      clipBehavior: _clip[attrs['clipBehavior']] ?? Clip.none,
    );
  }
}

class _XmlScaffoldBuilder extends CommonWidgetBuilder {
  const _XmlScaffoldBuilder() : super('Scaffold');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = element.context.resource;
    final components = <String, AssembleChildElement>{};
    descendant.where((e) => e.attrs.keys.contains('scaffold')).forEach((e) {
      final key = e.attrs['scaffold'] ?? '';
      components[key] = e;
    });

    final floatingButton = components['floatingActionButton'];
    return Scaffold(
      appBar: components['appBar']?.child as PreferredSizeWidget?,
      body: components['body']?.child,
      floatingActionButton: floatingButton?.child,
      floatingActionButtonLocation: _floatingActionButtonLocation[floatingButton?.attrs['floatingActionButtonLocation']],
      drawer: components['drawer']?.child,
      endDrawer: components['endDrawer']?.child,
      bottomNavigationBar: components['bottomNavigationBar']?.child,
      bottomSheet: components['bottomSheet']?.child,
      backgroundColor: res[attrs['backgroundColor']],
      resizeToAvoidBottomInset: attrs['backgroundColor']?.let((it) => it == "true"),
      primary: attrs['primary'] != "false",
      drawerDragStartBehavior: _drawerDragStartBehavior[attrs['drawerDragStartBehavior']] ?? DragStartBehavior.start,
      extendBody: attrs['extendBody'] == "true",
      extendBodyBehindAppBar: attrs['extendBodyBehindAppBar'] == "true",
      drawerScrimColor: res[attrs['drawerScrimColor']],
      drawerEdgeDragWidth: attrs['drawerEdgeDragWidth']?.toDouble(),
      drawerEnableOpenDragGesture: attrs['drawerEnableOpenDragGesture'] != "false",
      endDrawerEnableOpenDragGesture: attrs['endDrawerEnableOpenDragGesture'] != "false",
      restorationId: attrs['restorationId'],
    );
  }
}

class _XmlAppBarBuilder extends CommonWidgetBuilder {
  const _XmlAppBarBuilder() : super('AppBar');

  @override
  Widget build(AssembleElement element, List<AssembleChildElement> descendant) {
    final attrs = element.attrs;
    final res = element.context.resource;
    final components = <String, AssembleChildElement>{};
    descendant.where((e) => e.attrs.keys.contains('appBar')).forEach((e) {
      final key = e.attrs['appBar'] ?? '';
      components[key] = e;
    });
    return AppBar(
      leading: components['leading']?.child,
      automaticallyImplyLeading: attrs['automaticallyImplyLeading'] != "false",
      title: components['title']?.child,
      flexibleSpace: components['flexibleSpace']?.child,
      bottom: components['bottom']?.child as PreferredSizeWidget?,
      elevation: attrs['elevation']?.toSize(),
      shadowColor: res[attrs['shadowColor']],
      foregroundColor: res[attrs["foregroundColor"]],
      backgroundColor: res[attrs["backgroundColor"]],
      brightness: _brightness[attrs["brightness"]],
      // iconTheme: ,
      // actionsIconTheme: ,
      // textTheme: _buttonTextTheme[attrs['textTheme']],
      primary: attrs['primary'] != "false",
      centerTitle: attrs['centerTitle']?.let((it) => it == "true"),
      excludeHeaderSemantics: attrs['excludeHeaderSemantics'] == "true",
      titleSpacing: attrs['titleSpacing']?.toSize(),
      toolbarOpacity: attrs['toolbarOpacity']?.toSize() ?? 1.0,
      bottomOpacity: attrs['bottomOpacity']?.toSize() ?? 1.0,
      toolbarHeight: attrs['toolbarHeight']?.toSize(),
      leadingWidth: attrs['leadingWidth']?.toSize(),
      backwardsCompatibility: attrs['backwardsCompatibility']?.let((it) => it == "true"),
      // toolbarTextStyle: ,
      // titleTextStyle: ,
      // systemOverlayStyle: ,
    );
  }
}
