// import 'dart:io';

Future<int> historian1(Stream<String> lines) async {
  List<int> list1 = [];
  List<int> list2 = [];

  await for (final line in lines) {
    // stdout.writeln('Line is *${line.split(' ')}*');
    // final numbers = line.split(' ').map((s) => int.parse(s.trim())).toList();
    // stdout.writeln('${numbers[0]} - ${numbers[1]}');
    final firstSpace = line.indexOf(' ');
    list1.add(int.parse(line.substring(0, firstSpace).trim()));
    list2.add(int.parse(line.substring(firstSpace + 1).trim()));
  }

  list1.sort();
  list2.sort();

  int result = 0;
  for (int i = 0; i < list1.length; i++) {
    result += (list1[i] - list2[i]).abs();
  }
  return result;
}
