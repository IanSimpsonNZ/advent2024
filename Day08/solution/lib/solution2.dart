// import 'dart:io';
import 'package:solution/solution1.dart';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

extension Part2 on TransmitterMap {
  void calcAllAntinodes() {
    for (final antList in antennas.values) {
      for (int i1 = 0; i1 < antList.length - 1; i1++) {
        for (int i2 = i1 + 1; i2 < antList.length; i2++) {
          final ant1 = antList[i1];
          final ant2 = antList[i2];
          final dx = ant2.x - ant1.x;
          final dy = ant2.y - ant1.y;
          final delta = Coord(dx, dy);
          var anti = ant1;
          while (addIfValid(anti)) {
            anti = anti - delta;
          }
          anti = ant2;
          while (addIfValid(anti)) {
            anti = anti + delta;
          }
        }
      }
    }
  }
}

Future<int> solution2(Stream<String> lines) async {
  var transMap = TransmitterMap();

  await transMap.getAntennas(lines);
  transMap.calcAllAntinodes();

  int result = transMap.antinodes.length;

  return result;
}
