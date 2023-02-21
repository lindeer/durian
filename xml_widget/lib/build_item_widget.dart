import 'package:flutter/material.dart';

class ItemMetaData {
  final String name;
  final int pos;

  const ItemMetaData(this.name, this.pos);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ItemMetaData && other.name == name && other.pos == pos;
  }

  @override
  int get hashCode => Object.hashAll([name, pos]);

  @override
  String toString() => "$name[$pos]";
}

class BuildItemWidget extends StatelessWidget {
  final ItemMetaData data;
  final WidgetBuilder builder;

  const BuildItemWidget({
    Key? key,
    required this.data,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ItemDataWidget(
      item: this,
      child: Builder(
        builder: this.builder,
      ),
    );
  }

  static ItemMetaData? of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<_ItemDataWidget>()?.item;
    return widget?.data;
  }
}

class _ItemDataWidget extends InheritedWidget {
  final BuildItemWidget item;

  _ItemDataWidget({
    Key? key,
    required this.item,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _ItemDataWidget old) => old.item.data != item.data;
}
