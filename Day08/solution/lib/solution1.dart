// import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const String blankIcon = '.';

class TransmitterMap {
  int maxX = 0;
  int maxY = 0;

  Map<String, List<Coord>> antennas = {};
  Set<Coord> antinodes = {};

  Future<void> getAntennas(Stream<String> lines) async {
    int rowNum = 0;
    await for (final line in lines) {
      if (line.isEmpty) break;
      if (maxX == 0) {
        maxX = line.length - 1;
      }

      for (int colNum = 0; colNum < line.length; colNum++) {
        final char = line[colNum];
        if (char == blankIcon) continue;

        if (antennas.containsKey(char)) {
          antennas[char]!.add(Coord(colNum, rowNum));
        } else {
          antennas[char] = [Coord(colNum, rowNum)];
        }
      }
      rowNum++;
    }
    maxY = rowNum - 1;
  }

  bool addIfValid(Coord node) {
    if (node.x >= 0 && node.x <= maxX && node.y >= 0 && node.y <= maxY) {
      antinodes.add(node.clone());
      return true;
    }
    return false;
  }

  void calcAntinodes() {
    for (final antList in antennas.values) {
      for (int i1 = 0; i1 < antList.length - 1; i1++) {
        for (int i2 = i1 + 1; i2 < antList.length; i2++) {
          final ant1 = antList[i1];
          final ant2 = antList[i2];
          final dx = ant2.x - ant1.x;
          final dy = ant2.y - ant1.y;
          addIfValid(Coord(ant1.x - dx, ant1.y - dy));
          addIfValid(Coord(ant2.x + dx, ant2.y + dy));
        }
      }
    }
  }
}

Future<int> solution1(Stream<String> lines) async {
  var transMap = TransmitterMap();

  await transMap.getAntennas(lines);
  transMap.calcAntinodes();

  int result = transMap.antinodes.length;

  return result;
}

// 334 too high
