import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const String startIcon = 'S';
const String endIcon = 'E';
const String wallIcon = '#';
const String freeIcon = '.';

const minSaving = 100;

final up = Coord(0, -1);
final down = Coord(0, 1);
final left = Coord(-1, 0);
final right = Coord(1, 0);

final directions = [up, right, down, left];

class Maze2 {
  List<List<String>> track = [];
  List<List<int?>> stepCount = [];
  List<List<bool>> onShortest = [];
  var start = Coord(0, 0);
  var end = Coord(0, 0);

  void flood(Coord startPos) {
    List<Coord> robots = [startPos];
    int stepNum = 0;
    while (robots.isNotEmpty) {
      List<Coord> nextRobots = [];
      for (final thisRobot in robots) {
        final icon = track[thisRobot.y][thisRobot.x];
        if (icon == wallIcon) continue;
        if (stepCount[thisRobot.y][thisRobot.x] != null) continue;

        stepCount[thisRobot.y][thisRobot.x] = stepNum;

        if (thisRobot == end) continue;

        for (final perimiter in directions) {
          final neighbour = thisRobot + perimiter;
          nextRobots.add(neighbour);
        }
      }
      stepNum++;
      robots = nextRobots;
    }
  }

  void shortestPath() {
    List<Coord> robots = [end];
    onShortest[end.y][end.x] = true;
    int stepNum = stepCount[end.y][end.x]!;
    while (robots.isNotEmpty) {
      stepNum--;
      List<Coord> nextRobots = [];
      for (final thisRobot in robots) {
        for (final perimiter in directions) {
          final neighbour = thisRobot + perimiter;
          final thisCount = stepCount[neighbour.y][neighbour.x];
          if (thisCount != null && thisCount == stepNum) {
            onShortest[neighbour.y][neighbour.x] = true;
            nextRobots.add(neighbour);
          }
        }
      }
      robots = nextRobots;
    }
  }

  Future<void> loadTrack(Stream<String> lines) async {
    int row = 0;
    stdout.writeln('Loading ...');
    await for (final line in lines) {
      if (line.isEmpty) break;
      final startPos = line.indexOf(startIcon);
      if (startPos > -1) {
        start = Coord(startPos, row);
      }
      final endPos = line.indexOf(endIcon);
      if (endPos > -1) {
        end = Coord(endPos, row);
      }

      track.add(line.split(''));
      onShortest.add(List<bool>.filled(line.length, false));
      stepCount.add(List<int?>.filled(line.length, null));
      row++;
    }

    stdout.writeln('Flooding ...');
    flood(start);

    stdout.writeln('Finding shortest path ...');
    shortestPath();
  }

  Maze2 clone() {
    var newMaze = Maze2();
    newMaze.start = start.clone();
    newMaze.end = end.clone();
    for (int row = 0; row < track.length; row++) {
      newMaze.track.add(List<String>.from(track[row]));
      newMaze.onShortest.add(List<bool>.from(onShortest[row]));
      newMaze.stepCount.add(List<int?>.from(stepCount[row]));
    }
    return newMaze;
  }

  bool betterThan(Coord startPos, int limit) {
    var stepNum = stepCount[startPos.y][startPos.x];
    if (stepNum == null) return false;
    final endCount = stepCount[end.y][end.x];

    List<Coord> robots = [startPos];
    while (robots.isNotEmpty) {
      stepNum = stepNum! + 1;
      if (stepNum == endCount) return false;

      List<Coord> nextRobots = [];
      for (final thisRobot in robots) {
        for (final perimiter in directions) {
          final neighbour = thisRobot + perimiter;
          final icon = track[thisRobot.y][thisRobot.x];
          if (icon == wallIcon) continue;

          final thisCount = stepCount[neighbour.y][neighbour.x];
          if (thisCount == null) {
            stepCount[neighbour.y][neighbour.x] = stepNum;
            nextRobots.add(neighbour);
            continue;
          }

          if (thisCount - stepNum >= limit) {
            return true;
          }
        }
      }
      robots = nextRobots;
    }
    return false;
  }

  int getRoutes(Coord startPoint, int searchSize, int limit) {
    int result = 0;
    final startSteps = stepCount[startPoint.y][startPoint.x];
    if (startSteps == null) return 0;

    for (int dx = -searchSize; dx <= searchSize; dx++) {
      for (int dy = -searchSize; dy <= searchSize; dy++) {
        if (dx.abs() + dy.abs() > searchSize) continue;
        if (dx == 0 && dy == 0) continue;
        final endPoint = startPoint + Coord(dx, dy);
        if (endPoint.x <= 0 ||
            endPoint.x >= track[0].length - 1 ||
            endPoint.y <= 0 ||
            endPoint.y >= track.length - 1) continue;
        if (track[endPoint.y][endPoint.x] == wallIcon) continue;

        final endSteps = stepCount[endPoint.y][endPoint.x];
        if (endSteps == null) continue;

        if (endSteps < startSteps) {
          continue;
        }

        if (endSteps - (startSteps + dx.abs() + dy.abs()) >= limit) {
          result++;
        }
      }
    }

    return result;
  }
}

Future<int> solution1(Stream<String> lines) async {
  var maze = Maze2();
  await maze.loadTrack(lines);

  stdout.writeln(
      'Shortest path with no cheats is ${maze.stepCount[maze.end.y][maze.end.x]!}');

  int result = 0;
  for (int row = 1; row < maze.track.length - 1; row++) {
    for (int col = 1; col < maze.track[0].length - 1; col++) {
      if (maze.track[row][col] != wallIcon) continue;
      final newMaze = maze.clone();
      newMaze.track[row][col] = freeIcon;
      newMaze.stepCount[row][col] = null;

      Coord? startPos;
      int? minSteps;
      for (final dir in directions) {
        final neighbour = Coord(col, row) + dir;
        if (newMaze.track[neighbour.y][neighbour.x] == wallIcon) continue;
        final thisSteps = newMaze.stepCount[neighbour.y][neighbour.x];
        if (thisSteps == null) continue;
        if (minSteps == null || minSteps > thisSteps) {
          minSteps = thisSteps;
          startPos = neighbour;
        }
      }
      if (minSteps == null) continue;

      if (newMaze.betterThan(startPos!, minSaving)) {
        result++;
      }
    }
  }

  return result;
}
