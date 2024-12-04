import 'dart:io';

const String searchWord = 'XMAS';

class WordSearch {
  List<String> rows = [];

  int findWords(int row, int col) {
    int result = 0;
    result += findNext(row, col, -1, -1, 0);
    result += findNext(row, col, -1, 0, 0);
    result += findNext(row, col, -1, 1, 0);
    result += findNext(row, col, 0, -1, 0);
    result += findNext(row, col, 0, 1, 0);
    result += findNext(row, col, 1, -1, 0);
    result += findNext(row, col, 1, 0, 0);
    result += findNext(row, col, 1, 1, 0);

    return result;
  }

  int findNext(int startRow, int startCol, int dRow, int dCol, int cursor) {
    if (cursor >= searchWord.length) return 1;
    final row = startRow + (dRow * cursor);
    final col = startCol + (dCol * cursor);
    if (row < 0 || row >= rows.length) return 0;
    if (col < 0 || col >= rows[0].length) return 0;
    if (rows[row][col] != searchWord[cursor]) return 0;

    return findNext(startRow, startCol, dRow, dCol, cursor + 1);
  }

  void print() {
    for (final row in rows) {
      stdout.writeln(row);
    }
  }
}

Future<int> solution1(Stream<String> lines) async {
  final wordSearch = WordSearch();
  await for (final line in lines) {
    wordSearch.rows.add(line);
  }

  int result = 0;
  for (int col = 0; col < wordSearch.rows[0].length; col++) {
    for (int row = 0; row < wordSearch.rows.length; row++) {
      result += wordSearch.findWords(row, col);
    }
  }

  return result;
}
