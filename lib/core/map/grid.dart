/// Math stolen from
/// <a href="https://www.redblobgames.com/grids/hexagons">this brilliant article</a>.

import 'dart:math';

enum Direction {
  NorthWest,
  North,
  NorthEast,
  SouthEast,
  South,
  SouthWest,
  East,
  West
}

const hexDirections = [
  Direction.North,
  Direction.NorthEast,
  Direction.SouthEast,
  Direction.South,
  Direction.SouthWest,
  Direction.NorthWest,
];

const DirectionFlipped = <Direction, Direction>{
  Direction.NorthWest: Direction.SouthEast,
  Direction.North: Direction.South,
  Direction.NorthEast: Direction.SouthWest,
  Direction.SouthEast: Direction.NorthWest,
  Direction.South: Direction.North,
  Direction.SouthWest: Direction.NorthEast,
  Direction.East: Direction.West,
  Direction.West: Direction.East,
};

class Hex {
  final CubeCoords cube;
  final EvenQCoords offset;

  Hex(col, row)
      : cube = CubeCoords.fromEvenQ(EvenQCoords(col, row)),
        offset = EvenQCoords(col, row);

  Hex.fromCube(this.cube) : offset = EvenQCoords.fromCube(cube);

  bool isNeighbor(Hex other) {
    final dx = other.cube.x - cube.x;
    final dy = other.cube.y - cube.y;
    final dz = other.cube.z - cube.z;
    return dx + dy + dz == 0 && dx.abs() <= 1 && dy.abs() <= 1 && dz.abs() <= 1;
  }

  static const Map<Direction, CubeCoords> _neighbors = {
    Direction.North: CubeCoords(0, 1, -1),
    Direction.NorthEast: CubeCoords(1, 0, -1),
    Direction.SouthEast: CubeCoords(1, -1, 0),
    Direction.South: CubeCoords(0, -1, 1),
    Direction.SouthWest: CubeCoords(-1, 0, 1),
    Direction.NorthWest: CubeCoords(-1, 1, 0),
  };

  Hex neighbor(Direction border) => Hex.fromCube(cube + _neighbors[border]);

  Set<Hex> get neighbors => {
        neighbor(Direction.North),
        neighbor(Direction.NorthEast),
        neighbor(Direction.SouthEast),
        neighbor(Direction.South),
        neighbor(Direction.SouthWest),
        neighbor(Direction.NorthWest),
      };

  int distanceTo(Hex other) =>
      ((other.cube.x - cube.x).abs() +
          (other.cube.y - cube.y).abs() +
          (other.cube.z - cube.z).abs()) ~/
      2;

  static const _borderDirectionTable = {
    '0,1': Direction.North,
    '1,0': Direction.NorthEast,
    '1,-1': Direction.SouthEast,
    '0,-1': Direction.South,
    '-1,0': Direction.SouthWest,
    '-1,1': Direction.NorthWest,
  };

  Direction borderDirection(Hex other) {
    return _borderDirectionTable[
        '${other.cube.x - cube.x},${other.cube.y - cube.y}'];
  }

  @override
  String toString() => '<Hex $offset/$cube>';

  String toColRowString() => '${offset.col}/${offset.row}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hex &&
          runtimeType == other.runtimeType &&
          offset.col == other.offset.col &&
          offset.row == other.offset.row;

  @override
  int get hashCode => offset.col.hashCode ^ offset.row.hashCode;

  GridXY get centerXY => GridXY.fromCube(cube);

  static const Map<Direction, CubeCoords> _corners = {
    Direction.NorthEast: CubeCoords(1 / 3.0, 1 / 3.0, -2 / 3.0),
    Direction.East: CubeCoords(2 / 3.0, -1 / 3.0, -1 / 3.0),
    Direction.SouthEast: CubeCoords(1 / 3.0, -2 / 3.0, 1 / 3.0),
    Direction.SouthWest: CubeCoords(-1 / 3.0, -1 / 3.0, 2 / 3.0),
    Direction.West: CubeCoords(-2 / 3.0, 1 / 3.0, 1 / 3.0),
    Direction.NorthWest: CubeCoords(-1 / 3.0, 2 / 3.0, -1 / 3.0),
  };

