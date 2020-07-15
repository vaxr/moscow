import 'package:moscow/core/model/player.dart';

enum UnitType { Infantry, Panzer }
enum UnitSize { Corps, Army }

class Unit {
  final String id;
  final String name;
  final UnitType unitType;
  final UnitSize size;
  final Faction faction;
  final int fullStrength;
  final int halfStrength;
  final int movement;

  bool isHalved;

  int get strength => isHalved ? halfStrength : fullStrength;

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
}
