import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'loadingScreen.dart';
import 'message_state.dart';
import 'GamePage.dart';
import 'GetChart.dart';
import 'dart:async' show Future;

class Transition extends StatefulWidget {
  @override
  LoadingScreenExampleState createState() => LoadingScreenExampleState();
}

class LoadingScreenExampleState extends State<Transition> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingScreen(
          initializers: <dynamic> [InitializerTest.initializeChart],
          navigateToWidget: 'GamePage',
          loaderColor: Colors.white,
          image: Image.asset('assets/images/one.jpg', fit: BoxFit.cover,),
          backgroundColor: Colors.black,
        ));
  }
}

//toDO ----------------------- PARSING OF CHART -------------------------------
//toDo ------------------------------------------------------------------------
//toDo ------------------------------------------------------------------------

class InitializerTest {
  static Future timer(MessageState state) async {
    await Future.delayed(Duration(seconds: 5), () {
      state.setMessage = "Get Ready";
    });
  }

  static Future<List<List<double>>> initializeChart(MessageState state) async {
    GetChart gt = new GetChart("od", true);
    await gt.initializationDone;
    state.setMessage = "Get Ready";
    return gt.finalNoteList;
  }
}


