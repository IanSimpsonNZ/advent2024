import 'dart:io';

Future<int> solution2(Stream<String> lines) async {
  await for (final line in lines) {
    stdout.writeln(line);
  }

  int result = 0;

  return result;
}
