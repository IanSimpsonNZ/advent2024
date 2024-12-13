// import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const int aCost = 3;
const int bCost = 1;
const int extra = 10000000000000;

enum State {
  a,
  b,
  prize,
}

Future<int> solution2(Stream<String> lines) async {
  State state = State.a;
  int result = 0;
  int w = 0;
  int x = 0;
  int y = 0;
  int z = 0;
  int i = 0;
  int j = 0;
  await for (final line in lines) {
    if (line.isEmpty) continue;
    switch (state) {
      case State.a:
        final parts = line.split(':');

        final WY = parts[1].split(',');

        w = int.parse(WY[0].split('+')[1]);
        y = int.parse(WY[1].split('+')[1]);
        state = State.b;

      case State.b:
        final parts = line.split(':');

        final XZ = parts[1].split(',');

        x = int.parse(XZ[0].split('+')[1]);
        z = int.parse(XZ[1].split('+')[1]);
        state = State.prize;

      case State.prize:
        final parts = line.split(':');

        final IJ = parts[1].split(',');

        i = int.parse(IJ[0].split('=')[1]) + extra;
        j = int.parse(IJ[1].split('=')[1]) + extra;

        final a1 = y * x - z * w;
        final a2 = j * x - z * i;

        final a = a2 ~/ a1;
        if (a2 != a * a1) {
          state = State.a;
          continue;
        }

        final b1 = i - w * a;

        final b = b1 ~/ x;
        if (b1 != b * x) {
          state = State.a;
          continue;
        }

        result += a * aCost + b * bCost;

        state = State.a;
    }
  }

  return result;
}
