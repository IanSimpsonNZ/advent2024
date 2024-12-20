import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';
import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var onsen = Onsen();
  await onsen.load(lines);

  onsen.sortByLength(onsen.towels);
  final reduced = onsen.reduceDict(onsen.towels);

  stdout.writeln('Part 1: ${onsen.validatePatterns(reduced)}');

  return onsen.getCombinations();
}
