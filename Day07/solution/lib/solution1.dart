// import 'dart:io';

bool findTarget(int target, List<int> numbers, int totalSoFar, int cursor) {
  if (cursor == numbers.length) {
    return (totalSoFar == target);
  }

  if (cursor == 0) {
    return findTarget(target, numbers, numbers[0], 1);
  }

  final plusTot = totalSoFar + numbers[cursor];
  if (findTarget(target, numbers, plusTot, cursor + 1)) {
    return true;
  }

  final multTot = totalSoFar * numbers[cursor];
  return findTarget(target, numbers, multTot, cursor + 1);
}

Future<int> solution1(Stream<String> lines) async {
  int result = 0;

  await for (final line in lines) {
    if (line.isEmpty) break;

    final lineParts = line.split(':');
    final target = int.parse(lineParts[0]);
    final numbers =
        lineParts[1].trim().split(' ').map((s) => int.parse(s)).toList();

    if (findTarget(target, numbers, 0, 0)) {
      result += target;
    }
  }

  return result;
}
