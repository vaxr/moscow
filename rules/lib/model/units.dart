import 'package:moscow_rules/model/player.dart';

enum UnitType { Infantry, Panzer }
enum UnitSize { Corps, Army }
enum UnitCondition { FullStrength, HalfStrength, Defeated, Postponed }

class Unit {
  final String id;
  final String name;
  final UnitType unitType;
  final UnitSize size;
  final Faction faction;
  final int fullStrength;
  final int halfStrength;
  final int movement;

  UnitCondition condition;

  Unit({
    this.id,
    this.name,
    this.unitType,
    this.size,
    this.faction,
    this.fullStrength,
    this.halfStrength,
    this.movement,
    this.condition,
  });
}
