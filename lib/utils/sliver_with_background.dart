import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverWithBackGround extends SingleChildRenderObjectWidget {
  final Color color;
  final Radius radius;
  const SliverWithBackGround({
    super.key,
    super.child,
    required this.color,
    required this.radius,
  });
  @override
  RenderSliverWithBackGround createRenderObject(BuildContext context) {
    return RenderSliverWithBackGround(
      radius: radius,
      totalHeight: MediaQuery.of(context).size.height,
      color: color,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    final ro = renderObject as RenderSliverWithBackGround;
    ro
      ..color = color
      ..radius = radius;
    super.updateRenderObject(context, renderObject);
  }
}

class RenderSliverWithBackGround extends RenderSliver
    with RenderObjectWithChildMixin<RenderSliver> {
  Color _color;
  Radius _radius;
  RenderSliverWithBackGround({
    required double totalHeight,
    required Color color,
    required Radius radius,
  })  : _color = color,
        _radius = radius;

  Color get color => _color;
  Radius get radius => _radius;

  set radius(Radius newRadius) {
    if (newRadius != _radius) {
      _radius = newRadius;
      markNeedsPaint();
    }
  }

  set color(Color newColor) {
    if (newColor != _color) {
      _color = newColor;
      markNeedsPaint();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  ClipRRectLayer? _clipLayer;
  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;

      double top = offset.dy;
      _clipLayer = ClipRRectLayer(
        clipRRect: RRect.fromLTRBR(
          0,
          top,
          constraints.crossAxisExtent,
          geometry!.paintExtent + top,
          radius,
        ),
      );
      context.pushLayer(
        _clipLayer!,
        (context, offset) {
          context.canvas.drawPaint(Paint()..color = color);
          context.paintChild(child!, offset + childParentData.paintOffset);
        },
        offset,
      );
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    SliverPadding;
    if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      child!.hitTest(result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    final SliverPhysicalParentData childParentData =
        child.parentData! as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
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
