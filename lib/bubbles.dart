import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TabBarAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BubblesState();
  }
}

class _BubblesState extends State<TabBarAnimation> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Bubble> bubbles;
  final int numberOfBubbles = 10;
  final Color color = Color(0x11ffffff);
  final double maxBubbleSize = 20.0;

  @override
  void initState() {
    super.initState();

    // Initialize bubbles
    bubbles = List();
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize));
      i--;
    }

    // animation controller
    _controller = new AnimationController(
        duration: const Duration(seconds: 6000), vsync: this);
    _controller.addListener(() {
        updateBubblePosition();
        updateBubbleOpacity();
    });
      _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 10,
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            CustomPaint( //This is Animation as shown in previous video
              foregroundPainter:
              BubblePainter(bubbles: bubbles, controller: _controller),
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
            ),
          ],
        ),
    );
  }

  void updateBubblePosition() {
      bubbles.forEach((it) => it.updatePosition());
        setState(() {});
  }

  void updateBubbleOpacity(){
    bubbles.forEach((it) => it.updateOpacity());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;
  AnimationController controller;

  BubblePainter({this.bubbles, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    bubbles.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Bubble(Color colour, double maxBubbleSize) {
    this.colour = colour.withOpacity(Random().nextDouble() * .2);
    this.direction = Random().nextDouble() * 360;
    this.speed = 1;
    this.radius = Random().nextDouble() * maxBubbleSize;
  }

  updateOpacity(){
    this.colour = this.colour.withOpacity(Random().nextDouble() * .2);
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = ((Random().nextDouble()) * canvasSize.width) ;
    }

    if (y == null) {
      this.y = ((Random().nextDouble()) * canvasSize.height) ;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {

    if (x > canvasSize.width || x < 0 || y  > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}