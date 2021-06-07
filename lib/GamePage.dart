import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Colors, runApp;
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'GetChart.dart';


const SPEED = 400.0;
const CRATE_SIZE_LENGTH = 104.0;
const NOTE_SIZE_LENGTH = CRATE_SIZE_LENGTH / 2;
const NOTE_SIZE_HEIGHT = 62.0;
const BOX_SIZE_HEIGHT = 100.0;
const MISS_DEDUCTION = 0;
var screenHeight;
var screenWidth;

StreamSubscription periodicSub;


var resolution = 192;
var currentBPM = 120000;
var currentTS = 4;

//
var seconds = 0.0;
var notes;
var times1 = 0;
var previousNote12 = 0;
var previousNote22 = 0;
bool addMiss = false;
bool paused = false;

TextConfig textConfig = TextConfig(
  color: Colors.white,
  fontSize: 48.0,
  fontFamily: 'Halo',
);

class GamePage extends StatelessWidget{

  BuildContext context1;
  MyGame game;
  List<List<double>> a1;

  GamePage(List<List<double>> a)
  {
    a1 = a;
  }

  Future<bool> _onWillPop() {

    game.pause();

    return showDialog(
      context: context1,
      barrierDismissible: false,
      builder: (context1) => new Theme(
      data: Theme.of(context1).copyWith(dialogBackgroundColor: Colors.black),
        child: AlertDialog(
        title: new Text('Paused.'),
        content: new Text('Do you want to exit the Game?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 5,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'Neris',
              decoration: TextDecoration.none,)),
        actions: <Widget>[
          new FlatButton(
            child: new Text("No",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Neris',
                  decoration: TextDecoration.none,)),
            color: Colors.deepPurpleAccent,
            onPressed: ()
            {
            Navigator.of(context1).pop(false);
            game.resume();
            }
          ),
          new FlatButton(
            color: Colors.green,
            onPressed: () {
              Navigator.of(context1).pop(true);
              periodicSub = new Stream.periodic(const Duration(milliseconds: 1000)).take(1).listen((_) {
                return true;
              }
              );
            },
            child: new Text("Yes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Neris',
                  decoration: TextDecoration.none,)),
          ),
        ],
      ),
    ) ?? false,
    );
  }

  @override
  Widget build(BuildContext context){
    context1 = context;
    Flame.images.loadAll(['explosion.png', 'crate.png', 'one_box-01.png', 'two_box-01.png', 'three_box-01.png', 'four_box-01.png', 'white_box-01.png']);
    game = new MyGame(a1);

    Flame.util.addGestureRecognizer(new MultiTapGestureRecognizer()
      ..onTapDown = (int pointer, TapDownDetails evt) => game.input(evt.globalPosition));

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: game.widget
        );
  }
}

//todo------------------------CLASS MYGAME DECLARATION-------------------------

class MyGame extends BaseGame {
  int index = 0;
  double creationTimer = 0.000000;
  var alreadyRendered = false;
  ListQueue<OneNote> oneQ;
  ListQueue<TwoNote> twoQ;
  ListQueue<ThreeNote> threeQ;
  ListQueue<FourNote> fourQ;
  List<List<double>> a1;
  int currentOne;
  int currentTwo;
  int currentThree;
  int currentFour;


  MyGame(List<List<double>> a)
  {
    a1 = a;
    oneQ = new ListQueue<OneNote>();
    twoQ = new ListQueue<TwoNote>();
    threeQ = new ListQueue<ThreeNote>();
    fourQ = new ListQueue<FourNote>();
    currentOne = currentTwo = currentThree = currentFour = 0;
  }

  @override
  void render(Canvas canvas) {

    if (!alreadyRendered)
    {
      screenHeight = size.height + 800;
      screenWidth = size.height;
      add(new OneBox());
      add(new TwoBox());
      add(new ThreeBox());
      add(new FourBox());
    }

    if(addMiss)
    {
      add(new Reject());
      addMiss = false;
    }

    super.render(canvas);
    String text = points.toString();
    textConfig.render(
        canvas, text, Position((size.width / 2) - (text.length * 12.5), 16));
    alreadyRendered = true;
  }

