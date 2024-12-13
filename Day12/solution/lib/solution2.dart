import 'dart:io';
import 'package:solution/solution1.dart';

Future<int> solution2(Stream<String> lines) async {
  var crops = Field();
  await crops.loadMap(lines);
  stdout.writeln(crops.calcFence());
  return crops.calcEdgeCost();
}
