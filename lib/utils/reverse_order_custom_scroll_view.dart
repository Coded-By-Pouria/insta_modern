import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ReverseOrderScrollView extends CustomScrollView {
  const ReverseOrderScrollView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    super.slivers = const <Widget>[],
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    if (shrinkWrap) {
      return ShrinkWrappingViewport(
        axisDirection: axisDirection,
        offset: offset,
        slivers: slivers,
        clipBehavior: clipBehavior,
      );
    }
    return ViewportWithReversePainting(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
      center: center,
      anchor: anchor,
      clipBehavior: clipBehavior,
    );
  }
}

class ViewportWithReversePainting extends Viewport {
  ViewportWithReversePainting({
    super.key,
    super.axisDirection = AxisDirection.down,
    super.crossAxisDirection,
    super.anchor = 0.0,
    required super.offset,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle = CacheExtentStyle.pixel,
    super.clipBehavior = Clip.hardEdge,
    super.slivers = const <Widget>[],
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return RenderViewPortWithReversePainting(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
    );
  }
}

class RenderViewPortWithReversePainting extends RenderViewport {
  RenderViewPortWithReversePainting({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.anchor = 0.0,
    super.children,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
  });

  @override
  Iterable<RenderSliver> get childrenInPaintOrder {
    final List<RenderSliver> children = <RenderSliver>[];
    final List<RenderSliver> outOfOrderedSlivers = <RenderSliver>[];
    if (firstChild == null) {
      return children;
    }
    RenderSliver? child = firstChild;

    while (child != null) {
      if (child is RenderOutOfOrderSliver) {
        outOfOrderedSlivers.add(child);
        child = childAfter(child);
        continue;
      }
      children.add(child);
      child = childAfter(child);
    }

    for (child in outOfOrderedSlivers) {
      children.add(child);
    }

    return children;
  }

  @override
  Iterable<RenderSliver> get childrenInHitTestOrder {
    final List<RenderSliver> children = <RenderSliver>[];
    final List<RenderSliver> outOfOrderedSlivers = <RenderSliver>[];
    if (firstChild == null) {
      return children;
    }

    RenderSliver? child = lastChild;

    while (child != null) {
      if (child is RenderOutOfOrderSliver) {
        outOfOrderedSlivers.add(child);
      } else {
        children.add(child);
      }
      child = childBefore(child);
    }

    return <RenderSliver>[...outOfOrderedSlivers, ...children];
  }
}

class OutOfOrderSliver extends SingleChildRenderObjectWidget {
  const OutOfOrderSliver({super.child, super.key});
  @override
  RenderOutOfOrderSliver createRenderObject(BuildContext context) {
    return RenderOutOfOrderSliver();
  }
}

/// A marker class to use in [ReverseOrderScrollView].
/// with use of this class in the [ReverseOrderScrollView], RenderOrderScrollView paint the child
/// sliver over than slivers that doen't use this class.
class RenderOutOfOrderSliver extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      child!.hitTest(result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;
      context.paintChild(child!, offset + childParentData.paintOffset);
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints);
    geometry = child!.geometry;
  }
}
