// import 'dart:io';

Future<int> solution2(Stream<String> lines) async {
  int oklines = 0;
  await for (final line in lines) {
    final reports = line.split(' ').map((s) => int.parse(s)).toList();
    // stdout.write(reports);
    bool ok = true;
    int increasing = 0;
    int decreasing = 0;
    int same = 0;

    for (int i = 1; i < reports.length; i++) {
      final diff = reports[i] - reports[i - 1];
      if (diff.abs() > 3) {
        ok = false;
        break;
      } else {
        if (diff > 0) {
          increasing++;
        } else if (diff < 0) {
          decreasing++;
        } else {
          same++;
        }
      }
    }

    if (!ok) continue;

    if (same > 1) continue;

    if (same == 1) {
      if (increasing == 0 || decreasing == 0) {
        oklines++;
      }
      continue;
    }

    if (increasing <= 1 || decreasing <= 1) {
      oklines++;
      // stdout.writeln(' ok');
    } else {
      // stdout.writeln(' not ok');
    }
  }

  return oklines;
}

// 370 too high
// 331 too low
