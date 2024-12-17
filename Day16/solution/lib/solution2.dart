import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';
import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var maze = Maze();
  await maze.getMaze(lines);

  maze.calcBestRoute();

  stdout.writeln('Best score is ${maze.bestScore}');

  maze.followMinimum(MoveState(maze.end, 0, 0, [maze.end]));
  Set<Coord> uniqueSpaces = {};
  for (final path in maze.bestPaths) {
    for (final space in path) {
      uniqueSpaces.add(space);
    }
  }
  return uniqueSpaces.length;
}
