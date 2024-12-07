// import 'dart:io';

import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const String guardIcon = '^';
const String barrierIcon = '#';
const String spaceIcon = '.';

final List<Coord> directions = [
  Coord(0, -1),
  Coord(1, 0),
  Coord(0, 1),
  Coord(-1, 0)
];

bool posIsValid(Coord pos, List<String> map) {
  return (pos.x >= 0) &&
      (pos.y >= 0) &&
      (pos.x < map[0].length) &&
      (pos.y < map.length);
}

class GuardState {
  Coord position = Coord(-1, -1);
  int direction = 0;

  @override
  bool operator ==(Object other) =>
      other is GuardState &&
      position == other.position &&
      direction == other.direction;
  @override
  int get hashCode => Object.hash(position, direction);

  GuardState clone() {
    var newGuardState = GuardState();

    newGuardState.position = position.clone();
    newGuardState.direction = direction;
    return newGuardState;
  }

  void turnRight() {
    direction = (direction + 1) % directions.length;
  }

  Coord nextPos() {
    return position + directions[direction];
  }
}

bool isLoop(GuardState oldGuard, List<String> map) {
  var guard = oldGuard.clone();
  Set<GuardState> visited = {};
  while (posIsValid(guard.position, map)) {
    visited.add(guard.clone());
    final nextPos = guard.nextPos();
    if (posIsValid(nextPos, map)) {
      if (map[nextPos.y][nextPos.x] == barrierIcon) {
        guard.turnRight();
      } else {
        guard.position = nextPos;
        if (visited.contains(guard)) {
          return true;
        }
      }
    } else {
      guard.position = nextPos;
    }
  }
  return false;
}

Future<int> solution2(Stream<String> lines) async {
  List<String> map = [];
  var guard = GuardState();

  int lineNum = 0;
  await for (final line in lines) {
    if (line.isEmpty) break;

    map.add(line);
    final guardCol = line.indexOf(guardIcon);
    if (guardCol > -1) {
      guard.position = Coord(guardCol, lineNum);
    }

    lineNum++;
  }

  assert(guard.position.x != -1);

  final oldGuard = guard.clone();

  Set<GuardState> visited = {};
  while (posIsValid(guard.position, map)) {
    visited.add(guard.clone());
    final nextPos = guard.nextPos();
    if (posIsValid(nextPos, map)) {
      if (map[nextPos.y][nextPos.x] == barrierIcon) {
        guard.turnRight();
      } else {
        guard.position = nextPos;
      }
    } else {
      guard.position = nextPos;
    }
  }

  visited.remove(oldGuard);

  Set<Coord> oldBarriers = {};

  int result = 0;
  for (final newBlock in visited) {
    assert(posIsValid(newBlock.position, map));
    if (oldBarriers.contains(newBlock.position)) continue;
    oldBarriers.add(newBlock.position.clone());

    var thisMap = List<String>.from(map);
    final rowNum = newBlock.position.y;
    final colNum = newBlock.position.x;
    final oldRow = thisMap[rowNum];
    String newRow = oldRow.substring(0, colNum) + barrierIcon;
    if (colNum < (map[0].length) - 1) {
      newRow += oldRow.substring(colNum + 1);
    }
    thisMap[rowNum] = newRow;
    assert(oldRow.length == newRow.length);
    if (isLoop(oldGuard, thisMap)) {
      result++;
    }
  }

  return result;
}
