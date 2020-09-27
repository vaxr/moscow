import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/core/util/quiver/bimap.dart';

const lastTurn = 7;

class Phase {
  static const Phase GermanDeployment = Phase(0, Faction.German, 'Deployment');
  static const Phase GermanReplacement =
      Phase(1, Faction.German, 'Replacement');
  static const Phase GermanPanzer = Phase(2, Faction.German, 'Panzer');
  static const Phase GermanCombat = Phase(3, Faction.German, 'Combat');
  static const Phase GermanMove = Phase(4, Faction.German, 'Movement');
  static const Phase SovietReplacement =
      Phase(5, Faction.German, 'Replacement');
  static const Phase SovietRails = Phase(6, Faction.German, 'Railway');
  static const Phase SovietCombat = Phase(7, Faction.German, 'Combat');
  static const Phase SovietMove = Phase(8, Faction.German, 'Movement');

  static final nr = [
    GermanDeployment,
    GermanReplacement,
    GermanPanzer,
    GermanCombat,
    GermanMove,
    SovietReplacement,
    SovietRails,
    SovietCombat,
    SovietMove,
  ];

  final order;
  final faction;
  final description;

  const Phase(this.order, this.faction, this.description);

  @override
  String toString() => '$faction $description';
}

class GameState {
  int turn;
  Phase phase;
  Board board;
  Units units;
  final List<Move> history = [];
}

class Move {
  final Map<Unit, Hex> positions = {};

  @override
  String toString() =>
      '<Move ' +
      positions.keys
          .map((k) => '${k.id} ${positions[k].toColRowString()}')
          .join(', ') +
      '>';
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
