import 'loading_screen_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

/// Loading Screen Widget that updates the screen once all inistializer methods
/// are called
class LoadingScreen extends StatefulWidget {
  /// List of methods that are called once the Loading Screen is rendered
  /// for the first time. These are the methods that can update the messages
  /// that are shown under the loading symbol
  final List<dynamic> initializers;

  /// The name of the application that is shown at the top of the loading screen

  /// The background colour which is used as a filler when the image doesn't
  /// occupy the full screen
  final Color backgroundColor;

  /// The Layout/Scaffold Widget that is loaded once all the initializer methods
  /// have been executed
  final dynamic navigateToWidget;

  /// The colour that is used for the loader symbol
  final Color loaderColor;

  /// The image widget that is used as a background cover to the loading screen
  final Image image;

  /// The message that is displayed on the first load of the widget
  final String initialMessage;

  /// Constructor for the LoadingScreen widget with all the required
  /// initializers
  LoadingScreen(
      {this.initializers,
        this.navigateToWidget,
        this.loaderColor,
        this.image,
        this.backgroundColor = Colors.white,

        this.initialMessage})

      : assert(initializers != null && initializers.length > 0),
        assert(navigateToWidget != null);

  /// Bind the Widget to the custom State object
  @override
  LoadingScreenState createState() => LoadingScreenState();
}