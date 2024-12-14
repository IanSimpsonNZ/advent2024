import 'dart:io';

import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const time = 100;
const maxX = 101;
const maxY = 103;
const lowResPixel = 10;

Future<int> solution2(Stream<String> lines) async {
  List<List<Coord>> robots = [];
  await for (final line in lines) {
    if (line.isEmpty) break;
    final parts = line.split(' ');
    final posStr = parts[0].split('=')[1].split(',');
    final int startX = int.parse(posStr[0]);
    final int startY = int.parse(posStr[1]);

    final velStr = parts[1].split('=')[1].split(',');
    final int velX = int.parse(velStr[0]);
    final int velY = int.parse(velStr[1]);

    robots.add([Coord(startX, startY), Coord(velX, velY)]);
  }

  const start = 0;
  const numLoops = 10000;

  for (int i = start; i < start + numLoops; i++) {
    List<List<int>> bigDisplay = [];
    for (int y = 0; y < maxY; y++) {
      bigDisplay.add(List.filled(maxX, 0));
    }

    for (final robot in robots) {
      final rx = (robot[0].x + robot[1].x * i) % maxX;
      final ry = (robot[0].y + robot[1].y * i) % maxY;
      bigDisplay[ry][rx]++;
    }

    const checkArea = 30;
    int check = 0;
    for (int cy = 0; cy < checkArea; cy++) {
      for (int cx = 0; cx < checkArea - cy; cx++) {
        if (bigDisplay[cy][cx] > 0) check++;
      }
    }
    if (check > 3) continue;

    stdout.writeln();
    stdout.writeln('Time: $i');
    for (int y = 0; y < maxY; y++) {
      for (int x = 0; x < maxX; x++) {
        final pixel = bigDisplay[y][x];
        if (pixel == 0) {
          stdout.write(' ');
        } else {
          stdout.write('*');
        }
      }
      stdout.writeln();
    }
  }

  return 0;
}
