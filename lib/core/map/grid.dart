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

  Set<Hex> get neighbors => {
        Hex.fromCube(cube + _neighbors[Direction.North]),
        Hex.fromCube(cube + _neighbors[Direction.NorthEast]),
        Hex.fromCube(cube + _neighbors[Direction.SouthEast]),
        Hex.fromCube(cube + _neighbors[Direction.South]),
        Hex.fromCube(cube + _neighbors[Direction.SouthWest]),
        Hex.fromCube(cube + _neighbors[Direction.NorthWest]),
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hex &&
          runtimeType == other.runtimeType &&
          offset.col == other.offset.col &&
          offset.row == other.offset.row;

  @override
  int get hashCode => offset.col.hashCode ^ offset.row.hashCode;

  XY get centerXY => XY.fromCube(cube);

  static const Map<Direction, CubeCoords> _corners = {
    Direction.NorthEast: CubeCoords(1 / 3.0, 1 / 3.0, -2 / 3.0),
    Direction.East: CubeCoords(2 / 3.0, -1 / 3.0, -1 / 3.0),
    Direction.SouthEast: CubeCoords(1 / 3.0, -2 / 3.0, 1 / 3.0),
    Direction.SouthWest: CubeCoords(-1 / 3.0, -1 / 3.0, 2 / 3.0),
    Direction.West: CubeCoords(-2 / 3.0, 1 / 3.0, 1 / 3.0),
    Direction.NorthWest: CubeCoords(-1 / 3.0, 2 / 3.0, -1 / 3.0),
  };

  List<XY> get cornersXY => [
        XY.fromCube(cube + _corners[Direction.NorthWest]),
        XY.fromCube(cube + _corners[Direction.NorthEast]),
        XY.fromCube(cube + _corners[Direction.East]),
        XY.fromCube(cube + _corners[Direction.SouthEast]),
        XY.fromCube(cube + _corners[Direction.SouthWest]),
        XY.fromCube(cube + _corners[Direction.West]),
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
        return Edge.fromHex(
            Hex.fromCube(
                CubeCoords(hex.cube.x + 1, hex.cube.y - 1, hex.cube.z)),
            Direction.NorthWest);
      case Direction.South:
        return Edge.fromHex(
            Hex.fromCube(
                CubeCoords(hex.cube.x, hex.cube.y - 1, hex.cube.z + 1)),
            Direction.North);
      case Direction.SouthWest:
        return Edge.fromHex(
            Hex.fromCube(
                CubeCoords(hex.cube.x - 1, hex.cube.y, hex.cube.z + 1)),
            Direction.NorthEast);
      default:
        return this;
    }
  }

  List<XY> get cornersXY {
    final edge = canonical;
    switch (edge.direction) {
      case Direction.NorthWest:
        return [
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.West]),
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.NorthWest]),
        ];
      case Direction.North:
        return [
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.NorthWest]),
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.NorthEast]),
        ];
      case Direction.NorthEast:
        return [
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.NorthEast]),
          XY.fromCube(edge.hex.cube + Hex._corners[Direction.East]),
        ];
      default:
        throw Exception('Unreachable code if Edge.canonical works right');
    }
  }

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

  CubeCoords operator +(CubeCoords other) =>
      CubeCoords(x + other.x, y + other.y, z + other.z);

  @override
  String toString() => '<Cube $x,$y,$z>';
}

class XY {
  final double x, y;

  const XY(this.x, this.y);

  XY.fromCube(CubeCoords c)
      : x = 1.5 * c.x,
        y = sqrt(3) * (0.5 * c.x + c.z);

  XY operator +(XY other) => XY(x + other.x, y + other.y);

  @override
  String toString() => '<XY $x,$y>';
}
