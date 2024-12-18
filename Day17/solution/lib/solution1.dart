import 'dart:io';
// import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

class Computer {
  int PC = 0;
  int A = 0;
  int B = 0;
  int C = 0;

  int initA = 0;
  int initB = 0;
  int initC = 0;

  List<int> mem = [];
  List<int> output = [];

  int? maxOutLen;
  int breakpoint = 99999999;

  void reset() {
    PC = 0;
    A = initA;
    B = initB;
    C = initC;
    output = [];
  }

  Future<void> loadProg(Stream<String> lines) async {
    bool loadRegs = true;
    await for (final line in lines) {
      if (line.isEmpty) {
        if (loadRegs) {
          loadRegs = false;
          continue;
        } else {
          break;
        }
      }

      if (loadRegs) {
        final parts = line.split(':');
        final regName = parts[0][parts[0].length - 1];
        final value = int.parse(parts[1]);
        switch (regName) {
          case 'A':
            A = value;
          case 'B':
            B = value;
          case 'C':
            C = value;
          default:
            stderr.writeln('Invalid register name: "$regName"');
        }
        continue;
      }

      mem = line.split(':')[1].split(',').map((s) => int.parse(s)).toList();
    }
    initA = A;
    initB = B;
    initC = C;
  }

  int combo(int operand) {
    switch (operand) {
      case >= 0 && <= 3:
        return operand;
      case 4:
        return A;
      case 5:
        return B;
      case 6:
        return C;
      default:
        stderr.writeln('Invalid combo operand: $operand');
        return operand;
    }
  }

  int intPow(int num, int pow) {
    if (pow == 0) return 1;
    int result = num;
    for (int i = 1; i < pow; i++) {
      result *= num;
    }
    return result;
  }

  void execute() {
    while (PC < mem.length && PC != breakpoint) {
      int opCode = mem[PC];
      int operand = mem[PC + 1];

      switch (opCode) {
        case 0: // adv
          A = A ~/ intPow(2, combo(operand));
          PC += 2;
        case 1: // bxl
          B = B ^ operand;
          PC += 2;
        case 2: // bst
          B = combo(operand) % 8;
          PC += 2;
        case 3: //jnz
          if (A == 0) {
            PC += 2;
          } else {
            PC = operand;
          }
        case 4: //bxc
          B = B ^ C;
          PC += 2;
        case 5: //out
          output.add(combo(operand) % 8);
          if (maxOutLen != null && output.length > maxOutLen!) {
            stdout.writeln('Output Limit');
            output.add(-1);
            PC = mem.length + 100;
          }
          PC += 2;
        case 6:
          B = A ~/ intPow(2, combo(operand));
          PC += 2;
        case 7:
          C = A ~/ intPow(2, combo(operand));
          PC += 2;
        default:
          stderr.writeln('Invalid instruction: $opCode');
      }
    }
  }

  String printOut() {
    String result = '';
    for (final n in output) {
      result += '$n,';
    }
    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  void status() {
    stdout.writeln('Register A: $A');
    stdout.writeln('Register B: $B');
    stdout.writeln('Register C: $C');
    stdout.writeln();
    stdout.writeln('PC: $PC');
    stdout.writeln('Program: $mem');
  }
}

Future<int> solution1(Stream<String> lines) async {
  var threeBit = Computer();
  await threeBit.loadProg(lines);

  threeBit.status();
  threeBit.execute();
  stdout.writeln(threeBit.printOut());

  return 0;
}
