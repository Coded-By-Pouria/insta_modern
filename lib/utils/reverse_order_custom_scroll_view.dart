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
    if (firstChild == null) {
      return children;
    }
    RenderSliver? child = firstChild;
    while (child != null) {
      children.add(child);
      child = childAfter(child);
    }
    return children;
  }
}
