import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PinnedSliver extends SingleChildRenderObjectWidget {
  const PinnedSliver({
    super.key,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMyCustomClippedSliver();
  }
}

class _RenderMyCustomClippedSliver extends RenderSliver
    with RenderObjectWithChildMixin {
  _RenderMyCustomClippedSliver();

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    assert(child is RenderSliver,
        "Child of MyCustomClippedSliver must be type of sliver.");
    child!.layout(constraints);

    geometry = (child as RenderSliver).geometry!;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final c = child as RenderSliver;
    if (child != null && c.geometry!.visible) {
      context.paintChild(child!, offset + Offset(0, constraints.overlap));
    }
  }
}
