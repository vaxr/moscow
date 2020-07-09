import 'package:moscow_rules/model/player.dart';
import 'package:moscow_rules/model/map.dart';

enum UnitType { Infantry, Panzer }
enum UnitSize { Corps, Army }
enum UnitStatus { FullStrength, HalfStrength, Defeated, Postponed }

class Unit {
  // immutable
  String id;
  String name;
  UnitType unitType;
  UnitSize size;
  Faction faction;
  int fullStrength;
  int halfStrength;
  int movement;

  // mutable
  HexPosition position;
  UnitStatus status;
}
