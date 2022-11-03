import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef PhysicableCallback = Widget Function(
  BuildContext context,
  ScrollPhysics physics,
);

class ExpandablePositioned extends StatefulWidget {
  // final double top;
  final Widget? staticPart;
  final double expandLength;
  final PhysicableCallback expandPart;
  // final ScrollController expandPartController;

  final double? top;
  final double? bottom;

  /// expandPart parameter must be a sliver.
  const ExpandablePositioned({
    super.key,
    this.top,
    this.bottom,
    // required this.top,
    this.staticPart,
    required this.expandPart,
    required this.expandLength,
    // required this.expandPartController,
  });

  @override
  State<ExpandablePositioned> createState() => _ExpandablePositionedState();
}

class _ExpandablePositionedState extends State<ExpandablePositioned>
    with TickerProviderStateMixin {
  late ScrollController _controller;
  late double top;

  bool get _isScrollable => top == 0;

  @override
  void initState() {
    top = widget.expandLength;
    super.initState();
  }

  void _dragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      final dy = details.primaryDelta;
      top += dy!;
      top = clampDouble(top, 0, widget.expandLength);
    });
  }

  late AnimationController _animationController;
  Tolerance tolerance = const Tolerance(
    distance: 0.01,
    time: 0.01,
    velocity: 0.1,
  );
  void _dragEndHandler(DragEndDetails details) {
    if (top < widget.expandLength && top > 0) {
      print("im here mother fuckers");

      final start = top;
      final double end =
          top >= widget.expandLength / 2 ? widget.expandLength : 0;

      _animationController = AnimationController.unbounded(
        vsync: this,
      )
        ..addListener(() {
          print(top);
          top = _animationController.value;
          if ((_animationController.value - 0).abs() < tolerance.distance ||
              (_animationController.value - widget.expandLength).abs() <
                  tolerance.distance) {
            _animationController.stop();
            _animationController.dispose();
          }

          setState(() {});
        })
        ..animateWith(
          ScrollSpringSimulation(
            SpringDescription.withDampingRatio(
              mass: 0.5,
              stiffness: 100.0,
              ratio: 1.1,
            ),
            start,
            end,
            math.min(0, details.velocity.pixelsPerSecond.dy),
          ),
        );
      // _animationController.forward();
      // _animationController.addListener(() { });
      // _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (widget.staticPart != null) widget.staticPart!,
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: _dragUpdateHandler,
              onVerticalDragEnd: _dragEndHandler,
              child: widget.expandPart(
                context,
                _isScrollable
                    ? const ScrollBehavior().getScrollPhysics(context)
                    : const NeverScrollableScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
