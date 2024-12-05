// import 'dart:io';

Future<int> solution2(Stream<String> lines) async {
  List<List<int>> rules = [];
  List<List<int>> updates = [];

  bool gettingRules = true;
  await for (final line in lines) {
    if (gettingRules) {
      if (line.isEmpty) {
        gettingRules = false;
      } else {
        rules.add(line.split('|').map((s) => int.parse(s)).toList());
      }
    } else {
      if (line.isEmpty) {
        if (updates.isEmpty) {
          continue;
        } else {
          break;
        }
      }
      updates.add(line.split(',').map((s) => int.parse(s)).toList());
    }
  }

  int result = 0;

  for (final update in updates) {
    var fixedLine = List<int>.from(update);
    bool ok = true;
    bool changed = true;
    while (changed) {
      changed = false;
      for (final rule in rules) {
        final firstPos = fixedLine.indexOf(rule[0]);
        if (firstPos >= 0) {
          final secondPos = fixedLine.indexOf(rule[1]);
          if (secondPos > -1 && secondPos < firstPos) {
            ok = false;
            changed = true;
            fixedLine.removeAt(secondPos);
            fixedLine.insert(firstPos, rule[1]);
            break;
          }
        }
      }
    }
    if (!ok) {
      result += fixedLine[fixedLine.length ~/ 2];
    }
  }

  return result;
}
