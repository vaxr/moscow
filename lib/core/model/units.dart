import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/util/quiver/bimap.dart';

enum UnitType { Infantry, Panzer }
enum UnitSize { Corps, Army }

const UnitSizeSymbols = <UnitSize, String>{
  UnitSize.Corps: 'XXX',
  UnitSize.Army: 'XXXX',
};

class Unit {
  final String id;
  final String name;
  final UnitType unitType;
  final UnitSize size;
  final Faction faction;
  final int fullStrength;
  final int halfStrength;
  final int movement;

  bool isHalved = false;

  int get strength => isHalved ? halfStrength : fullStrength;

  // speed will be calculated dynamically according to rules
  int get speed => movement;

  Unit({
    this.id,
    this.name,
    this.unitType,
    this.size,
    this.faction,
    this.fullStrength,
    this.halfStrength,
    this.movement,
    this.isHalved,
  });

  @override
  String toString() => '<Unit $id>';

  int compareBest(Unit other) {
    var cmp = other.compareStrength(this);
    if (cmp == 0) cmp = other.compareMovement(this);
    if (cmp == 0) cmp = compareId(other);
    return cmp;
  }

  int compareStrength(Unit other) => strength.compareTo(other.strength);

  int compareMovement(Unit other) => movement.compareTo(other.movement);

  int compareId(Unit other) => id.compareTo(other.id);
}

class Units {
  Map<String, Unit> byId = {};
  Set<Unit> sovietActive = {};
  Set<Unit> germanActive = {};
  Set<Unit> sovietReserve = {};
  Set<Unit> germanReserve = {};
  BiMap<Hex, Unit> byHex = BiMap();

  Set<Unit> _reserve(Unit unit) =>
      unit.faction == Faction.Soviet ? sovietReserve : germanReserve;

  Set<Unit> _active(Unit unit) =>
      unit.faction == Faction.Soviet ? sovietActive : germanActive;

  void toHex(Unit unit, Hex hex) {
    if (hex == null) {
      toReserve(unit);
    } else {
      _reserve(unit).remove(unit);
      _active(unit).add(unit);
      byHex.inverse.remove(unit);
      byHex[hex] = unit;
    }
  }

  void add(Unit unit) {
    byId[unit.id] = unit;
    toReserve(unit);
  }

  void addAll(Iterable<Unit> units) => units.forEach(add);

  void toReserve(Unit unit) {
    byHex.inverse.remove(unit);
    _active(unit).remove(unit);
    _reserve(unit).add(unit);
  }

  @override
  String toString() => '<Units ${byId.keys.join(' ')}>';

  static Unit best(Iterable<Unit> units) =>
      units.reduce((a, b) => (a ?? b).compareBest(b) >= 0 ? b : a);

  static List<Unit> byBest(Iterable<Unit> units) =>
      units.toList()..sort((a, b) => a.compareBest(b));
}
