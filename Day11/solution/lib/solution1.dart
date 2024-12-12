// import 'dart:io';

class Stones {
  List<int> stones = [];

  Future<void> loadStones(Stream<String> lines) async {
    final line = await lines.first;
    stones = line.split(' ').map((s) => int.parse(s)).toList();
  }

  void blink() {
    List<int> newStones = [];

    while (stones.isNotEmpty) {
      final nextStone = stones.removeAt(0);

      if (nextStone == 0) {
        newStones.add(1);
        continue;
      }

      final numStr = nextStone.toString();
      if ((numStr.length % 2) == 0) {
        newStones.add(int.parse(numStr.substring(0, numStr.length ~/ 2)));
        newStones.add(int.parse(numStr.substring(numStr.length ~/ 2)));
        continue;
      }

      newStones.add(nextStone * 2024);
    }

    stones = newStones;
  }
}

Future<int> solution1(Stream<String> lines) async {
  var stoneLine = Stones();
  await stoneLine.loadStones(lines);

  for (int i = 0; i < 25; i++) {
    stoneLine.blink();
  }

  return stoneLine.stones.length;
}
