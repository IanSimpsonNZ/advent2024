import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';
import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var maze = Maze2();
  await maze.loadTrack(lines);

  stdout.writeln(
      'Shortest path with no cheats is ${maze.stepCount[maze.end.y][maze.end.x]!}');

  int result = 0;
  for (int row = 1; row < maze.track.length - 1; row++) {
    for (int col = 1; col < maze.track[0].length - 1; col++) {
      if (maze.track[row][col] == wallIcon) continue;
      result += maze.getRoutes(Coord(col, row), 20, 100);
    }
  }

  return result;
}
