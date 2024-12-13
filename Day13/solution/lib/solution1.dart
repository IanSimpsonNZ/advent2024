// import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

const int aCost = 3;
const int bCost = 1;

enum State {
  a,
  b,
  prize,
}

Future<int> solution1(Stream<String> lines) async {
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

        i = int.parse(IJ[0].split('=')[1]);
        j = int.parse(IJ[1].split('=')[1]);

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

// 94(w)a + 22(x)b = 8400(i)
// 34(y)a + 67(z)b = 5400(j)

// b = ( 8400(i) - 94(w)a) / 22(x)

// 34(y)a + 67(z) / 22(x) * (8400(i) -94(w)a) = 5400(j)

// 748(yx)a + 562800(zi) - 6298a(zw)a = 118800(jx)

// 748(yx)a - 6298(zw)a = 118800(jx) - 562800(zi)

// -5550(yx - zw)a = -444,000(jx - zi)

// a = 80 =>  (jx - zi) / (yx - zw)

// b = (8400(i) - 94(w) * 80(A)) / 22(x)
// b = 40