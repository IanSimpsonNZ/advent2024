// import 'dart:io';

class DiskBlock {
  int id; // -1 is default for empty block
  int length;

  DiskBlock({this.id = -1, this.length = 0});
}

int firstFree(List<DiskBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    final thisBlock = blocks[i];
    if (thisBlock.id == -1 && thisBlock.length > 0) return i;
  }
  return -1;
}

String printBlocks(List<DiskBlock> blocks) {
  String result = '';
  for (int i = 0; i < blocks.length; i++) {
    for (int j = 0; j < blocks[i].length; j++) {
      if (blocks[i].id == -1) {
        result += '.';
      } else {
        result += '${blocks[i].id}';
      }
    }
  }
  return result;
}

Future<int> solution1(Stream<String> lines) async {
  List<DiskBlock> blocks = [];

  final line = await lines.first;
  int id = 0;
  bool isData = true;
  for (int i = 0; i < line.length; i++) {
    var newBlock = DiskBlock();
    if (isData) {
      newBlock.id = id;
      id++;
    }
    newBlock.length = int.parse(line[i]);
    blocks.add(newBlock);
    isData = !isData;
  }
  blocks.add(DiskBlock(id: -1, length: 0)); // always have a blank at end

  bool canMove = true;
  while (canMove) {
    canMove = false;
    final free = firstFree(blocks);
    if (free == -1) continue;
    for (int i = blocks.length - 1; i >= 0; i--) {
      if (i <= free) break;
      final thisID = blocks[i].id;
      if (thisID == -1) continue;
      if (blocks[i].length == 0) continue;

      blocks[i].length--;
      blocks[free].length--;
      if (free > 0 && blocks[free - 1].id == thisID) {
        blocks[free - 1].length++;
      } else {
        blocks.insert(free, DiskBlock(id: thisID, length: 1));
      }
      blocks.last.length++;
      canMove = true;

      break;
    }
  }

  int result = 0;
  int pos = 0;
  for (int i = 0; i < blocks.length; i++) {
    final thisID = blocks[i].id;
    for (int j = 0; j < blocks[i].length; j++) {
      if (thisID > -1) {
        result += thisID * pos;
      }
      pos++;
    }
  }

  return result;
}
