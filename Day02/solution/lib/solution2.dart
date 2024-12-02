bool isOK(List<int> reports) {
  bool ok = true;
  bool increasing = true;

  for (int i = 1; i < reports.length; i++) {
    final diff = reports[i] - reports[i - 1];
    if (diff.abs() > 3 || diff.abs() < 1) {
      ok = false;
      break;
    } else if (i == 1) {
      if (diff < 0) {
        increasing = false;
      }
    } else {
      ok = (increasing && diff > 0) || (!increasing && diff < 0);
    }
    if (!ok) break;
  }

  return ok;
}

Future<int> solution2(Stream<String> lines) async {
  int oklines = 0;
  await for (final line in lines) {
    if (line.isEmpty) break;
    final reports = line.split(' ').map((s) => int.parse(s)).toList();
    bool ok = false;
    for (int i = 0; i < reports.length; i++) {
      var newList = [...reports];
      newList.removeAt(i);
      ok = isOK(newList);
      if (ok) break;
    }
    if (ok) {
      oklines++;
    }
  }

  return oklines;
}
