enum Direction { NorthWest, North, NorthEast, SouthEast, South, SouthWest }

class HexPosition {
  int x;
  int y;
}

class EdgePosition {
  HexPosition hex;
  Direction direction;
}
