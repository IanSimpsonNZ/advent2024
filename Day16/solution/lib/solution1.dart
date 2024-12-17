import 'dart:io';

import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

final north = Coord(0, -1);
final south = Coord(0, 1);
final east = Coord(1, 0);
final west = Coord(-1, 0);

final directions = [east, north, west, south];

const moveCost = 1;
const turnCost = 1000;

class MoveState {
  final Coord position;
  final int direction;
  final int costSoFar;
  List<Coord> path;

  MoveState(this.position, this.direction, this.costSoFar, this.path);

  @override
  bool operator ==(Object other) =>
      other is MoveState &&
      position == other.position &&
      direction == other.direction;
  @override
  int get hashCode => Object.hash(position, direction);

  List<Coord> _copyPath() {
    List<Coord> newPath = [];
    for (final step in path) {
      newPath.add(step.clone());
    }
    return newPath;
  }

  MoveState forward() {
    return MoveState(position + directions[direction], direction,
        costSoFar + moveCost, _copyPath());
  }

  MoveState turnLeft() {
    return MoveState(position.clone(), (direction + 1) % directions.length,
        costSoFar + turnCost, _copyPath());
  }

  MoveState turnRight() {
    return MoveState(position.clone(), (direction - 1) % directions.length,
        costSoFar + turnCost, _copyPath());
  }

  @override
  String toString() {
    return '$position:$direction:$costSoFar';
  }

  MoveState clone() {
    return MoveState(position.clone(), direction, costSoFar, _copyPath());
  }
}

class CostByDirection {
  List<int?> cost = [null, null, null, null];

  CostByDirection clone() {
    var newCBD = CostByDirection();
    for (int i = 0; i < cost.length; i++) {
      newCBD.cost[i] = cost[i];
    }
    return newCBD;
  }

  @override
  String toString() {
    String result = '[';
    for (final c in cost) {
      result += '$c, ';
    }
    return '$result]';
  }
}

class Maze {
  List<String> maze = [];
  List<List<CostByDirection>> minCost = [];
  Coord start = Coord(-1, -1);
  Coord end = Coord(-1, -1);
  List<List<bool>> beenhere = [];
  List<List<Coord>> bestPaths = [];

  int bestScore = 0;

  static const endIcon = 'E';
  static const startIcon = 'S';
  static const wallIcon = '#';
  static const freeIcon = '.';

  Future<void> getMaze(Stream<String> lines) async {
    int rowNum = 0;
    maze = [];
    await for (final line in lines) {
      if (line.isEmpty) break;

      final ePos = line.indexOf(endIcon);
      if (ePos > -1) {
        end = Coord(ePos, rowNum);
      }

      final sPos = line.indexOf(startIcon);
      if (sPos > -1) {
        start = Coord(sPos, rowNum);
      }

      maze.add(line);
      minCost.add([]);
      for (int i = 0; i < line.length; i++) {
        minCost[rowNum].add(CostByDirection());
      }
      beenhere.add(List<bool>.filled(line.length, false));
      rowNum++;
    }

    assert(start.x > -1);
    assert(end.x > -1);
  }

