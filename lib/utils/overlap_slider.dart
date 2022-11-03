import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta_modern/utils/reverse_order_custom_scroll_view.dart';
import 'package:insta_modern/utils/sliver_with_background.dart';

class OverlapSlider extends StatefulWidget {
  final double maxVal;
  final Widget staticPart;
  final Widget sliderPart;
  final Color? backgroundColor;
  const OverlapSlider({
    required this.sliderPart,
    required this.staticPart,
    required this.maxVal,
    this.backgroundColor,
    super.key,
  });

  @override
  State<OverlapSlider> createState() => _OverlapSliderState();
}

class _OverlapSliderState extends State<OverlapSlider> {
  final ScrollController _controller = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  late final maxVal;

  @override
  void initState() {
    maxVal = widget.maxVal;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(double position) {
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        position,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    });
  }

  void _scrollEndHandler() {
    final value = _controller.offset;
    if (value == 0 || value == maxVal) {
      return;
    }
    if (value < maxVal / 2) {
      _runAnimation(0);
    } else if (value < maxVal) {
      _runAnimation(maxVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            _scrollEndHandler();
          }
          return true;
        },
        child: ReverseOrderScrollView(
          controller: _controller,
          slivers: [
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: MySliverPersistentHeaderDelegate(
                maxVal: maxVal,
                child: widget.staticPart,
              ),
            ),
            SliverWithBackGround(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    width: 300,
                    height: 150,
                    color: Color.fromARGB(
                      255,
                      Random().nextInt(255),
                      Random().nextInt(255),
                      Random().nextInt(255),
                    ),
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
