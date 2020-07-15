import 'package:moscow/map/grid.dart';
import 'package:moscow/model/player.dart';
import 'package:moscow/model/units.dart';
import 'package:moscow/util/quiver/bimap.dart';

const lastTurn = 7;

enum Phase {
  GermanReplacement,
  GermanPanzer,
  GermanCombat,
  GermanMove,
  SovietReplacement,
  SovietRails,
  SovietCombat,
  SovietMove,
}

class Game {
  int turn;
  Phase phase;
  Board board;
  UnitStore units;
}

class UnitStore {
  Map<String, Unit> byId;
  BiMap<Unit, Hex> positions;
  Set<Unit> sovietActive;
  Set<Unit> germanActive;
  Set<Unit> sovietReserve;
  Set<Unit> germanReserve;
}

class Board {
  static const WesternEdgeCol = 1;
  static const EasternEdgeCol = 16;
  static const NorthernEdgeRow = 1;
  static const SouthernEdgeRow = 10;

  Set<Hex> sovietStartingPositions;
  Set<Hex> germanStartingPositions;
  Set<Hex> forest;
  Set<Hex> fortifications;
  Set<Edge> rivers;
  Set<Edge> railroads;
  BiMap<Hex, City> cities;
}

class City {
  final String name;
  Faction holder = Faction.Soviet;

  City(this.name, {this.holder});
}
