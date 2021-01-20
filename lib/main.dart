import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:core';

void main() {
  runApp(PatternBrushApp());
}

const colorPink = Color(0xfff47c9e);

Color getRandomColor() {
  const palette = [
    Color(0xfff47c9e),
    Color(0xfff7ef99),
    Color(0xff9cf6f6),
    Color(0xffccf6c8),
    Color(0xfffafcc2),
    Color(0xfff6f6ad),
    Color(0xfff9c0c0)
  ];
  Random random = Random();
  return palette[random.nextInt(palette.length)];
}

class PatternBrushApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pattern Brush',
      home: PatternBrush(),
    );
  }
}

class Circle {
  final Offset position;
  final double radius;
  final Color color;

  Circle(this.position, this.color, this.radius);
}

class DynamicColorCircle {
  final Offset position;
  final double radius;

  DynamicColorCircle(this.position, this.radius);
}

class PatternBrush extends StatefulWidget {
  @override
  _PatternBrushState createState() => _PatternBrushState();
}

class _PatternBrushState extends State<PatternBrush> {
  List<Circle> _circles = List<Circle>();
  List<DynamicColorCircle> _dynamicColorCircles = List<DynamicColorCircle>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _circles.clear();
              _dynamicColorCircles.clear();
            });
          },
          child: Icon(Icons.clear),
          backgroundColor: Color(0xfff47c9e),
        ),
        body: SafeArea(
          child: GestureDetector(
              onPanUpdate: (details) {
                Offset position = details.localPosition;
                double radius =
                    max(details.delta.dx.abs(), details.delta.dy.abs());

                setState(() {
                  _dynamicColorCircles
                      .add(DynamicColorCircle(position, radius));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _dynamicColorCircles.forEach((dynamicColorCircle) {
                    _circles.add(Circle(dynamicColorCircle.position,
                        getRandomColor(), dynamicColorCircle.radius));
                  });

                  _dynamicColorCircles.clear();
                });
              },
              child: CustomPaint(
                  painter: PatternBrushPainter(_circles, _dynamicColorCircles),
                  child: Container())),
        ));
  }
}

class PatternBrushPainter extends CustomPainter {
  final Paint _borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke;

  final List<Circle> _circles;
  final List<DynamicColorCircle> _dynamicColorCircles;

  PatternBrushPainter(this._circles, this._dynamicColorCircles);

  @override
  void paint(Canvas canvas, Size size) {
    _circles.forEach((circle) {
      final Paint circlePaint = Paint()
        ..color = circle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(circle.position, circle.radius, circlePaint);
      canvas.drawCircle(circle.position, circle.radius, _borderPaint);
    });

    _dynamicColorCircles.forEach((dynamicColorCircle) {
      final Paint dynamicColorCirclePaint = Paint()
        ..color = getRandomColor()
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dynamicColorCircle.position, dynamicColorCircle.radius,
          dynamicColorCirclePaint);
      canvas.drawCircle(
          dynamicColorCircle.position, dynamicColorCircle.radius, _borderPaint);
    });
  }

  @override
  bool shouldRepaint(PatternBrushPainter oldDelegate) {
    return true;
  }
}