  //toDo---------------------------UPDATE--------------------------------------

  @override
  void update(double t) {
    creationTimer += t;
    //if (double.parse(creationTimer.toStringAsFixed(1))
        //== double.parse(a1.elementAt(index).elementAt(0).toStringAsFixed(1))) {
      if((creationTimer - a1.elementAt(index).elementAt(0)).abs() < 0.05){
      var theone = a1.elementAt(index).elementAt(1).toInt();

      if (theone == 0 || theone == 7) {
        add(new OneNote(currentOne));
        oneQ.add(new OneNote(currentOne));
        currentOne+=1;
      }
      else if (theone == 1) {
        add(new TwoNote(currentTwo));
        twoQ.add(new TwoNote(currentTwo));
        currentTwo+=1;
      }
      else if (theone == 2) {
        add(new ThreeNote(currentThree));
        threeQ.add(new ThreeNote(currentThree));
        currentThree+=1;
      }
      else if(theone == 3)
        {
          add(new FourNote(currentFour));
          fourQ.add(new FourNote(currentFour));
          currentFour+=1;
        }
      else if (theone == 4) {
        add(new FourNote(currentFour));
        fourQ.add(new FourNote(currentFour));
        currentFour+=1;
      }
      else if (theone == 12) {
        add(new OneNote(currentOne)); add(new TwoNote(currentTwo));
        oneQ.add(new OneNote(currentOne)); twoQ.add(new TwoNote(currentTwo));
        currentOne+=1;
        currentTwo+=1;
      }
      else if (theone == 13) {
        add(new OneNote(currentOne)); add(new ThreeNote(currentThree));
        oneQ.add(new OneNote(currentOne)); threeQ.add(new ThreeNote(currentThree));
        currentOne+=1;
        currentThree+=1;
      }
      else if (theone == 14) {
        add(new OneNote(currentOne)); add(new FourNote(currentFour));
        oneQ.add(new OneNote(currentOne)); fourQ.add(new FourNote(currentFour));
        currentOne+=1;
        currentFour+=1;
      }
      else if (theone == 23) {
        add(new TwoNote(currentTwo)); add(new ThreeNote(currentThree));
        twoQ.add(new TwoNote(currentTwo)); threeQ.add(new ThreeNote(currentThree));
        currentTwo+=1;
        currentThree+=1;
      }
      else if (theone == 24) {
        add(new TwoNote(currentTwo)); add(new FourNote(currentFour));
        twoQ.add(new TwoNote(currentTwo)); fourQ.add(new FourNote(currentFour));
        currentTwo+=1;
        currentFour+=1;
      }
      else if (theone == 34) {
        add(new ThreeNote(currentThree)); add(new FourNote(currentFour));
        threeQ.add(new ThreeNote(currentThree)); fourQ.add(new FourNote(currentFour));
        currentThree+=1;
        currentFour+=1;
      }
      else if(theone == 123){
        add(new OneNote(currentOne)); add(new TwoNote(currentTwo)); add(new ThreeNote(currentThree));
        oneQ.add(new OneNote(currentOne)); twoQ.add(new TwoNote(currentTwo)); threeQ.add(new ThreeNote(currentThree));
        currentOne+=1;
        currentTwo+=1;
        currentThree+=1;

      }
      else if(theone == 124)
      {
        add(new OneNote(currentOne)); add(new TwoNote(currentTwo)); add(new FourNote(currentFour));
        oneQ.add(new OneNote(currentOne)); twoQ.add(new TwoNote(currentTwo)); fourQ.add(new FourNote(currentFour));
        currentOne+=1;
        currentTwo+=1;
        currentFour+=1;
      }
      else if(theone == 134){
        add(new OneNote(currentOne)); add(new ThreeNote(currentThree)); add(new FourNote(currentFour));
        oneQ.add(new OneNote(currentOne)); threeQ.add(new ThreeNote(currentThree)); fourQ.add(new FourNote(currentFour));
        currentOne+=1;
        currentThree+=1;
        currentFour+=1;
      }
      else if(theone == 234){
        add(new TwoNote(currentTwo)); add(new ThreeNote(currentThree)); add(new FourNote(currentFour));
        twoQ.add(new TwoNote(currentTwo)); threeQ.add(new ThreeNote(currentThree)); fourQ.add(new FourNote(currentFour));
        currentTwo+=1;
        currentThree+=1;
        currentFour+=1;
      }

      index = index + 1;
      if(index == a1.length)
        index = 0;
    }

    super.update(t);
  }

