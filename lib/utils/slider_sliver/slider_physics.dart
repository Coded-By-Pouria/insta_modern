import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// a mixin that provide a protocol for extra listening-notifying behavior for some other state
/// source like [SliderScrollPositionWithSingleContext.slideOffset]
mixin SlideNotifier {
  final ChangeNotifier slideNotifier = ChangeNotifier();
  void addSlideListener(VoidCallback cb) {
    slideNotifier.addListener(cb);
  }

  void removeSlideListener(VoidCallback cb) {
    slideNotifier.removeListener(cb);
  }
}

/// ScrollPosition which changed for support sliding offset value . the main value that watched, is
/// [SliderScrollPositionWithSingleContext.slideOffset] instead of
///  [ScrollPositionWithSingleContext.pixels].
class SliderScrollPositionWithSingleContext
    extends ScrollPositionWithSingleContext with SlideNotifier {
  SliderScrollPositionWithSingleContext({
    required super.physics,
    required super.context,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
    this.slideOffset = 0.0,
  });

  /// the max value that sliders offset could change. in other word this value determines how far the slider
  /// from the edge which slider should slide to it. it usually valuing in layout phase.
  late double _maxSlideOffset;

  double slideOffset;
  double get maxSlideOffset => _maxSlideOffset;

  /// return the layout-driven value. means the value that used in performLayout phase that wants to detect
  /// height and offset of slider.
  double get clampedOffset => clampDouble(slideOffset, 0, maxSlideOffset);

  /// the max value that the slideOffset could accept
  double get totalExtent => maxScrollExtent + maxSlideOffset;

  /// it apply new slide offset and notify listener.
  void applySlideOffset(double offset) {
    assert(offset >= 0, "Applied offset is less than 0");

    if (slideOffset != offset) {
      slideOffset = offset;
      slideNotifier.notifyListeners();
    }
  }

  void applySlideDimension(double dim) {
    assert(dim > 0, "Applied offset is less than 0");
    _maxSlideOffset = dim;
  }

  /// this overrided for change the base of [ScrollPositionWithSingleContext.pixels] to
  /// [SliderScrollPositionWithSingleContext.slideOffset]. with this change, the value that
  /// sends to setPixels determines new slideOffset instead of new position of pixels
  @override
  void applyUserOffset(double delta) {
    updateUserScrollDirection(
        delta > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse);
    setPixels(slideOffset - physics.applyPhysicsToUserOffset(this, delta));
  }

  /// this method overrided to first apply new position for slideOffset and then for pixels.
  /// it first check (with [SliderPhsics.applySlideOffsetBoundaryConditions]) is new value
  /// passed the maxSlideOffset or not , if does it first set the slideOffset to maxSlide
  /// and then returns the exceeded value to be applied to pixels.
  /// if it doesn't passed, it just apply new value to slideOffset and the applySlide... return 0,
  /// which means new pixels as before is 0.
  @override
  double setPixels(double newPixels) {
    if (newPixels != slideOffset) {
      final double appliablePixels = (physics as SliderPhsics)
          .applySlideOffsetBoundaryConditions(this, newPixels);
      return super.setPixels(appliablePixels);
    }
    return 0.0;
  }

  /// return true if slideOffset reach to maxSlideOffset. which indicate that the further greater
  /// values doen't effect to slideOffset but should applied to ScrollPosition.pixels
  bool get isSlideExpanded => slideOffset >= _maxSlideOffset;
}

class SliderController extends ScrollController with SlideNotifier {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return SliderScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  SliderScrollPositionWithSingleContext get slidePosition =>
      (position as SliderScrollPositionWithSingleContext);

  double get sliderOffset => slidePosition.clampedOffset;

  /// it also remove the slide-related listeners
  @override
  void attach(ScrollPosition position) {
    assert(position is SliderScrollPositionWithSingleContext);
    super.attach(position);
    slidePosition.addSlideListener(
      slideNotifier.notifyListeners,
    );
  }

  @override
  void detach(ScrollPosition position) {
    assert(position is SliderScrollPositionWithSingleContext);
    slidePosition.removeSlideListener(slideNotifier.notifyListeners);
    super.detach(position);
  }
}

class SliderPhsics extends ClampingScrollPhysics {
  const SliderPhsics({super.parent});
  @override
  SliderPhsics applyTo(ScrollPhysics? ancestor) {
    return SliderPhsics(parent: buildParent(ancestor));
  }

  /// refer to [SliderScrollPositionWithSingleContext.setPixels] for more information.
  /// it returns a double that indicate new value for [ScrollPosition._pixels].
  double applySlideOffsetBoundaryConditions(
      ScrollMetrics position, double value) {
    position = position as SliderScrollPositionWithSingleContext;

    if (value < 0) {
      if (position.slideOffset > 0) position.applySlideOffset(0.0);
      return 0;
    }
    if (!position.isSlideExpanded &&
        (position.maxSlideOffset - position.slideOffset).abs() <
            tolerance.distance) {
      position.applySlideOffset(position.maxSlideOffset);
    } else if (value >= position.totalExtent) {
      return position.totalExtent;
    } else {
      position.applySlideOffset(value);
    }
    if (!position.isSlideExpanded && value <= position.maxSlideOffset) {
      return 0.0;
    }

    if (position.isSlideExpanded && value <= position.maxSlideOffset) {
      return -position.pixels;
    }

    return value - position.maxSlideOffset;
  }

  /// it now changed to spring back if the slider is not placed in one of 2 borders.
  /// for example if use scroll up the slider a bit (small scroll) and end the touch,
  /// the slider doesn't stay in place the user release touch, but it animate back to
  /// closest border (base of maxSlide/2).
  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    position = position as SliderScrollPositionWithSingleContext;
    final Tolerance tolerance = this.tolerance;

    if (!position.isSlideExpanded) {
      double start, end;
      start = position.slideOffset;
      end = position.slideOffset < position.maxSlideOffset / 2
          ? 0
          : position.maxSlideOffset;
      if ((start - end).abs() < tolerance.distance) return null;
      return ScrollSpringSimulation(
          spring,
          start,
          end,
          math.min(
            0.0,
            velocity,
          ));
    }
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }
      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }
      assert(end != null);
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        end!,
        math.min(0.0, velocity),
        tolerance: tolerance,
      );
    }
    if (velocity.abs() < tolerance.velocity) {
      return null;
    }
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
      return null;
    }
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.slideOffset,
      velocity: velocity,
      tolerance: tolerance,
    );
  }
}
