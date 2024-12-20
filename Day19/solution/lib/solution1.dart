import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

class Onsen {
  List<String> towels = [];
  List<String> allPatterns = [];
  List<String> validPatterns = [];

  Future<void> load(Stream<String> lines) async {
    bool getTowels = true;
    await for (final line in lines) {
      if (line.isEmpty) {
        if (getTowels) {
          getTowels = false;
          continue;
        } else {
          break;
        }
      }

      if (getTowels) {
        towels = line.split(',').map((t) => t.trim()).toList();
      } else {
        allPatterns.add(line);
      }
    }
  }

  void sortByLength(List<String> dict) {
    for (int i = 0; i < dict.length - 1; i++) {
      bool inOrder = true;
      for (int j = dict.length - 1; j > i; j--) {
        if (dict[j - 1].length > dict[j].length) {
          final tmp = dict[j];
          dict[j] = dict[j - 1];
          dict[j - 1] = tmp;
          inOrder = false;
        }
      }
      if (inOrder) break;
    }
  }

  List<String> reduceDict(List<String> dict) {
    List<String> newDict = [dict[0]];
    for (int i = 1; i < dict.length; i++) {
      if (!isValidPattern(dict[i], newDict)) {
        newDict.add(dict[i]);
      }
    }

    return newDict;
  }

  bool isValidPattern(String pattern, List<String> dictionary) {
    List<List<String>> solutions = [[]];
    bool gotANewOne = true;
    while (gotANewOne) {
      gotANewOne = false;
      // each solution is a list of towels
      final List<List<String>> newSolutionList = [];
      for (final towelsSoFar in solutions) {
        int startIndex = 0;
        if (towelsSoFar.isNotEmpty) {
          for (final towel in towelsSoFar) {
            startIndex += towel.length;
          }
        }

        if (startIndex == pattern.length) {
          newSolutionList.add(towelsSoFar);
          return true;
        }

        for (final towel in dictionary) {
          if (pattern.indexOf(towel, startIndex) == startIndex) {
            newSolutionList.add(towelsSoFar + [towel]);
            gotANewOne = true;
          }
        }
      }
      solutions = newSolutionList;
    }

    return false;
  }

  int validatePatterns(List<String> dictionary) {
    // run through each pattern. Each pattern has a list of possible solutions (at least one empty list)
    for (final pattern in allPatterns) {
      if (isValidPattern(pattern, dictionary)) {
        validPatterns.add(pattern);
      }
    }

    return validPatterns.length;
  }

  int getCombinations() {
    int result = 0;

    for (final pattern in validPatterns) {
      var pathsToHere = List<int>.filled(pattern.length + 1, 0);
      int startPos = 0;
      pathsToHere[0] = 1;
      while (startPos < pattern.length) {
        final numPaths = pathsToHere[startPos];
        for (final towel in towels) {
          if (pattern.indexOf(towel, startPos) == startPos) {
            pathsToHere[startPos + towel.length] += numPaths;
          }
        }

        startPos++;
        while (startPos < pattern.length && pathsToHere[startPos] == 0) {
          startPos++;
        }
      }

      stdout
          .writeln('$pattern has ${pathsToHere[pattern.length]} combinations');
      result += pathsToHere[pattern.length];
    }
    return result;
  }
}

Future<int> solution1(Stream<String> lines) async {
  var onsen = Onsen();
  await onsen.load(lines);

  stdout.writeln('Before sort: ${onsen.towels}');
  onsen.sortByLength(onsen.towels);
  stdout.writeln('After sort:  ${onsen.towels}');
  final reduced = onsen.reduceDict(onsen.towels);
  stdout.writeln('Reduced:     $reduced');

  return onsen.validatePatterns(reduced);
}
