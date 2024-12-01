Future<int> historian2(Stream<String> lines) async {
  List<int> list1 = [];
  List<int> list2 = [];

  await for (final line in lines) {
    final firstSpace = line.indexOf(' ');
    list1.add(int.parse(line.substring(0, firstSpace).trim()));
    list2.add(int.parse(line.substring(firstSpace + 1).trim()));
  }

  int result = 0;
  for (int i = 0; i < list1.length; i++) {
    int inSecondList = 0;
    for (int j = 0; j < list2.length; j++) {
      if (list1[i] == list2[j]) {
        inSecondList++;
      }
    }
    result += list1[i] * inSecondList;
  }
  return result;
}
