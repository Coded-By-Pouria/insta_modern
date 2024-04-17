import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class LazyBuilder extends LayoutBuilder {
  const LazyBuilder({
    required super.builder,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLazyBuilder();
  }
}

class RenderLazyBuilder extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderConstrainedLayoutBuilder<BoxConstraints, RenderBox> {
  void newPosition(double? top, double? right, double? bottom, double? left) {
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  void performLayout() {
    // BoxConstraints childConstraints = this.constraints;
    rebuildIfNecessary();
    if (child != null) {
      final pd = child!.parentData as StackParentData;
      pd.width = constraints.maxWidth;

      RenderStack.layoutPositionedChild(
        child!,
        pd,
        constraints.biggest,
        Alignment.centerLeft,
      );
      // print(
      //     "sisssze ${((parent as RenderBox).parentData as BoxParentData).offset}");

      // pd.offset = Offset(pd.left ?? 0, pd.top ?? 0);]
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  // @override
  // bool hitTest(BoxHitTestResult result, {required Offset position}) {
  //   return child!.hitTest(result, position: position);
  // }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final StackParentData childParentData =
        child!.parentData! as StackParentData;
    final Matrix4 transform = Matrix4.identity();
    applyPaintTransform(child!, transform);
    final bool isHit = result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - childParentData.offset);
        return child!.hitTest(result, position: transformed);
      },
    );
    if (isHit) {
      return true;
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final StackParentData childParentData =
          child!.parentData as StackParentData;
      context.paintChild(child!, childParentData.offset + offset);
    }
  }
}
