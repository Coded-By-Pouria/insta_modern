import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_modern/utils/slider_sliver/slider_physics.dart';
import 'package:insta_modern/widgets/add_profile_widget.dart';

class CustomParentDataBox extends ContainerBoxParentData<RenderBox> {}

class CustomOverlapSliverWidget extends StatefulWidget {
  final Widget staticPart;
  final List<Widget> scrolls;
  final Widget menu;
  final bool shouldExpand;
  final EdgeInsets padding;
  CustomOverlapSliverWidget({
    super.key,
    required this.scrolls,
    required this.staticPart,
    required this.menu,
    this.shouldExpand = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<CustomOverlapSliverWidget> createState() =>
      _CustomOverlapSliverWidgetState();
}

class _CustomOverlapSliverWidgetState extends State<CustomOverlapSliverWidget> {
  late SliderController controller;

  @override
  void initState() {
    controller = SliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomOvrlapSliver(
      controller: controller,
      shouldExpand: widget.shouldExpand,
      children: [
        widget.staticPart,
        widget.menu,
        Container(
          color: Theme.of(context).backgroundColor,
          padding: widget.padding,
          child: CustomScrollView(
            physics: const SliderPhsics(),
            controller: controller,
            slivers: widget.scrolls,
          ),
        ),
      ],
    );
  }
}

class CustomOvrlapSliver extends MultiChildRenderObjectWidget {
  // final Widget staticPart;
  // final Widget scrollPart;
  // final ScrollController controller;
  final SliderController controller;
  final bool shouldExpand;
  CustomOvrlapSliver({
    super.key,
    super.children,
    required this.controller,
    required this.shouldExpand,
  });

  @override
  RenderCustomOverlapSliver createRenderObject(BuildContext context) {
    return RenderCustomOverlapSliver(
        controller: controller, shouldExpand: shouldExpand);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    RenderCustomOverlapSliver ro = renderObject as RenderCustomOverlapSliver;
    if (shouldExpand != ro.shouldExpand) {
      ro.shouldExpand = shouldExpand;
      super.updateRenderObject(context, renderObject);
    }
  }
}

class RenderCustomOverlapSliver extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomParentDataBox>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomParentDataBox> {
  SliderController controller;
  final bool shouldExpand;
  RenderCustomOverlapSliver({
    required this.controller,
    required this.shouldExpand,
  });

  set shouldExpand(bool shouldExpand) => markUpdate();

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    controller.addSlideListener(markUpdate);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomParentDataBox) {
      child.parentData = CustomParentDataBox();
    }
  }

  void markUpdate() {
    markNeedsLayout();
    // markNeedsPaint();
    // markNeedsCompositingBitsUpdate();
  }

  @override
  void performLayout() {
    // print("******SlideOffset : ${controller.sliderOffset}");

    final header = firstChild!;
    header.layout(
      BoxConstraints(
        maxWidth: constraints.maxWidth,
        maxHeight: double.infinity,
      ),
      parentUsesSize: true,
    );

    // Apply and fetch slideOffsetData;
    final headerHeight = header.size.height;
    final position =
        controller.position as SliderScrollPositionWithSingleContext;
    position.applySlideDimension(headerHeight);

    final menu = (header.parentData as CustomParentDataBox).nextSibling!;
    menu.layout(
      BoxConstraints(
        maxHeight: 200,
        maxWidth: constraints.maxWidth,
      ),
      parentUsesSize: true,
    );

    final scroller = (menu.parentData as CustomParentDataBox).nextSibling!;

    scroller.layout(
      BoxConstraints(
        maxHeight: constraints.maxHeight -
            (headerHeight + menu.size.height) +
            (controller.sliderOffset > headerHeight
                ? headerHeight
                : controller.sliderOffset),
        maxWidth: constraints.maxWidth,
      ),
      parentUsesSize: true,
    );

    // print("scroller height : ${scroller.size.height}");

    final headerPD = header.parentData as CustomParentDataBox;
    headerPD.offset = const Offset(0, 0);

    final menuPD = menu.parentData as CustomParentDataBox;

    final double slideOffset = headerHeight - controller.sliderOffset;
    double dy = slideOffset < 0 ? 0.0 : slideOffset;

    menuPD.offset = Offset(0, dy);

    final scrollerPD = scroller.parentData as CustomParentDataBox;
    scrollerPD.offset = Offset(0, dy + menu.size.height);

    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
