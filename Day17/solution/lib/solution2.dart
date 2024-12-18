// import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var threeBit = Computer();
  await threeBit.loadProg(lines);

  threeBit.breakpoint = 12;

  List<int> possibleA = [0];
  for (final target in threeBit.mem.reversed) {
    List<int> nextPossibles = [];
    for (final restOfA in possibleA) {
      var results = List<int>.filled(8, 0);
      for (int a = 0; a < 8; a++) {
        threeBit.reset();
        threeBit.A = restOfA * 8 + a;
        threeBit.execute();
        results[a] = threeBit.output[0];
      }

      for (int i = 0; i < results.length; i++) {
        if (results[i] == target) {
          nextPossibles.add(restOfA * 8 + i);
        }
      }
    }
    possibleA = nextPossibles;
  }

  String progStr = '';
  for (final inst in threeBit.mem) {
    progStr += '$inst,';
  }
  progStr = progStr.substring(0, progStr.length - 1);

  threeBit.breakpoint = -1;

  int result = 0;

  for (final scenario in possibleA) {
    threeBit.reset();
    threeBit.A = scenario;
    threeBit.execute();
    if (threeBit.printOut() == progStr) {
      result = scenario;
      break;
    }
  }

  return result;
}
