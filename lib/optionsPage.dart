import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  OptionsPage({@required this.title});

  final title;
  bool _onTapCondition = true;

  List<Color> gradients = [
    Colors.black,
    Colors.black,
  ];

  var top = FractionalOffset.bottomRight;
  var bottom = FractionalOffset.topLeft;

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            roundedRectButton("Sound : On", Colors.blueGrey, false, -1),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            roundedRectButton("Lighting Effects : On", Colors.blueGrey, false, 0),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ],
    ),
    );
  }

  Widget roundedRectButton(
      String title, Color gradient, bool isEndIconVisible, int type) =>
      Builder(builder: (BuildContext mContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            GestureDetector(
              onTap: _onTapCondition ? () {

                      //_onTapCondition = true;

                      if (type < 0) {
                      }
                      if (type == 0) {
                      }
                      if (type > 0) {
                      }

              } : null,
              child: Stack( alignment: Alignment(1.0, 0.0),
                children: <Widget>[
                  AnimatedContainer(
                    alignment: Alignment.center,
                    width: MediaQuery.of(mContext).size.width / 1.3,
                    height: MediaQuery.of(mContext).size.height / 10,
                    duration: Duration(seconds: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: new LinearGradient(
                          begin: top,
                          end: bottom,
                          colors: gradients,
                        ),
                        color: Colors.lightGreen
                    ),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 5,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Neris',
                          decoration: TextDecoration.none,)),
                    padding: EdgeInsets.only(top: 0, bottom: 5),
                  ),
                ],
              ),
            ),
          ],
        );
      });

}