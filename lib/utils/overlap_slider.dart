import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_modern/utils/app_theme.dart';
import 'package:insta_modern/utils/reverse_order_custom_scroll_view.dart';
import 'package:insta_modern/utils/sliver_with_background.dart';

class OverlapSlider extends StatefulWidget {
  final double maxVal;
  final Widget staticPart;
  final Widget sliderPart;
  final Color? backgroundColor;
  final Widget? menu;
  final ScrollController? scrollController;
  const OverlapSlider({
    required this.sliderPart,
    required this.staticPart,
    required this.maxVal,
    this.scrollController,
    this.backgroundColor,
    this.menu,
    super.key,
  });

  @override
  State<OverlapSlider> createState() => _OverlapSliderState();
}

class _OverlapSliderState extends State<OverlapSlider> {
  // ignore: prefer_typing_uninitialized_variables
  late final maxVal;

  @override
  void initState() {
    if (widget.scrollController == null) {
      _defaultScrollController = ScrollController();
    }
    maxVal = widget.maxVal;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    _defaultScrollController?.dispose();
  }

  ScrollController? _defaultScrollController;

  get controller => widget.scrollController ?? _defaultScrollController;

  void _runAnimation(double position, {void Function(double)? callback}) {
    _isAnimationing = true;
    Future.delayed(Duration.zero, () {
      controller
        ..addListener(() {
          if (callback != null) {
            callback(controller.offset);
          }
        })
        ..animateTo(
          position,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeIn,
        ).whenComplete(() => _isAnimationing = false);
    });
  }

  bool _isAnimationing = false;
  void _scrollEndHandler() {
    final value = controller.offset;
    if (value == 0 || value == maxVal || _isAnimationing) {
      return;
    }
    if (value < maxVal / 2) {
      _runAnimation(0);
    } else if (value < maxVal) {
      _runAnimation(maxVal);
    }
  }

  bool _tapDown = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && !_isAnimationing) {
          _scrollEndHandler();
        }
        return true;
      },
      child: GestureDetector(
        onTapDown: (details) {
          if (_isAnimationing) {
            (controller.position as ScrollPositionWithSingleContext).goIdle();
            _isAnimationing = false;
            _tapDown = true;
          }
        },
        onTap: () {
          if (_tapDown) {
            _scrollEndHandler();
            _tapDown = false;
          }
        },
        child: ReverseOrderScrollView(
          controller: controller,
          slivers: [
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: MySliverPersistentHeaderDelegate(
                maxVal: maxVal,
                child: widget.staticPart,
              ),
            ),
            if (widget.menu != null)
              OutOfOrderSliver(
                key: UniqueKey(),
                child: SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: MySliverPersistentHeaderDelegate(
                    maxVal: 45,
                    child: widget.menu!,
                  ),
                ),
              ),
            SliverWithBackGround(
              radius: const Radius.circular(AppTheme.mainPagePostRadius),
              color:
                  widget.backgroundColor ?? Theme.of(context).backgroundColor,
              child: widget.sliderPart,
            ),
          ],
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxVal;
  final Widget child;
  MySliverPersistentHeaderDelegate({required this.child, required this.maxVal});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxVal;

  @override
  double get minExtent => maxVal;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
