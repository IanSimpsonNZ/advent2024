import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

enum LoadState {
  map,
  instructions,
}

const wallIcon = '#';
const freeIcon = '.';
const boxIcon = 'O';
const robotIcon = '@';

final up = Coord(0, -1);
final down = Coord(0, 1);
final left = Coord(-1, 0);
final right = Coord(1, 0);

final Map<String, Coord> moveDir = {
  '^': up,
  'v': down,
  '<': left,
  '>': right,
};

class Warehouse {
  List<List<String>> map = [];
  String instructions = '';

  Coord robot = Coord(0, 0);

  Future<void> load(Stream<String> lines) async {
    map = [];
    instructions = '';
    LoadState state = LoadState.map;

    int rowNum = 0;
    await for (final line in lines) {
      if (line.isEmpty) {
        if (state == LoadState.map) {
          state = LoadState.instructions;
          continue;
        } else {
          break;
        }
      }

      switch (state) {
        case LoadState.map:
          final robotTest = line.indexOf(robotIcon);
          if (robotTest > -1) {
            robot = Coord(robotTest, rowNum);
          }
          map.add(line.split(''));
        case LoadState.instructions:
          instructions += line;
      }
      rowNum++;
    }
  }

  void print() {
    for (final row in map) {
      for (final square in row) {
        stdout.write(square);
      }
      stdout.writeln();
    }
    stdout.writeln();
    stdout.writeln(instructions);
  }

  void moveIcon(Coord position, Coord moveTo) {
    map[moveTo.y][moveTo.x] = map[position.y][position.x];
    map[position.y][position.x] = freeIcon;
    if (map[moveTo.y][moveTo.x] == robotIcon) {
      robot = moveTo;
    }
  }

  bool move(Coord position, String direction) {
    final moveTo = position + moveDir[direction]!;
    final moveToIcon = map[moveTo.y][moveTo.x];

    if (moveToIcon == wallIcon) return false;

    if (moveToIcon == freeIcon) {
      moveIcon(position, moveTo);
      return true;
    }

    if (move(moveTo, direction)) {
      moveIcon(position, moveTo);
      return true;
    }

    return false;
  }

  int calcResult() {
    int result = 0;
    for (int row = 1; row < map.length - 1; row++) {
      for (int col = 1; col < map[0].length - 1; col++) {
        if (map[row][col] == boxIcon) {
          result += 100 * row + col;
        }
      }
    }
    return result;
  }
}

Future<int> solution1(Stream<String> lines) async {
  var warehouse = Warehouse();
  await warehouse.load(lines);

  for (final direction in warehouse.instructions.split('')) {
    warehouse.move(warehouse.robot, direction);
  }

  return warehouse.calcResult();
}
