import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

class Probe {
  final Coord position;
  final int numSteps;
  final List<Coord> path;

  Probe(this.position, this.numSteps, this.path);
}

class MemoryMap {
  final int memorySize;
  List<List<bool>> memCorrupt = [];
  List<List<bool>> beenHere = [];
  List<Coord> allTheBytes = [];
  int nextByte = 0;

  final Coord exit;

  int? minSteps;
  List<Coord> bestPath = [];

  final up = Coord(0, -1);
  final down = Coord(0, 1);
  final left = Coord(-1, 0);
  final right = Coord(1, 0);

  MemoryMap(this.memorySize) : exit = Coord(memorySize - 1, memorySize - 1) {
    for (int i = 0; i < memorySize; i++) {
      memCorrupt.add(List<bool>.filled(memorySize, false));
      beenHere.add(List<bool>.filled(memorySize, false));
    }
  }

  void reset() {
    beenHere = [];
    minSteps = null;
    bestPath = [];
  }

  Future<void> getBytes(Stream<String> lines, int numBytes) async {
    await for (final line in lines) {
      final parts = line.split(',');
      allTheBytes.add(Coord(int.parse(parts[1]), int.parse(parts[0])));
    }

    for (int b = 0; b < numBytes; b++) {
      final byte = allTheBytes[b];
      memCorrupt[byte.y][byte.x] = true;
      nextByte++;
    }
  }

  void print() {
    for (int row = 0; row < memCorrupt.length; row++) {
      for (int col = 0; col < memCorrupt[0].length; col++) {
        if (memCorrupt[row][col]) {
          stdout.write('#');
        } else {
          stdout.write('.');
        }
      }
      stdout.writeln();
    }
  }

  bool isValid(Coord position) {
    return position.x >= 0 &&
        position.y >= 0 &&
        position.x < memorySize &&
        position.y < memorySize;
  }

  void calcMinSteps() {
    Set<Coord> tried = {};

    List<Probe> activeProbes = [Probe(Coord(0, 0), 0, [])];

    while (activeProbes.isNotEmpty) {
      List<Probe> newProbes = [];

      for (final probe in activeProbes) {
        // stdout.write('${probe.position}, ');
        if (!isValid(probe.position)) continue;
        if (memCorrupt[probe.position.y][probe.position.x]) continue;
        if (tried.contains(probe.position)) continue;
        tried.add(probe.position);

        if (probe.position == exit) {
          if (minSteps == null || probe.numSteps < minSteps!) {
            minSteps = probe.numSteps;
            bestPath = probe.path;
          }
          continue;
        }

        final dx = exit.x - probe.position.x;
        final dy = exit.y - probe.position.y;

        if (minSteps != null && probe.numSteps + dx + dy >= minSteps!) {
          continue;
        }

        final nextPath = probe.path + [probe.position];

        if (dx < dy) {
          newProbes
              .add(Probe(probe.position + down, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + right, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + up, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + left, probe.numSteps + 1, nextPath));
        } else {
          newProbes
              .add(Probe(probe.position + right, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + down, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + left, probe.numSteps + 1, nextPath));
          newProbes
              .add(Probe(probe.position + up, probe.numSteps + 1, nextPath));
        }
      }
      activeProbes = newProbes;
      // stdout.writeln();
    }
  }
}

Future<int> solution1(Stream<String> lines) async {
  var map = MemoryMap(71);
  await map.getBytes(lines, 1024);

  map.print();

  map.calcMinSteps();

  return map.minSteps!;
}


// 140 too low
