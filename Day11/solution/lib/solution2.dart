// import 'dart:io';

class Stones {
  List<int> stones = [];
  Map<StoneState, int> stoneCache = {};

  Future<void> loadStones(Stream<String> lines) async {
    final line = await lines.first;
    stones = line.split(' ').map((s) => int.parse(s)).toList();
  }

  int getLengthRecursive(int thisStone, int numBlinks) {
    if (numBlinks == 0) return 1;

    final thisState = StoneState(thisStone, numBlinks);
    final cacheVal = stoneCache[thisState];
    if (cacheVal != null) return cacheVal;

    final numStr = thisStone.toString();
    int length = 0;
    if (thisStone == 0) {
      length = getLengthRecursive(1, numBlinks - 1);
    } else if ((numStr.length % 2) == 0) {
      length = getLengthRecursive(
            int.parse(numStr.substring(0, numStr.length ~/ 2)),
            numBlinks - 1,
          ) +
          getLengthRecursive(
            int.parse(numStr.substring(numStr.length ~/ 2)),
            numBlinks - 1,
          );
    } else {
      length = getLengthRecursive(thisStone * 2024, numBlinks - 1);
    }

    stoneCache[thisState] = length;
    return length;
  }

  int getLength(int numBlinks) {
    int result = 0;
    for (final stone in stones) {
      result += getLengthRecursive(stone, numBlinks);
    }
    return result;
  }
}

class StoneState {
  int stone;
  int blinkNum;

  StoneState(this.stone, this.blinkNum);

  @override
  bool operator ==(Object other) =>
      other is StoneState && stone == other.stone && blinkNum == other.blinkNum;
  @override
  int get hashCode => Object.hash(stone, blinkNum);
}

Future<int> solution2(Stream<String> lines) async {
  var stoneLine = Stones();
  await stoneLine.loadStones(lines);

  return stoneLine.getLength(75);
}