  GridXY cornerXY(Direction direction) =>
      GridXY.fromCube(cube + _corners[direction]);

  List<GridXY> get cornersXY => [
        cornerXY(Direction.NorthWest),
        cornerXY(Direction.NorthEast),
        cornerXY(Direction.East),
        cornerXY(Direction.SouthEast),
        cornerXY(Direction.SouthWest),
        cornerXY(Direction.West),
      ];
}

class Edge {
  final Hex hex;
  final Direction direction;

  Edge(col, row, this.direction) : hex = Hex(col, row);

  Edge.fromHex(this.hex, this.direction);

  factory Edge.between(Hex a, Hex b) {
    final border = a.borderDirection(b);
    return border == null ? null : Edge.fromHex(a, border).canonical;
  }

  Edge get canonical {
    switch (direction) {
      case Direction.SouthEast:
      case Direction.South:
      case Direction.SouthWest:
        return flipped;
      default:
        return this;
    }
  }

  Edge get flipped =>
      Edge.fromHex(hex.neighbor(direction), DirectionFlipped[direction]);

  List<GridXY> get cornersXY {
    switch (direction) {
      case Direction.NorthWest:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.West]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.NorthWest]),
        ];
      case Direction.North:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.NorthWest]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.NorthEast]),
        ];
      case Direction.NorthEast:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.NorthEast]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.East]),
        ];
      case Direction.SouthEast:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.East]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.SouthEast]),
        ];
      case Direction.South:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.SouthEast]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.SouthWest]),
        ];
      case Direction.SouthWest:
        return [
          GridXY.fromCube(hex.cube + Hex._corners[Direction.SouthWest]),
          GridXY.fromCube(hex.cube + Hex._corners[Direction.West]),
        ];
      default:
        throw Exception('Unreachable code');
    }
  }

  Set<Edge> get clockwiseNeighbors {
    switch (direction) {
      case Direction.North:
        return {
          Edge.fromHex(hex, Direction.NorthEast),
          Edge.fromHex(hex.neighbor(Direction.NorthEast), Direction.NorthWest),
        };
      case Direction.NorthEast:
        return {
          Edge.fromHex(hex, Direction.SouthEast),
          Edge.fromHex(hex.neighbor(Direction.SouthEast), Direction.North),
        };
      case Direction.SouthEast:
        return {
          Edge.fromHex(hex, Direction.South),
          Edge.fromHex(hex.neighbor(Direction.South), Direction.NorthEast),
        };
      case Direction.South:
        return {
          Edge.fromHex(hex, Direction.SouthWest),
          Edge.fromHex(hex.neighbor(Direction.SouthWest), Direction.SouthEast),
        };
      case Direction.SouthWest:
        return {
          Edge.fromHex(hex, Direction.NorthWest),
          Edge.fromHex(hex.neighbor(Direction.NorthWest), Direction.South),
        };
      case Direction.NorthWest:
        return {
          Edge.fromHex(hex, Direction.North),
          Edge.fromHex(hex.neighbor(Direction.North), Direction.SouthWest),
        };
      default:
        throw Exception('Unreachable code');
    }
  }

  GridXY get centerXY => cornersXY.reduce((a, e) => (a + e) * 0.5);

  @override
  String toString() => '<Edge $hex/$direction>';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edge &&
          runtimeType == other.runtimeType &&
          hex == other.hex &&
          direction == other.direction;

  @override
  int get hashCode => hex.hashCode ^ direction.hashCode;
}

class EvenQCoords {
  final int col, row;

  const EvenQCoords(this.col, this.row);

  EvenQCoords.fromCube(CubeCoords c)
      : col = c.x.round(),
        row = c.z.round() + (c.x.round() + (c.x.round() & 1)) ~/ 2;

  @override
  String toString() => '<EvenQ $col,$row>';
}

class CubeCoords {
  final num x, y, z;

  const CubeCoords(this.x, this.y, this.z);

  CubeCoords.fromEvenQ(EvenQCoords c)
      : x = c.col,
        y = -c.col - (c.row - (c.col + (c.col & 1)) ~/ 2),
        z = c.row - (c.col + (c.col & 1)) ~/ 2;