  int? calcBestRoute() {
    stdout.writeln('Starting at $start');
    int? result;
    List<MoveState> nextSquares = [
      MoveState(start, 0, 0, [start])
    ];

    while (nextSquares.isNotEmpty) {
      List<MoveState> andTheNext = [];

      for (final startPos in nextSquares) {
        final thisIcon = maze[startPos.position.y][startPos.position.x];
        if (thisIcon == endIcon) {
          if (result == null || result >= startPos.costSoFar) {
            result = startPos.costSoFar;
            continue;
          }
        }

        if (!(thisIcon == freeIcon || thisIcon == startIcon)) continue;

        final currentCosts =
            minCost[startPos.position.y][startPos.position.x].clone();

        // Continue straight
        var ahead = startPos.clone();
        final currentAheadCost = currentCosts.cost[ahead.direction];
        if (currentAheadCost == null || currentAheadCost > ahead.costSoFar) {
          minCost[ahead.position.y][ahead.position.x].cost[ahead.direction] =
              ahead.costSoFar;
          ahead = ahead.forward();
          ahead.path.add(ahead.position);
          andTheNext.add(ahead);
        }

        // Turn left
        var left = startPos.turnLeft();
        final currentLeftCost = currentCosts.cost[left.direction];
        if (currentLeftCost == null || currentLeftCost > left.costSoFar) {
          minCost[left.position.y][left.position.x].cost[left.direction] =
              left.costSoFar;
          left = left.forward();
          left.path.add(left.position);
          andTheNext.add(left);
        }

        // Turn right
        var right = startPos.turnRight();
        final currentRightCost = currentCosts.cost[right.direction];
        if (currentRightCost == null || currentRightCost > right.costSoFar) {
          minCost[right.position.y][right.position.x].cost[right.direction] =
              right.costSoFar;
          right = right.forward();
          right.path.add(right.position);
          andTheNext.add(right);
        }

        // Reverse direction
        var turn180 = startPos.turnRight().turnRight();
        final current180Cost = currentCosts.cost[turn180.direction];
        if (current180Cost == null || current180Cost > turn180.costSoFar) {
          minCost[turn180.position.y][turn180.position.x]
              .cost[turn180.direction] = turn180.costSoFar;
          turn180 = turn180.forward();
          turn180.path.add(turn180.position);
          andTheNext.add(turn180);
        }
      }
      nextSquares = andTheNext;
    }

    bestScore = result!;
    return bestScore;
  }

  void print() {
    for (int row = 0; row < maze.length; row++) {
      stdout.writeln(minCost[row]);
    }
  }

  void followMinimum(MoveState fromState) {
    final lastCoord = fromState.position;

    if (lastCoord == start) {
      bestPaths.add(fromState.path);
      return;
    }

    // Here we are using MoveState as ...
    // position - cell we came from
    // direction - which direction we originally entered that cell - so left this cell from opposite side
    //           - used to calculate turn costs
    // path - trip so far
    //
    // if prev cell is "End" we don't care which direction we entered that cell

    final perimiter = directions.map((d) => lastCoord + d).toList();

    final bigDefault = bestScore + 1000;
    var turnCostToExit = List<int>.filled(perimiter.length, 0);

    if (lastCoord != end) {
      for (int d = 0; d < perimiter.length; d++) {
        if (fromState.direction == d) {
          // we're lined up - default 0
          continue;
        } else if ((fromState.direction - d).abs() % 2 == 1) {
          // left or right
          turnCostToExit[d] = turnCost;
        } else {
          // 180
          turnCostToExit[d] = turnCost * 2;
        }
      }
    }

    int minCostToGetHere = bigDefault;

    for (int d = 0; d < perimiter.length; d++) {
      if (maze[perimiter[d].y][perimiter[d].x] == wallIcon) continue;
      // to get cost from south, get south's cost to north
      final costToGetHere = minCost[perimiter[d].y][perimiter[d].x]
          .cost[(d + 2) % perimiter.length];
      if (costToGetHere == null) continue;
      if (costToGetHere + turnCostToExit[d] < minCostToGetHere) {
        minCostToGetHere = costToGetHere + turnCostToExit[d];
      }
    }
    if (minCostToGetHere == bigDefault) return;

    List<MoveState> minSteps = [];
    for (int d = 0; d < perimiter.length; d++) {
      if (maze[perimiter[d].y][perimiter[d].x] == wallIcon) continue;
      // to get cost from south, get south's cost to north
      final costToGetHere = minCost[perimiter[d].y][perimiter[d].x]
          .cost[(d + 2) % perimiter.length];
      if (costToGetHere == null) continue;
      if (costToGetHere + turnCostToExit[d] == minCostToGetHere) {
        minSteps.add(
            MoveState(perimiter[d], d, 0, fromState.path + [perimiter[d]]));
      }
    }
    if (minSteps.isEmpty) return;

    for (final nextStep in minSteps) {
      followMinimum(nextStep);
    }
  }
}

Future<int> solution1(Stream<String> lines) async {
  var maze = Maze();
  await maze.getMaze(lines);

  final result = maze.calcBestRoute();

  return result!;
}
