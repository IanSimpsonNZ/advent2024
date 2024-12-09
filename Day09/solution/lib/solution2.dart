// import 'dart:io';

class DiskBlock {
  int id; // -1 is default for empty block
  int length;

  DiskBlock({this.id = -1, this.length = 0});
}

int firstFree(List<DiskBlock> blocks, int requiredLength) {
  for (int i = 0; i < blocks.length; i++) {
    final thisBlock = blocks[i];
    if (thisBlock.id == -1 && thisBlock.length >= requiredLength) return i;
  }
  return -1;
}

int idPos(List<DiskBlock> blocks, int requiredID) {
  for (int i = blocks.length - 1; i >= 0; i--) {
    if (blocks[i].id == requiredID) return i;
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

Future<int> solution2(Stream<String> lines) async {
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

  int targetID = -1;
  int targetPos = -1;
  for (int i = blocks.length - 1; i >= 0; i--) {
    final thisID = blocks[i].id;
    if (thisID > -1) {
      targetID = thisID;
      targetPos = i;
      break;
    }
  }
  assert(targetID > -1);

  while (targetID > -1) {
    final free = firstFree(blocks, blocks[targetPos].length);
    if (free > -1 && free < targetPos) {
      blocks[targetPos].id = -1;
      blocks[free].length -= blocks[targetPos].length;
      assert(blocks[free].length >= 0);
      blocks.insert(
        free,
        DiskBlock(id: targetID, length: blocks[targetPos].length),
      );
    }

    targetID--;
    if (targetID > -1) {
      targetPos = idPos(blocks, targetID);
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
