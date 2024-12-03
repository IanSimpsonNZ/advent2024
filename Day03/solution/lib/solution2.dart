import 'dart:math';

enum Instr {
  doInst,
  dontInst,
  multInst,
}

int getMultValue(String mult) {
  final parts = mult.split(',');
  if (parts.length < 2) return 0;

  final num1 = int.tryParse(parts[0]);
  if (num1 == null) return 0;
  if (parts[0] != parts[0].trim()) return 0;
  if (num1 > 999) return 0;

  if (!parts[1].contains(')')) return 0;
  final numStr2 = parts[1].split(')');
  if (numStr2[0].isEmpty) return 0;
  final num2 = int.tryParse(numStr2[0]);
  if (num2 == null) return 0;
  if (numStr2[0] != numStr2[0].trim()) return 0;
  if (num2 > 999) return 0;

  return num1 * num2;
}

int parseLine(String line) {
  int result = 0;
  int cursor = 0;
  bool enabled = true;
  while (cursor < line.length) {
    int doPos = line.indexOf('do()', cursor);
    int dontPos = line.indexOf("don't()", cursor);
    int mulPos = line.indexOf('mul(', cursor);
    if (doPos == -1) doPos = line.length;
    if (dontPos == -1) dontPos = line.length;
    if (mulPos == -1) mulPos = line.length;
    cursor = min(doPos, min(dontPos, mulPos));

    if (cursor == doPos) {
      enabled = true;
      cursor += 'do()'.length;
    } else if (cursor == dontPos) {
      enabled = false;
      cursor += "don't".length;
    } else if (cursor == mulPos) {
      if (enabled) {
        result += getMultValue(line.substring(cursor + 'mul('.length));
      }
      cursor += 'mul('.length;
    } else {
      cursor++;
    }
  }

  return result;
}

Future<int> solution2(Stream<String> lines) async {
  // int result = 0;
  String oneString = '';
  await for (final line in lines) {
    if (line.isEmpty) break;
    oneString += line;
  }

  return parseLine(oneString);
}
