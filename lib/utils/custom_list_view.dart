import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///   A list view which each item place over its earlier item.
class CustomListView extends ListView {
  CustomListView.builder({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.prototypeItem,
    required super.itemBuilder,
    super.findChildIndexCallback,
    required super.itemCount,
    super.addAutomaticKeepAlives = true,
    super.addRepaintBoundaries = true,
    super.addSemanticIndexes = true,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
    super.itemExtentBuilder,
  }) : super.builder();

  @override
  Widget buildChildLayout(BuildContext context) {
    if (itemExtent != null) {
      return CustomSliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: itemExtent!,
      );
    } else if (prototypeItem != null) {
      return SliverPrototypeExtentList(
        delegate: childrenDelegate,
        prototypeItem: prototypeItem!,
      );
    }
    return SliverList(delegate: childrenDelegate);
  }
}

class CustomSliverFixedExtentList extends SliverFixedExtentList {
  const CustomSliverFixedExtentList({
    super.key,
    required super.delegate,
    required super.itemExtent,
  });

  @override
  RenderSliverFixedExtentList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return CustomRenderSliverFixedExtentList(
        childManager: element, itemExtent: itemExtent);
  }
}

class CustomRenderSliverFixedExtentList extends RenderSliverFixedExtentList {
  CustomRenderSliverFixedExtentList({
    required super.childManager,
    required super.itemExtent,
  });

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset, double itemExtent) {
    itemExtent = this.itemExtent;
    itemExtent -= 40;
    if (itemExtent > 0.0) {
      final double actual = scrollOffset / itemExtent - 1;
      final int round = actual.round();
      if ((actual * itemExtent - round * itemExtent).abs() <
          precisionErrorTolerance) {
        return math.max(0, round);
      }
      return math.max(0, actual.ceil());
    }
    return 0;
  }

  @override
  double indexToLayoutOffset(double itemExtent, int index) {
    return this.itemExtent * index - 40 * index;
  }
}
