import 'package:flutter/widgets.dart';

class CustomSimulation extends Simulation {
  final double initialPosition;
  final double velocity;
  CustomSimulation({
    required this.initialPosition,
    required this.velocity,
  });
  @override
  double dx(double time) {
    // TODO: implement dx
    throw UnimplementedError();
  }

  @override
  bool isDone(double time) {
    // TODO: implement isDone
    throw UnimplementedError();
  }

  @override
  double x(double time) {
    // TODO: implement x
    throw UnimplementedError();
  }
}

class CustomScrollPhysics extends ScrollPhysics {}
