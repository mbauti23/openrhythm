import 'package:flutter/services.dart' show rootBundle;
import 'package:collection/equality.dart';

class GetChart{
  Future _doneFuture;
  String myStr;
  var myFile;
  int resolution = 192;
  double lastTick = 0;
  double lastTimeInSeconds = 0;
  List<List<double>> noteList = new List();
  List<List<double>> finalNoteList = new List();
  List<List<double>> bpmChanges = new List();
  List<List<List<double>>> duplicateNoteList =
  [
  [[0,1],[12]],
  [[0,2],[13]],
  [[0,3],[14]],
  [[0,4],[14]],
  [[0,1,2],[123]],
  [[0,1,3],[124]],
  [[0,1,4],[124]],
  [[0,2,3],[134]],
  [[0,2,4],[124]],
  [[0,3,4],[134]],
  [[0,1,2,3],[1234]],
  [[0,2,3,4],[1234]],
  [[0,1,2,3,4],[1234]],
  [[1,2],[23]],
  [[1,3],[24]],
  [[1,4],[24]],
  [[1,2,4],[134]],
  [[1,3,4],[234]],
  [[1,2,3,4],[1234]],
  [[1,2,3],[234]],
  [[2,3],[14]],
  [[2,4],[13]],
  [[2,3,4],[234]],
  [[3,4],[34]],
  ];

  GetChart(String str, bool shouldClear)
  {
    myStr = str;

    if(shouldClear)
    {
      noteList.clear();
      bpmChanges.clear();
    }

    _doneFuture = getLines();
  }

  Future<String> getString() async
  {
    String chartString = "";
    try {
      chartString = await rootBundle.loadString(
          'assets/files/' + myStr +  '.chart');
    }
    catch (e) {
      print('No file found: $e');
    }
    return chartString;
  }

  Future parseChart() async {

    await getString().then((chartString) {

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
                  [double.parse(splitContents[0]), double.parse(splitContents[3])]);
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
              if(int.parse(splitContents[3]) != 5 && int.parse(splitContents[3]) != 6)
                noteList.add([findMs(double.parse(splitContents[0])),
                double.parse(splitContents[3])]);
            }
          }
        }
      }
    });
  }

  double findMs(double d){

    try {

        int currentBpmIndex = 0;

        while((currentBpmIndex != bpmChanges.length - 1) && (d >= bpmChanges.elementAt(currentBpmIndex + 1).elementAt(0)))
        {
         print("CURRENTBPMCHANGELOOP : " + currentBpmIndex.toString());
         currentBpmIndex++;
        }


      double bpm = bpmChanges.elementAt(currentBpmIndex).elementAt(1);

      double nextSec = ((60000 / bpm) *
          ((d - lastTick) / resolution) + lastTimeInSeconds);

      lastTick = d;
      lastTimeInSeconds = nextSec;

      return (nextSec);
    }catch(Error){

    }
  }

  Future get initializationDone => _doneFuture;

  double findDuplicate(List<double> dups)
  {
    for(List<List<double>> t in duplicateNoteList) {
      if (ListEquality().equals(dups, t.elementAt(0))) {
        return t.elementAt(1).elementAt(0);
      }
    }
    return -1;
  }

  Future getLines() async {
    await parseChart().then((d) {
      try {
        for (int i = 0; i <= noteList.length; i++) {
          List<double> dups = new List<double>();
          if (i == noteList.length - 1)
            finalNoteList.add(noteList.elementAt(i));
          else {
            bool hasNoDupes = false;
            dups.add(noteList.elementAt(i).elementAt(1));
            for (int j = i + 1; j < noteList.length; j++) {
              if (noteList.elementAt(i).elementAt(0)
                  == noteList.elementAt(j).elementAt(0)) {
                dups.add(noteList.elementAt(j).elementAt(1));
              }
              else {
                if (dups.length > 1) {
                  finalNoteList.add(
                      [noteList.elementAt(i).elementAt(0), findDuplicate(dups)
                      ]);
                  i = j-1;
                  j = noteList.length;
                }
                else {
                  j = noteList.length;
                  hasNoDupes = true;
                }
              }
            }
            if(hasNoDupes) {
              if(noteList.elementAt(i+1).elementAt(1) == 7
                  && noteList.elementAt(i).elementAt(1) == 0)
                finalNoteList.add([noteList.elementAt(i).elementAt(0), 1]);
              else
                finalNoteList.add(noteList.elementAt(i));
            }
          }
        }
      } catch(Error){

      }

    });
}
}

