import 'dart:math';

import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/core/util/quiver/bimap.dart';

const lastTurn = 7;

class Phase {
  static final Phase GermanDeployment = Phase(0, Faction.German, 'Deployment');
  static final Phase GermanReplacement =
      Phase(1, Faction.German, 'Replacement');
  static final Phase GermanPanzer = Phase(2, Faction.German, 'Panzer');
  static final Phase GermanCombat = Phase(3, Faction.German, 'Combat');
  static final Phase GermanMove = Phase(4, Faction.German, 'Movement');
  static final Phase SovietReplacement =
      Phase(5, Faction.German, 'Replacement');
  static final Phase SovietRails = Phase(6, Faction.German, 'Railway');
  static final Phase SovietCombat = Phase(7, Faction.German, 'Combat');
  static final Phase SovietMove = Phase(8, Faction.German, 'Movement');

  static final nr = <int, Phase>{};
  static int maxNr = 0;

  final order;
  final faction;
  final description;

  Phase(this.order, this.faction, this.description) {
    nr[order] = this;
    maxNr = max(maxNr, order);
  }

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
