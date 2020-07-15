enum Direction { NorthWest, North, NorthEast, SouthEast, South, SouthWest }

/// Cube coordinates, stolen from
/// <a href="https://www.redblobgames.com/grids/hexagons">this brilliant article</a>.
///
/// `col` and `row` refer to an even-q hex grid with <1,1> as top left.
class Hex {
  final int x, y, z;

  Hex(col, row)
      : x = col,
        y = -col - (row - (col + (col & 1)) ~/ 2),
        z = row - (col + (col & 1)) ~/ 2;

  Hex.fromCube(this.x, this.y, this.z);

  int get col => x;

  int get row => z + (x + (x & 1)) ~/ 2;

  bool isNeighbor(Hex other) {
    final dx = other.x - x;
    final dy = other.y - y;
    final dz = other.z - z;
    return dx + dy + dz == 0 && dx.abs() <= 1 && dy.abs() <= 1 && dz.abs() <= 1;
  }

  Set<Hex> get neighbors => {
        Hex.fromCube(x + 1, y - 1, z),
        Hex.fromCube(x + 1, y, z - 1),
        Hex.fromCube(x, y + 1, z - 1),
        Hex.fromCube(x, y - 1, z + 1),
        Hex.fromCube(x - 1, y + 1, z),
        Hex.fromCube(x - 1, y, z + 1),
      };

  int distanceTo(Hex other) =>
      ((other.x - x).abs() + (other.y - y).abs() + (other.z - z).abs()) ~/ 2;

  static const borderDirectionTable = {
    '0,1': Direction.North,
    '1,0': Direction.NorthEast,
    '1,-1': Direction.SouthEast,
    '0,-1': Direction.South,
    '-1,0': Direction.SouthWest,
    '-1,1': Direction.NorthWest,
  };

  Direction borderDirection(Hex other) {
    return borderDirectionTable['${other.x - x},${other.y - y}'];
  }

  @override
  String toString() => '<$col,$row/$x,$y,$z>';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hex &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}

class Edge {
  final Hex hex;
  final Direction direction;

  Edge(col, row, this.direction) : hex = Hex(col, row);

  Edge.fromHex(this.hex, this.direction);

  Edge get canonical {
    switch (direction) {
      case Direction.SouthEast:
        return Edge.fromHex(
            Hex.fromCube(hex.x + 1, hex.y - 1, hex.z), Direction.NorthWest);
      case Direction.South:
        return Edge.fromHex(
            Hex.fromCube(hex.x, hex.y - 1, hex.z + 1), Direction.North);
      case Direction.SouthWest:
        return Edge.fromHex(
            Hex.fromCube(hex.x - 1, hex.y, hex.z + 1), Direction.NorthEast);
      default:
        return this;
    }
  }

  factory Edge.between(Hex a, Hex b) {
    final border = a.borderDirection(b);
    return border == null ? null : Edge.fromHex(a, border).canonical;
  }

  @override
  String toString() => '$hex/$direction';

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
