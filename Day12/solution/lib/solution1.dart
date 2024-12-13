// import 'dart:io';
import 'file:///Users/Iansi/Code/AdventOfCode/2024/helpers/coord.dart';

final right = Coord(1, 0);
final left = Coord(-1, 0);
final down = Coord(0, 1);
final up = Coord(0, -1);

const int dirUp = 0;
const int dirRight = 1;
const int dirDown = 2;
const int dirLeft = 3;

class PlotStats {
  int area = 0;
  int perimeter = 0;
}

class PlotAndDirection {
  Coord plot;
  int direction;

  PlotAndDirection(this.plot, this.direction);

  @override
  bool operator ==(Object other) =>
      other is PlotAndDirection &&
      plot == other.plot &&
      direction == other.direction;
  @override
  int get hashCode => Object.hash(plot, direction);

  @override
  String toString() => '$plot : $direction';
}

class Field {
  List<String> field = [];
  List<List<bool>> done = [];
  List<Coord> directions = [up, right, down, left];
  Map<Coord, int> plotAreas = {};
  Map<Coord, Set<PlotAndDirection>> edgeRecords = {}; // row x col x direction
  Map<Coord, List<Coord>> allPlots = {};

  Future<void> loadMap(Stream<String> lines) async {
    field = [];
    done = [];
    await for (final line in lines) {
      if (line.isEmpty) break;
      field.add(line);
    }
    for (int row = 0; row < field.length; row++) {
      done.add(List.filled(field[0].length, false));
    }
  }

  bool outOfBounds(Coord point) {
    return point.x < 0 ||
        point.y < 0 ||
        point.y >= field.length ||
        point.x >= field[0].length;
  }

  bool plotChange(Coord point, Coord secondPoint) {
    if (outOfBounds(secondPoint)) return true;
    final thisPlant = field[point.y][point.x];
    final nextPlant = field[secondPoint.y][secondPoint.x];
    return thisPlant != nextPlant;
  }

  int getPerim(Coord point) {
    int result = 0;
    for (final direction in directions) {
      if (plotChange(point, point + direction)) result++;
    }
    return result;
  }

  PlotStats plotStatRec(Coord thisPlot, Coord topLeft) {
    var result = PlotStats();

    if (outOfBounds(thisPlot)) return result;
    if (done[thisPlot.y][thisPlot.x]) return result;
    done[thisPlot.y][thisPlot.x] = true;

    final thisPlant = field[thisPlot.y][thisPlot.x];
    allPlots[topLeft]!.add(thisPlot);
    scanEdges(thisPlot, topLeft);
    result.area = 1;
    result.perimeter = getPerim(thisPlot);
    for (final direction in directions) {
      final nextPlot = thisPlot + direction;
      if (outOfBounds(nextPlot)) continue;

      final nextPlant = field[nextPlot.y][nextPlot.x];
      if (thisPlant != nextPlant) continue;

      final theRest = plotStatRec(thisPlot + direction, topLeft);
      result.area += theRest.area;
      result.perimeter += theRest.perimeter;
    }

    return result;
  }

  PlotStats calcPlot(Coord startPoint) {
    if (done[startPoint.y][startPoint.x]) return PlotStats();
    allPlots[startPoint] = [];
    final result = plotStatRec(startPoint, startPoint);
    plotAreas[startPoint] = result.area;
    return result;
  }

  int calcFence() {
    int result = 0;
    for (int row = 0; row < field.length; row++) {
      for (int col = 0; col < field[0].length; col++) {
        final stats = calcPlot(Coord(col, row));
        result += stats.area * stats.perimeter;
      }
    }

    return result;
  }

  void addEdge(Coord square, int direction, Coord topLeft) {
    if (edgeRecords[topLeft] == null) {
      edgeRecords[topLeft] = {};
    }
    edgeRecords[topLeft]!.add(PlotAndDirection(square, direction));
  }

