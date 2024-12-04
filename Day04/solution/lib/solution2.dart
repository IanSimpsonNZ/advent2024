import 'dart:io';

const String searchWord = 'XMAS';

class WordSearch {
  List<String> rows = [];

  bool checkDiag(int startRow, int startCol, int dRow, int dCol) {
    final row1 = startRow + dRow;
    if (row1 < 0 || row1 >= rows.length) return false;
    final row2 = startRow - dRow;
    if (row2 < 0 || row2 >= rows.length) return false;
    final col1 = startCol + dCol;
    if (col1 < 0 || col1 >= rows[0].length) return false;
    final col2 = startCol - dCol;
    if (col2 < 0 || col2 >= rows[0].length) return false;

    if (rows[row1][col1] == 'M') {
      return rows[row2][col2] == 'S';
    } else if (rows[row1][col1] == 'S') {
      return rows[row2][col2] == 'M';
    }
    return false;
  }

  bool findCross(int row, int col) {
    return checkDiag(row, col, -1, -1) && checkDiag(row, col, -1, 1);
  }

  void print() {
    for (final row in rows) {
      stdout.writeln(row);
    }
  }
}

Future<int> solution2(Stream<String> lines) async {
  final wordSearch = WordSearch();
  await for (final line in lines) {
    wordSearch.rows.add(line);
  }

  int result = 0;
  for (int col = 0; col < wordSearch.rows[0].length; col++) {
    for (int row = 0; row < wordSearch.rows.length; row++) {
      if (wordSearch.rows[row][col] == 'A') {
        if (wordSearch.findCross(row, col)) {
          result++;
        }
      }
    }
  }

  return result;
}
