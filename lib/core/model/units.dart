import 'package:moscow/core/model/player.dart';

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
}
