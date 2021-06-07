import 'package:flutter/material.dart';
import 'commonComponents/customCard.dart';
import 'secondPage.dart';
import 'GamePage.dart';
import 'transition.dart';
import 'storePage.dart';
import 'Chart.dart';
import 'optionsPage.dart';
import 'dart:async';
import 'bubbles.dart';
import 'shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fest Taps',
        theme: ThemeData(
            primarySwatch: Colors.red,
            backgroundColor: Colors.black45
        ),
        home: MyHomePage(title: 'Fest Taps'),
        routes: <String, WidgetBuilder>{
          '/a': (BuildContext context) => SecondPage(title: 'Page A'),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Color> signInGradients;
  List<Color> signUpGradients;
  List<Color> list, tapped;
  List<Color> prevGradients;
  List<Color> prevGradients2;
  List<List<int>> doesItWork;

  var top, top2;
  var bottom, bottom2;
  StreamSubscription periodicSub;
  bool _onTapCondition = true;
  var whichColors;

  @override
  void initState() {

    signUpGradients = [
      //Color(0xBB42f49b),
      Color(0xDD32ff00),
      Color(0xBB0061ff),
    ];

    signInGradients = [
      Color(0xFF3c00b5),
      Color(0xBBba0050),
    ];

    tapped = [
      Color(0x55FFFFFF),
      Color(0x55FFFFFF),
    ];

    list = [
      Colors.lightGreen,
      Colors.redAccent,
    ];

    top = FractionalOffset.bottomRight;
    bottom = FractionalOffset.topLeft;

    whichColors = 0;

    periodicSub = new Stream.periodic(const Duration(seconds: 5)).take(100000).listen((_) =>
    setState(() {
        doThis();
      })
    );

    super.initState();

  }

  void doThis()
  {
    if(whichColors == 0)
    {
      whichColors = 1;
      prevGradients = signInGradients;
      signInGradients = signUpGradients;
      top = FractionalOffset.topRight;
      bottom = FractionalOffset.bottomLeft;

    }
    else
    {
      whichColors = 0;
      signInGradients = prevGradients;
      prevGradients = signUpGradients;
      top = FractionalOffset.bottomRight;
      bottom = FractionalOffset.topLeft;
    }
  }

  @override
  void dispose() {
    periodicSub.cancel();
    periodicSub = null;
    super.dispose();
  }

  Widget roundedRectButton(
      String title, List<Color> gradient, bool isEndIconVisible, int type) =>
      Builder(builder: (BuildContext mContext) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          GestureDetector(
          onTap: _onTapCondition ? () {

        _onTapCondition = false;

        periodicSub = new Stream.periodic(const Duration(milliseconds: 100)).take(1).listen((_) =>

        setState(() {

          _onTapCondition = true;

          if (type < 0) {
            print("play");
            Navigator.push(
              context,
              MyCustomRoute(builder: (context) => GamePage()),
            );
          }
          if (type == 0) {
            print("store");
            Navigator.push(
              context,
              MyCustomRoute(builder: (context) => StorePage()),
            );
          }
          if (type > 0) {
            print("options");
            Navigator.push(
              context,
              MyCustomRoute(builder: (context) => OptionsPage()),
            );
          }
        }));
      } : null,
            child: Stack( alignment: Alignment(1.0, 0.0),
            children: <Widget>[
              AnimatedContainer(
                alignment: Alignment.center,
                width: MediaQuery.of(mContext).size.width / 1.5,
                height: MediaQuery.of(mContext).size.height / 10,
                duration: Duration(seconds: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: new LinearGradient(
                      begin: top,
                      end: bottom,
                      colors: gradient,
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

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Color(0xFF99ffcc),
                child: Text(
                  'Fest Taps',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Rikos',
                      fontSize: MediaQuery.of(context).size.height / 8.5,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 60),
            ),
            roundedRectButton("Play", signInGradients, false, -1),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            roundedRectButton("Store", signInGradients, false, 0),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            roundedRectButton("Options", signInGradients, false, 1),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

