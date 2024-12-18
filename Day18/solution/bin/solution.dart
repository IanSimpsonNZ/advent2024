import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:solution/solution1.dart';
import 'package:solution/solution2.dart';

void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser();

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  historian(paths);
}

Future<void> historian(List<String> args) async {
  if (args.isNotEmpty) {
    final path = args[0];
    final dayNum = args[1];
    stdout.writeln('Day number $dayNum');
    final lines = utf8.decoder
        .bind(File(path).openRead())
        .transform(const LineSplitter());

    final int result;
    if (dayNum == '1') {
      result = await solution1(lines);
    } else {
      result = await solution2(lines);
    }

    stdout.writeln('The answer is $result');
  }
}
