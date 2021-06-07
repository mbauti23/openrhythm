import 'package:flutter/material.dart';

class GradientTransform extends StatefulWidget {
  @override
  GradientTransformState createState() {
    return new GradientTransformState();
  }
}

class GradientTransformState extends State<GradientTransform> {

  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  var list = [
    Colors.lightGreen,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: AnimatedContainer(
          height: 300.0,
          width: 300.0,
          duration: Duration(seconds: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: new LinearGradient(
                begin: top,
                end: bottom,
                colors: list,
                stops: [0.0, 1.0],
              ),
              color: Colors.lightGreen
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            setState(() {
              top = FractionalOffset.bottomLeft;
              bottom = FractionalOffset.topRight;
              list = [
                Colors.blueAccent, Colors.yellowAccent
              ];
            });
          },
          icon: Icon(Icons.update),
          label: Text("Transform")),
    );
  }
}