  bool clearEdge(Coord square, int direction, Coord topLeft) {
    final edgeList = edgeRecords[topLeft];
    assert(edgeList != null);
    return edgeList!.remove(PlotAndDirection(square, direction));
  }

  void scanEdges(Coord square, Coord topLeft) {
    for (int d = 0; d < directions.length; d++) {
      if (plotChange(square, square + directions[d])) {
        addEdge(square, d, topLeft);
      }
    }
  }

  bool getEdge(Coord square, int direction, Coord topLeft) {
    final edgeList = edgeRecords[topLeft];
    if (edgeList == null) return false;
    return edgeList.contains(PlotAndDirection(square, direction));
  }

  // calculate the number of edges around the outside of a plot (not just edge lengths)
  // Uses edgeRecords to keep track of which edges have yet to be processed
  // edgeRecords is destroyed in the process
  int calcExteriorEdges(Coord topLeft) {
    if (plotAreas[topLeft]! == 1) {
      edgeRecords.remove(topLeft);
      return 4;
    }

    clearEdge(topLeft, dirUp, topLeft);
    clearEdge(topLeft, dirLeft, topLeft);

    Coord cursor = topLeft.clone();
    int direction = 1; // index to directions
    final startState = PlotAndDirection(cursor, direction);
    var state = PlotAndDirection(cursor, direction);
    int edges = 0;
    do {
      final ahead = cursor + directions[direction];
      final leftDirection = (direction - 1) % directions.length;
      final turnLeft = cursor + directions[leftDirection];
      if (!plotChange(cursor, turnLeft)) {
        direction = leftDirection; // turn left
        edges++;
        cursor = turnLeft;
      } else if (plotChange(cursor, ahead)) {
        clearEdge(cursor, (direction - 1) % directions.length, topLeft);
        direction = (direction + 1) % directions.length; // turn right
        edges++;
      } else {
        clearEdge(cursor, (direction - 1) % directions.length,
            topLeft); // erase left edge
        cursor = ahead;
      }
      state = PlotAndDirection(cursor, direction);
    } while (state != startState);
    return edges;
  }

  int calcInteriorEdges(Coord topLeft) {
    int edges = 0;
    if (edgeRecords[topLeft] == null) return edges;

    while (edgeRecords[topLeft]!.isNotEmpty) {
      final edgeSet = edgeRecords[topLeft]!;
      final edgeState = edgeSet.first;
      edgeSet.remove(edgeState);

      Coord cursor = edgeState.plot.clone();
      int direction = (edgeState.direction - 1) % directions.length;

      final startState = PlotAndDirection(cursor, direction);
      var state = PlotAndDirection(cursor, direction);

      do {
        final ahead = cursor + directions[direction];
        final rightDirection = (direction + 1) % directions.length;
        final turnRight = cursor + directions[rightDirection];
        if (!plotChange(cursor, turnRight)) {
          direction = rightDirection; // right turn
          edges++;
          cursor = turnRight;
        } else if (plotChange(cursor, ahead)) {
          clearEdge(cursor, (direction + 1) % directions.length, topLeft);
          direction = (direction - 1) % directions.length; // turn left
          edges++;
        } else {
          clearEdge(cursor, (direction + 1) % directions.length,
              topLeft); // Erase right edge
          cursor = ahead;
        }
        state = PlotAndDirection(cursor, direction);
      } while (state != startState);
    }
    return edges;
  }

  int calcEdgeCost() {
    int result = 0;

    for (final plot in plotAreas.keys) {
      final externalEdges = calcExteriorEdges(plot);
      final internalEdges = calcInteriorEdges(plot);
      int edges = externalEdges + internalEdges;

      final area = plotAreas[plot]!;
      result += area * edges;
    }

    return result;
  }
}

Future<int> solution1(Stream<String> lines) async {
  var crops = Field();
  await crops.loadMap(lines);
  return crops.calcFence();
}
