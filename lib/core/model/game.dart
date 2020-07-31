import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/core/util/quiver/bimap.dart';

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
}

class Table {
  Board board;
  Units units;
}

class Board {
  static const WesternEdgeCol = 1;
  static const EasternEdgeCol = 16;
  static const NorthernEdgeRow = 1;
  static const SouthernEdgeRow = 10;

  Set<Hex> sovietStartingPositions = {};
  Set<Hex> germanStartingPositions = {};
  Set<Hex> forest = {};
  Set<Hex> fortifications = {};
  Set<Edge> rivers = {};
  Map<Hex, Set<Edge>> railroads = {};
  BiMap<Hex, City> cities = BiMap();

  static final Set<Hex> allHexes = _makeAllHexes();

  static Set<Hex> _makeAllHexes() {
    final result = <Hex>{};
    for (var col = WesternEdgeCol; col <= EasternEdgeCol; col++) {
      for (var row = NorthernEdgeRow; row <= SouthernEdgeRow; row++) {
        result.add(Hex(col, row));
      }
    }
    return result;
  }
}

class City {
  final String name;
  Faction holder = Faction.Soviet;

  City(this.name, {this.holder});

  bool get isMoscow => name == 'Moscow';
}
