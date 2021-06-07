import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Chart
{
  var myFile;
  var isDone = false;
  var resolution = 192;
  List<List<int>> noteList = new List();
  List<List<int>> bpmChanges = new List();

  Future<String> getString() async
  {
    String chartString = "";
    try { chartString = await rootBundle.loadString(
          'assets/files/notes.chart'); }
    catch (e) {
    //DONOTHING
    }
  return chartString;
  }

  parseChart() async {
    getString().then((chartString) {
      var isParsingSong = false;
      var isParsingSyncTrack = false;
      var isParsingExpertSingle = false;

      List<String> linesOfChart = chartString.split("\n");

      for (int i = 0; i < linesOfChart.length; i++) {
        String contents = linesOfChart[i].toString().trim();

        if (contents == "[Song]") {
          isParsingSong = true;
        }
        else if (isParsingSong) {
          if (contents == "}") {
            isParsingSong = false;
          }
          else if (contents != "{") {
            var splitContents = contents.split(" ");
            if (splitContents[0] == "Resolution") {
              resolution = int.parse(splitContents[2]);
            }
          }
        }
        else if (contents == "[SyncTrack]")
          isParsingSyncTrack = true;
        else if (isParsingSyncTrack) {
          if (contents == "}") {
            isParsingSyncTrack = false;
          }
          else if (contents != "{") {
            var splitContents = contents.split(" ");
            if (splitContents[2] == "B")
              bpmChanges.add(
                  [int.parse(splitContents[0]), int.parse(splitContents[3])]);
          }
        }
        else if (contents == "[ExpertSingle]")
          isParsingExpertSingle = true;
        else if (isParsingExpertSingle) {
          if (contents == "}") {
            isParsingExpertSingle = false;
            return;
          }
          else if (contents != "{") {
            var splitContents = contents.split(" ");
            if (splitContents[2] == "N") {
              noteList.add(
                  [int.parse(splitContents[0]), int.parse(splitContents[3])]);
            }
          }
        }
      }
    });
  }

    List<List<int>> getNoteList() {
      return noteList;
    }

    List<List<int>> getBPM() {
      return bpmChanges;
    }
}