  void input(Offset position) {

    var noteYtop = size.height - (BOX_SIZE_HEIGHT * 2);
    var noteYbottom = size.height - (BOX_SIZE_HEIGHT * .1);
    bool at1 = false;
    bool at2 = false;
    bool at3 = false;
    bool at4 = false;

    components.forEach((component) {

      if(component is FourNote) {
        FourNote note = component as FourNote;
        bool remove = ((position >= Offset((size.width - (size.width / 8.0) - (CRATE_SIZE_LENGTH / 2)), noteYtop))
            && (position < Offset((size.width - (size.width / 8.0) + (CRATE_SIZE_LENGTH / 2)), noteYbottom))
            && (note.y  >= noteYtop)
            && (note.y  < noteYbottom));
        if (remove && !at1) {
          note.explode = true;
          at1 = true;
          add(new Accept(note));
         // add(new Explosion(note));
          //Flame.audio.play('explosion.mp3');
          points += 1;
          return;
        }
      }

      if(component is OneNote) {
        OneNote note = component as OneNote;
        bool remove = ((position >= Offset(((size.width / 8.0) - (CRATE_SIZE_LENGTH / 2)), noteYtop))
            && (position < Offset(((size.width / 8.0) + (CRATE_SIZE_LENGTH / 2)), noteYbottom))
            && (note.y  >= noteYtop)
            && (note.y  < noteYbottom));
        if (remove && !at2) {
          note.explode = true;
          at2 = true;
          add(new Accept(note));
        //  add(new Explosion(note));
          //Flame.audio.play('explosion.mp3');
          points += 1;
          return;
        }
      }

      if(component is TwoNote) {
        TwoNote note = component as TwoNote;
        bool remove = ((position >= Offset((size.width - (size.width / 8.0 * 5) - (CRATE_SIZE_LENGTH / 2)), noteYtop))
            && (position < Offset((size.width - (size.width / 8.0 * 5) + (CRATE_SIZE_LENGTH / 2)), noteYbottom))
            && (note.y  >= noteYtop)
            && (note.y  < noteYbottom));
        if (remove && !at3) {
          note.explode = true;
          at3 = true;
          add(new Accept(note));
         // add(new Explosion(note));
          //Flame.audio.play('explosion.mp3');
          points += 1;
          return;
        }
      }

      if(component is ThreeNote) {
        ThreeNote note = component as ThreeNote;
        bool remove = ((position >= Offset((size.width - (size.width / 8.0 * 3) - (CRATE_SIZE_LENGTH / 2)), noteYtop))
            && (position < Offset((size.width - (size.width / 8.0 * 3) + (CRATE_SIZE_LENGTH / 2)), noteYbottom))
            && (note.y  >= noteYtop)
            && (note.y  < noteYbottom));
        if (remove && !at4) {
          note.explode = true;
          at4 = true;
          add(new Accept(note));
        //  add(new Explosion(note));
          //Flame.audio.play('explosion.mp3');
          points += 1;
          return;
        }
      }
    });

  }
}

