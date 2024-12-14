// import 'dart:io';
import 'dart:io';

import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const time = 100;
const maxX = 101;
const maxY = 103;

Future<int> solution1(Stream<String> lines) async {
  List<Coord> robots = [];
  await for (final line in lines) {
    if (line.isEmpty) break;
    final parts = line.split(' ');
    final posStr = parts[0].split('=')[1].split(',');
    final int startX = int.parse(posStr[0]);
    final int startY = int.parse(posStr[1]);

    final velStr = parts[1].split('=')[1].split(',');
    final int velX = int.parse(velStr[0]);
    final int velY = int.parse(velStr[1]);

    robots.add(
        Coord((startX + velX * time) % maxX, (startY + velY * time) % maxY));
  }

  final xSplit = maxX ~/ 2;
  final ySplit = maxY ~/ 2;

  int q1 = 0;
  int q2 = 0;
  int q3 = 0;
  int q4 = 0;

  for (final robot in robots) {
    if (robot.x < xSplit) {
      if (robot.y < ySplit) {
        q1++;
      } else if (robot.y > ySplit) {
        q3++;
      }
    } else if (robot.x > xSplit) {
      if (robot.y < ySplit) {
        q2++;
      } else if (robot.y > ySplit) {
        q4++;
      }
    }
  }

  stdout.writeln('q1: $q1   q2: $q2   q3: $q3   q4: $q4');

  return q1 * q2 * q3 * q4;
}
