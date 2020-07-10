import 'package:moscow_rules/model/player.dart';
import 'package:moscow_rules/model/units.dart';

class UnitsFactory {
  Set<Unit> makeSovietForces() => {
        makeSovietInfantry('s3', '3rd Army'),
        makeSovietInfantry('s5', '5th Army'),
        makeSovietInfantry('s10', '10th Army'),
        makeSovietInfantry('s13', '13th Army'),
        makeSovietInfantry('s16', '16th Army'),
        makeSovietInfantry('s19', '19th Army'),
        makeSovietInfantry('s20', '20th Army'),
        makeSovietInfantry('s24', '24th Army'),
        makeSovietInfantry('s29', '29th Army'),
        makeSovietInfantry('s30', '30th Army'),
        makeSovietInfantry('s32', '32nd Army'),
        makeSovietInfantry('s33', '33rd Army'),
        makeSovietInfantry('s40', '40th Army'),
        makeSovietInfantry('s43', '43rd Army'),
        makeSovietInfantry('s49', '49th Army'),
        makeSovietInfantry('s50', '50th Army'),
        makeSovietShock('s1', '1st Shock Army'),
      };

  Set<Unit> makeGermanForces() => {
        makeGermanInfantry('g34', 'XXXIV Army Corps', 4, 2),
        makeGermanInfantry('g42', 'XLII Army Corps', 4, 2),
        makeGermanInfantry('g6', 'VI Army Corps', 5, 2),
        makeGermanInfantry('g12', 'XII Army Corps', 5, 2),
        makeGermanInfantry('g5', 'V Army Corps', 6, 3),
        makeGermanInfantry('g13', 'XIII Army Corps', 6, 3),
        makeGermanInfantry('g20', 'XX Army Corps', 6, 3),
        makeGermanInfantry('g27', 'XXVII Army Corps', 6, 3),
        makeGermanInfantry('g53', 'LIII Army Corps', 6, 3),
        makeGermanInfantry('g7', 'VII Army Corps', 7, 4),
        makeGermanInfantry('g8', 'VIII Army Corps', 7, 4),
        makeGermanInfantry('g9', 'IX Army Corps', 7, 4),
        makeGermanInfantry('g22', 'XXII Army Corps', 8, 4),
        makeGermanInfantry('g35', 'XXXV Army Corps', 8, 4),
        makeGermanInfantry('g40', 'XL Panzer Corps', 8, 4),
        makeGermanPanzer('g48', 'XLVIII Panzer Corps', 8, 4),
        makeGermanPanzer('g47', 'XLVII Panzer Corps', 9, 4),
        makeGermanPanzer('g56', 'LVI Panzer Corps', 9, 4),
        makeGermanPanzer('g46', 'XLVI Panzer Corps', 10, 5),
        makeGermanPanzer('g24', 'XXIV Panzer Corps', 12, 6),
        makeGermanPanzer('g41', 'XLI Panzer Corps', 12, 6),
        makeGermanPanzer('g57', 'LVII Panzer Corps', 12, 6),
      };

  Unit makeSovietInfantry(String id, String name) => Unit(
        id: id,
        name: name,
        unitType: UnitType.Infantry,
        size: UnitSize.Army,
        faction: Faction.Soviet,
        fullStrength: 8,
        halfStrength: 4,
        movement: 4,
        condition: UnitCondition.HalfStrength,
      );

  Unit makeSovietShock(String id, String name) => Unit(
        id: id,
        name: name,
        unitType: UnitType.Infantry,
        size: UnitSize.Army,
        faction: Faction.Soviet,
        fullStrength: 10,
        halfStrength: 5,
        movement: 4,
        condition: UnitCondition.Postponed,
      );

  Unit makeGermanInfantry(
          String id, String name, int halfStrength, int fullStrength) =>
      Unit(
        id: id,
        name: name,
        unitType: UnitType.Infantry,
        size: UnitSize.Corps,
        faction: Faction.German,
        fullStrength: fullStrength,
        halfStrength: halfStrength,
        movement: 4,
        condition: UnitCondition.FullStrength,
      );

  Unit makeGermanPanzer(
          String id, String name, int halfStrength, int fullStrength) =>
      Unit(
        id: id,
        name: name,
        unitType: UnitType.Panzer,
        size: UnitSize.Corps,
        faction: Faction.German,
        fullStrength: fullStrength,
        halfStrength: halfStrength,
        movement: 6,
        condition: UnitCondition.FullStrength,
      );
}