//todo------------------------------------OneBox-----------------------------

class OneBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  OneBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT, 'one_box-01.png');

  @override
  void resize(Size size) {
    this.x = ((size.width / 8.0) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height - (BOX_SIZE_HEIGHT * 1.25);
  }
}

//todo------------------------------------TwoBox-----------------------------

class TwoBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  TwoBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT, 'two_box-01.png');

  @override
  void resize(Size size) {
    this.x = (size.width - ((size.width / 8.0) * 5) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height - (BOX_SIZE_HEIGHT * 1.25);
  }
}

//todo------------------------------------ThreeBox---------------------------

class ThreeBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  ThreeBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT, 'three_box-01.png');

  @override
  void resize(Size size) {
    this.x = (size.width - ((size.width / 8.0) * 3) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height - (BOX_SIZE_HEIGHT * 1.25);
  }
}

//todo------------------------------------FourBox----------------------------

class FourBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  FourBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT, 'four_box-01.png');

  @override
  void resize(Size size) {
    this.x = (size.width - ((size.width / 8.0)) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height - (BOX_SIZE_HEIGHT * 1.25);
  }
}

/*todo------------------------------------FiveBox----------------------------

class FiveBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  FiveBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT, 'five_box-01.png');

  @override
  void resize(Size size) {
    this.x = ((size.width / 2.0) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height / 2 - (BOX_SIZE_HEIGHT / 2) - 2 ;
  }
}

//todo------------------------------------SixBox----------------------------

class SixBox extends SpriteComponent {
  bool explode = false;
  double maxY;

  SixBox() : super.rectangle(CRATE_SIZE_LENGTH, BOX_SIZE_HEIGHT,'six_box-01.png');

  @override
  void resize(Size size) {
    this.x = (size.width - (size.width / 6.0) - (CRATE_SIZE_LENGTH / 2));
    this.y = size.height / 2 - (BOX_SIZE_HEIGHT / 2) - 2;
  }
}*/

//todo------------------------------------FIRST NOTE------------------------------------

//todo------------------------------------FIRST NOTE----------------------------------

class OneNote extends SpriteComponent {
  bool explode = false;
  double maxY;
  int curr;

  OneNote(curr1) : curr = curr1, super.rectangle(NOTE_SIZE_LENGTH, NOTE_SIZE_HEIGHT, 'white_box_green-01.png');

  @override
  void update(double t) {
    y += t * SPEED;
  }

  @override
  bool destroy() {
    if (explode) {
      return true;
    }
    if (y == null || maxY == null) {
      return false;
    }
    bool destroy = y >= maxY;
    if (destroy) {
      addMiss = true;
      //points -= MISS_DEDUCTION;
      //Flame.audio.play('miss.mp3');
    }
    return destroy;
  }

  @override
  void resize(Size size) {
    this.x = ((size.width / 8.0) - (NOTE_SIZE_LENGTH / 2));
    this.y = 40;
    this.maxY = (size.height) - (NOTE_SIZE_HEIGHT * 0.5);
  }
}

//todo------------------------------------SECOND NOTE-----------------------------------

class TwoNote extends SpriteComponent {

  bool explode = false;
  double maxY;
  int curr;

  TwoNote(curr1) : curr = curr1, super.rectangle(NOTE_SIZE_LENGTH, NOTE_SIZE_HEIGHT, 'white_box_red-01.png');

  @override
  void update(double t) {
    y += t * SPEED;
  }

  @override
  bool destroy() {
    if (explode) {
      return true;
    }
    if (y == null || maxY == null) {
      return false;
    }
    bool destroy = y >= maxY;
    if (destroy) {
      addMiss = true;
      //points -= MISS_DEDUCTION;
      //Flame.audio.play('miss.mp3');
    }
    return destroy;
  }

