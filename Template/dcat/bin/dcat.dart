import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths);
}

Future<void> dcat(List<String> args) async {
  if (args.isNotEmpty) {
    final path = args[0];
    final dayNum = args[1];
    stdout.writeln('Day number $dayNum');
    final lines = utf8.decoder
        .bind(File(path).openRead())
        .transform(const LineSplitter());
    try {
      await for (final line in lines) {
        stdout.writeln(line);
      }
    } catch (_) {
      await _handleError(path);
    }
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
