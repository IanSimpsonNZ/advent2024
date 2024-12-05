// import 'dart:io';

Future<int> solution1(Stream<String> lines) async {
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
    bool ok = true;
    for (final rule in rules) {
      final firstPos = update.indexOf(rule[0]);
      if (firstPos >= 0) {
        final secondPos = update.indexOf(rule[1]);
        if (secondPos > -1 && secondPos < firstPos) {
          ok = false;
          break;
        }
      }
    }
    if (ok) {
      result += update[update.length ~/ 2];
    }
  }

  return result;
}
