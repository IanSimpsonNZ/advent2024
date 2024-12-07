// import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const String guardIcon = '^';
const String barrierIcon = '#';

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

Future<int> solution1(Stream<String> lines) async {
  List<String> map = [];
  Set<Coord> visited = {};
  Coord? guard;
  int direction = 0;

  int lineNum = 0;
  await for (final line in lines) {
    if (line.isEmpty) break;

    map.add(line);
    final guardCol = line.indexOf(guardIcon);
    if (guardCol > -1) {
      guard = Coord(guardCol, lineNum);
    }

    lineNum++;
  }

  assert(guard != null);

  while (posIsValid(guard!, map)) {
    visited.add(guard);
    final nextPos = guard + directions[direction];
    if (posIsValid(nextPos, map)) {
      if (map[nextPos.y][nextPos.x] == barrierIcon) {
        direction = (direction + 1) % directions.length;
      } else {
        guard = nextPos.clone();
      }
    } else {
      guard = nextPos.clone();
    }
  }

  int result = visited.length;

  return result;
}
