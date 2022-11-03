import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverWithBackGround extends SingleChildRenderObjectWidget {
  SliverWithBackGround({super.child, super.key});
  @override
  RenderSliverWithBackGround createRenderObject(BuildContext context) {
    return RenderSliverWithBackGround();
  }
}

class RenderSliverWithBackGround extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;
      context.canvas.drawPaint(Paint()..color = Colors.red);
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
  }
}
