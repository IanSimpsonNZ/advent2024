// import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

final Coord up = Coord(0, -1);
final Coord down = Coord(0, 1);
final Coord left = Coord(-1, 0);
final Coord right = Coord(1, 0);

class TrailMap {
  List<List<int>> topographic = [];
  // List<Coord> alreadyFound = [];

  Future<void> loadMap(Stream<String> lines) async {
    await for (final line in lines) {
      if (line.isEmpty) break;
      topographic.add(line.split('').map((s) => int.parse(s)).toList());
    }
  }

  bool isInBounds(Coord coord) {
    return coord.x >= 0 &&
        coord.y >= 0 &&
        coord.x < topographic[0].length &&
        coord.y < topographic.length;
  }

  int trailsFromHere(Coord start, int height) {
    if (!isInBounds(start)) return 0;
    if (topographic[start.y][start.x] != height) return 0;

    if (height == 9) {
      // if (alreadyFound.contains(start)) {
      //   return 0;
      // } else {
      //   alreadyFound.add(start);
      //   return 1;
      // }
      return 1;
    }

    height++;
    return trailsFromHere(start + up, height) +
        trailsFromHere(start + down, height) +
        trailsFromHere(start + left, height) +
        trailsFromHere(start + right, height);
  }

  int countTrails() {
    int result = 0;
    for (int row = 0; row < topographic.length; row++) {
      for (int col = 0; col < topographic[0].length; col++) {
        // alreadyFound = [];
        result += trailsFromHere(Coord(col, row), 0);
      }
    }

    return result;
  }
}

Future<int> solution2(Stream<String> lines) async {
  var trailMap = TrailMap();
  await trailMap.loadMap(lines);

  return trailMap.countTrails();
}
