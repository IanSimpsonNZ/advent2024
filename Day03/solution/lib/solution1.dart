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
  final mults = line.split('mul(');
  for (final mult in mults) {
    result += getMultValue(mult);
  }
  return result;
}

Future<int> solution1(Stream<String> lines) async {
  int result = 0;
  await for (final line in lines) {
    if (line.isEmpty) break;
    result += parseLine(line);
  }

  return result;
}
