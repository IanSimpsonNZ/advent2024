// import 'dart:io';
import 'dart:io';

import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';
import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var map = MemoryMap(71);
  await map.getBytes(lines, 1024);

  map.calcMinSteps();

  Coord? finalStraw;

  while (finalStraw == null) {
    final newByte = map.allTheBytes[map.nextByte];
    map.nextByte++;
    map.memCorrupt[newByte.y][newByte.x] = true;

    if (map.bestPath.contains(newByte)) {
      map.reset();
      map.calcMinSteps();
      if (map.bestPath.isEmpty) {
        finalStraw = newByte;
      }
    }
  }

  stdout.writeln('The answer is $finalStraw');

  return 0;
}
