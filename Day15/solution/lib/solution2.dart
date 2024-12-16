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
const bigBoxLeft = '[';
const bigBoxRight = ']';

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

class MoveRecord {
  final Coord from;
  final Coord to;
  final String icon;

  MoveRecord(this.from, this.to, this.icon);
}

class Warehouse {
  List<List<String>> map = [];
  String instructions = '';

  List<MoveRecord> moveList = [];

  Coord robot = Coord(0, 0);

  Future<void> load(Stream<String> lines) async {
    map = [];
    moveList = [];
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
            robot = Coord(robotTest * 2, rowNum);
          }

          map.add([]);
          final icons = line.split('');
          for (final icon in icons) {
            switch (icon) {
              case wallIcon:
                map[rowNum].add(wallIcon);
                map[rowNum].add(wallIcon);
              case boxIcon:
                map[rowNum].add(bigBoxLeft);
                map[rowNum].add(bigBoxRight);
              case freeIcon:
                map[rowNum].add(freeIcon);
                map[rowNum].add(freeIcon);
              case robotIcon:
                map[rowNum].add(robotIcon);
                map[rowNum].add(freeIcon);
              default:
                stderr.writeln('Invalid map icon: "$icon"');
                exit(255);
            }
          }
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
    stdout.writeln('Robot is $robot');
    stdout.writeln(instructions);
  }

  void moveIcon(Coord position, Coord moveTo) {
    map[moveTo.y][moveTo.x] = map[position.y][position.x];
    map[position.y][position.x] = freeIcon;
    if (map[moveTo.y][moveTo.x] == robotIcon) {
      robot = moveTo;
    }
  }

  void doMoveList() {
    while (moveList.isNotEmpty) {
      final move = moveList.removeAt(0);
      map[move.to.y][move.to.x] = move.icon;
      map[move.from.y][move.from.x] = freeIcon;
    }
  }

  bool moveListContains(Coord position) {
    for (final move in moveList) {
      if (move.from == position) return true;
    }
    return false;
  }

  bool moveBox(Coord position, String direction) {
    final icon = map[position.y][position.x];
    Coord otherSide = position + left;
    if (icon == bigBoxLeft) {
      otherSide = position + right;
    }
    final otherIcon = map[otherSide.y][otherSide.x];

    final moveTo1 = position + moveDir[direction]!;
    final moveTo2 = otherSide + moveDir[direction]!;
    final moveIcon1 = map[moveTo1.y][moveTo1.x];
    final moveIcon2 = map[moveTo2.y][moveTo2.x];

    if (moveIcon1 == wallIcon || moveIcon2 == wallIcon) {
      stdout.writeln('hit wall');
      return false;
    }

    if (moveIcon1 == freeIcon && moveIcon2 == freeIcon) {
      if (!moveListContains(position)) {
        moveList.add(MoveRecord(position, moveTo1, icon));
      }
      if (!moveListContains(otherSide)) {
        moveList.add(MoveRecord(otherSide, moveTo2, otherIcon));
      }
      return true;
    }

    bool canMove = false;
    if (moveIcon1 == freeIcon) {
      canMove = moveBox(moveTo2, direction);
    } else if (moveIcon2 == freeIcon) {
      canMove = moveBox(moveTo1, direction);
    } else {
      if (icon == moveIcon1) {
        canMove = moveBox(moveTo1, direction);
      } else {
        canMove = moveBox(moveTo1, direction) && moveBox(moveTo2, direction);
      }
    }
    if (canMove) {
      if (!moveListContains(position)) {
        moveList.add(MoveRecord(position, moveTo1, icon));
      }
      if (!moveListContains(otherSide)) {
        moveList.add(MoveRecord(otherSide, moveTo2, otherIcon));
      }
    }

    return canMove;
  }

  bool move(Coord position, String direction) {
    final moveTo = position + moveDir[direction]!;
    final moveToIcon = map[moveTo.y][moveTo.x];

    if (moveToIcon == wallIcon) return false;

    if ((moveToIcon == bigBoxLeft || moveToIcon == bigBoxRight) &&
        (direction == '^' || direction == 'v')) {
      moveList = [];
      if (moveBox(moveTo, direction)) {
        doMoveList();
        moveIcon(position, moveTo);
        return true;
      }
      return false;
    }

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
        if (map[row][col] == bigBoxLeft) {
          result += 100 * row + col;
        }
      }
    }
    return result;
  }
}

Future<int> solution2(Stream<String> lines) async {
  var warehouse = Warehouse();
  await warehouse.load(lines);

  for (final direction in warehouse.instructions.split('')) {
    warehouse.move(warehouse.robot, direction);
  }
  warehouse.print();

  return warehouse.calcResult();
}
