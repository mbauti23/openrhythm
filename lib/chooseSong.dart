import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

List<Color> freeCols = [
//Color(0xBB42f49b),
  Color(0xff32ffaa),
  Color(0xff0061ff),
];

List<Color> premiumCols = [
//Color(0xBB42f49b),
  Color(0xff0061ff),
  Color(0xffaa4445),
];

List<Color> popularCols = [
//Color(0xBB42f49b),
  Color(0xFF3c00b5),
  Color(0xffba0050),
];

class ChooseSong extends StatelessWidget {
  ChooseSong({@required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Bottom Navigation',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFFFFAD32),
      ),
      home: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: true,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                },
              ),],
            leading: IconButton(icon:Icon(Icons.arrow_back, color: Colors.white),
              onPressed:() {Navigator.pop(context, true);},
            ),
          ),
        ),
        body: DashboardScreen(title: 'Bottom Navigation'),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView(
        children: [
          new Popular("Popular Songs"),
          new Free("Free Songs"),
          new Premium("Premium Songs"),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: const Color(0xFF000000),
        ), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          iconSize: 26,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.music_note,
                  color: const Color(0xFF00ccFF),
                ),
                title: new Text(
                  "Popular",
                  style: new TextStyle(
                    fontSize: 17,
                    color: const Color(0xFFFFFFFF),
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.card_giftcard,
                  color: const Color(0xFFFF0077),
                ),
                title: new Text(
                  "Free",
                  style: new TextStyle(
                    fontSize: 17,
                    color: const Color(0xFFFFFFFF),
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.attach_money,
                  color: const Color(0xFF88FF00),
                ),
                title: new Text(
                  "Premium",
                  style: new TextStyle(
                    fontSize: 17,
                    color: const Color(0xFFFFFFFF),
                  ),
                ))
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}


class Popular extends StatelessWidget {
  Popular(this.listType);
  final String listType;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: popularCols)
      ),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.0,
                  height: MediaQuery.of(context).size.height / 1.4,
                  color: const Color(0x99000000),
                  child: new Text(
                      "Popular",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Neris',
                        decoration: TextDecoration.none,)),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class Free extends StatelessWidget {
  Free(this.listType);
  final String listType;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: freeCols)
      ),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.0,
                  height: MediaQuery.of(context).size.height / 1.4,
                  color: const Color(0x99000000),
                  child: new Text(
                      "Free Songs",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Neris',
                        decoration: TextDecoration.none,)),
                )
            ),
            /*new Text(
              listType,
              style: Theme.of(context).textTheme.display1,
            ),*/
          ],
        ),
      ),
    );
  }
}

class Premium extends StatelessWidget {
  Premium(this.listType);
  final String listType;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: premiumCols)
      ),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.0,
                  height: MediaQuery.of(context).size.height / 1.4,
                  color: const Color(0x99000000),
                  child: new Text(
                      "Premium Songs",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Neris',
                        decoration: TextDecoration.none,)),
                )
            ),
          ],
        ),
      ),
    );
  }
}