  CubeCoords.fromXY(GridXY xy)
      : x = 2 / 3.0 * xy.x,
        y = -(2 / 3.0 * xy.x) - (-1 / 3.0 * xy.x + sqrt(3) / 3.0 * xy.y),
        z = -1 / 3.0 * xy.x + sqrt(3) / 3.0 * xy.y;

  CubeCoords operator +(CubeCoords other) =>
      CubeCoords(x + other.x, y + other.y, z + other.z);

  CubeCoords get rounded {
    var roundX = x.round();
    var roundY = y.round();
    var roundZ = z.round();

    final dX = (roundX - x).abs();
    final dY = (roundY - y).abs();
    final dZ = (roundZ - z).abs();

    if (dX > dY && dX > dZ) {
      roundX = -roundY - roundZ;
    } else if (dY > dZ) {
      roundY = -roundX - roundZ;
    } else {
      roundZ = -roundX - roundY;
    }

    return CubeCoords(roundX, roundY, roundZ);
  }

  @override
  String toString() => '<Cube $x,$y,$z>';
}

class GridXY {
  final double x, y;

  const GridXY(this.x, this.y);

  GridXY.fromCube(CubeCoords c)
      : x = 1.5 * c.x,
        y = sqrt(3) * (0.5 * c.x + c.z);

  GridXY operator +(GridXY other) => GridXY(x + other.x, y + other.y);

  GridXY operator *(num scalar) => GridXY(x * scalar, y * scalar);

  @override
  String toString() => '<XY $x,$y>';
}

class Hexes {
  static Set<Set<Hex>> connectedGroups(Iterable<Hex> hexes) {
    final remaining = Set<Hex>.from(hexes);
    final result = <Set<Hex>>{};
    while (remaining.isNotEmpty) {
      final group = <Hex>{};
      final unexplored = <Hex>{remaining.first};
      while (unexplored.isNotEmpty) {
        final hex = unexplored.first;
        unexplored.remove(hex);
        remaining.remove(hex);
        group.add(hex);
        for (final neighbor in hex.neighbors) {
          if (remaining.contains(neighbor)) {
            unexplored.add(neighbor);
          }
        }
      }
      result.add(group);
    }
    return result;
  }

  static List<List<Edge>> borders(Iterable<Hex> connectedHexes) {
    Set<Edge> borderEdges(Iterable<Hex> hexes) {
      final result = <Edge>{};
      for (final hex in hexes) {
        for (final direction in hexDirections) {
          if (!hexes.contains(hex.neighbor(direction))) {
            result.add(Edge.fromHex(hex, direction));
          }
        }
      }
      return result;
    }

    Edge northernMostEdge(Iterable<Edge> edges) => edges.reduce((val, elem) {
          if (elem.direction != Direction.North) return val;
          elem = elem.canonical;
          val = val?.canonical ?? elem;
          var valY = val.hex.offset.row;
          var elemY = elem.hex.offset.row;
          if (valY == elemY) {
            valY -= val.hex.offset.col % 2;
            elemY -= elem.hex.offset.col % 2;
          }
          if (valY == elemY) {
            valY += val.hex.offset.col;
            elemY += elem.hex.offset.col;
          }
          return valY <= elemY ? val : elem;
        });

    Edge pickNeighbor(Edge edge, Edge startingEdge, Set<Edge> unexplored) {
      for (var neighbor in edge.clockwiseNeighbors) {
        if (neighbor == startingEdge || unexplored.contains(neighbor)) {
          return neighbor;
        }
      }
      throw StateError('Error in algorithm: no neighbor fits');
    }

    List<Edge> extractBorder(Set<Edge> unexplored) {
      final border = <Edge>[];
      final startingEdge = northernMostEdge(unexplored);
      var edge = startingEdge;
      do {
        border.add(edge);
        unexplored.remove(edge);
        edge = pickNeighbor(edge, startingEdge, unexplored);
      } while (edge != startingEdge);
      return border;
    }

    if (connectedHexes?.isEmpty ?? true) return [];
    var unexplored = borderEdges(connectedHexes);
    final borders = [extractBorder(unexplored)];
    unexplored = unexplored.map((edge) => edge.flipped).toSet();
    while (unexplored.isNotEmpty) {
      borders.add(extractBorder(unexplored));
    }
    return borders;
  }
}
