// import 'dart:io';

// import 'dart:io';

Future<int> solution1(Stream<String> lines) async {
  int oklines = 0;
  await for (final line in lines) {
    final reports = line.split(' ').map((s) => int.parse(s)).toList();
    bool ok = true;
    bool increasing = true;

    for (int i = 1; i < reports.length; i++) {
      final diff = reports[i] - reports[i - 1];
      if (diff.abs() > 3 || diff.abs() < 1) {
        ok = false;
        break;
      } else if (i == 1) {
        if (diff > 0) {
          increasing = true;
        } else {
          increasing = false;
        }
      } else {
        ok = (increasing && diff > 0) || (!increasing && diff < 0);
      }
      if (!ok) break;
    }
    if (ok) {
      oklines++;
    }
  }

  return oklines;
}