  @override
  void resize(Size size) {
    this.x = (size.width - ((size.width / 8.0) * 5) - (NOTE_SIZE_LENGTH / 2));
    this.y = 40;
    this.maxY = (size.height) - (NOTE_SIZE_HEIGHT * 0.5);
  }
}

//todo------------------------------------THIRD NOTE-----------------------------------

class ThreeNote extends SpriteComponent {

  bool explode = false;
  double maxY;
  int curr;

  ThreeNote(curr1) : curr = curr1, super.rectangle(NOTE_SIZE_LENGTH, NOTE_SIZE_HEIGHT, 'white_box_yellow-01.png');

  @override
  void update(double t) {
    y += t * SPEED;
  }

  @override
  bool destroy() {
    if (explode) {
      return true;
    }
    if (y == null || maxY == null) {
      return false;
    }
    bool destroy = y >= maxY;
    if (destroy) {
      addMiss = true;
      //points -= MISS_DEDUCTION;
      //Flame.audio.play('miss.mp3');
    }
    return destroy;
  }

  @override
  void resize(Size size) {
    this.x = (size.width - ((size.width / 8.0) * 3) - (NOTE_SIZE_LENGTH / 2));
    this.y = 40;
    this.maxY = (size.height) - (NOTE_SIZE_HEIGHT * 0.5);
  }
}

//TODO-----------------------------FOURTH NOTE-----------------------------------------------------------

class FourNote extends SpriteComponent {
  bool explode = false;
  double maxY;
  int curr;

  FourNote(curr1) : curr = curr1, super.rectangle(NOTE_SIZE_LENGTH, NOTE_SIZE_HEIGHT, 'white_box_blue-01.png');

  @override
  void update(double t) {
    y += t * SPEED;
  }

  @override
  bool destroy() {
    if (explode) {
      return true;
    }
    if (y == null || maxY == null) {
      return false;
    }
    bool destroy = y >= maxY;
    if (destroy) {
      addMiss = true;
      //points -= MISS_DEDUCTION;
      //Flame.audio.play('miss.mp3');
    }
    return destroy;
  }

  @override
  void resize(Size size) {
    this.x = (size.width - (size.width / 8.0) - (NOTE_SIZE_LENGTH / 2));
    this.y = 40.0;
    this.maxY = (size.height) - (NOTE_SIZE_HEIGHT * 0.5);
  }
}

//TODO-----------------------------END NOTES-----------------------------------------------------------


class Explosion extends AnimationComponent {
  static const TIME = 0.75;

  Explosion(SpriteComponent crate) : super.sequenced(NOTE_SIZE_LENGTH + 20, NOTE_SIZE_HEIGHT + 80, 'explosion.png', 23, textureWidth: 31.0, textureHeight: 31.0) {
    this.x = crate.x;
    this.y = crate.y;
    this.animation.stepTime = TIME / 30;
  }

  bool destroy() {
    return this.animation.isLastFrame;
  }
}

class Accept extends AnimationComponent {
  static const TIME = 1.0;

  Accept(SpriteComponent crate) : super.sequenced(NOTE_SIZE_LENGTH, screenHeight, 'accept.png', 23, textureWidth: 31.0, textureHeight: 31.0) {
    this.x = crate.x;
    this.y = 0;
    this.animation.stepTime = TIME / 30;
  }

  bool destroy() {
    return this.animation.isLastFrame;
  }
}

class Reject extends AnimationComponent {
  static const TIME = 0.5;

  Reject() : super.sequenced(screenWidth, screenHeight, 'reject.png', 23, textureWidth: 31.0, textureHeight: 31.0) {
    this.x = 0;
    this.y = 0;
    this.animation.stepTime = TIME / 30;
  }

  bool destroy() {
    return this.animation.isLastFrame;
  }
}


class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

/*class Song {

  Notes st;

  Song(){
  }

}*/



/*import 'package:flutter/material.dart';
import 'package:open_rhythm/HomePage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(),
    );
  }
}*/
