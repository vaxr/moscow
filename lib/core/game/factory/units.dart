import 'package:moscow/core/model/units.dart';

class UnitsFactory {
  Units makeStartingUnits() => Units()
    ..addAll(UnitsFactory().makeGermanForces())
    ..addAll(UnitsFactory().makeSovietStartingForces());

  Set<Unit> makeSovietStartingForces() => {
        makeSovietInfantry('s03', '3rd Army'),
        makeSovietInfantry('s05', '5th Army'),
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
      };

  Set<Unit> makeSovietForces() =>
      makeSovietStartingForces()..add(makeSovietShock('s01', '1st Shock Army'));

  Set<Unit> makeGermanForces() => {
        makeGermanInfantry('g05', 'V Army Corps', 6, 3),
        makeGermanInfantry('g06', 'VI Army Corps', 5, 2),
        makeGermanInfantry('g07', 'VII Army Corps', 7, 4),
        makeGermanInfantry('g08', 'VIII Army Corps', 7, 4),
        makeGermanInfantry('g09', 'IX Army Corps', 7, 4),
        makeGermanInfantry('g12', 'XII Army Corps', 5, 2),
        makeGermanInfantry('g13', 'XIII Army Corps', 6, 3),
        makeGermanInfantry('g20', 'XX Army Corps', 6, 3),
        makeGermanInfantry('g23', 'XXIII Army Corps', 8, 4),
        makeGermanPanzer('g24', 'XXIV Panzer Corps', 12, 6),
        makeGermanInfantry('g35', 'XXXV Army Corps', 8, 4),
        makeGermanInfantry('g27', 'XXVII Army Corps', 6, 3),
        makeGermanInfantry('g34', 'XXXIV Army Corps', 4, 2),
        makeGermanPanzer('g40', 'XL Panzer Corps', 8, 4),
        makeGermanPanzer('g41', 'XLI Panzer Corps', 12, 6),
        makeGermanInfantry('g43', 'XLIII Army Corps', 4, 2),
        makeGermanPanzer('g46', 'XLVI Panzer Corps', 10, 5),
        makeGermanPanzer('g47', 'XLVII Panzer Corps', 9, 4),
        makeGermanPanzer('g48', 'XLVIII Panzer Corps', 8, 4),
        makeGermanInfantry('g53', 'LIII Army Corps', 6, 3),
        makeGermanPanzer('g56', 'LVI Panzer Corps', 9, 4),
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
        isHalved: true,
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
        isHalved: false,
      );

  Unit makeGermanInfantry(
          String id, String name, int fullStrength, int halfStrength) =>
      Unit(
        id: id,
        name: name,
        unitType: UnitType.Infantry,
        size: UnitSize.Corps,
        faction: Faction.German,
        fullStrength: fullStrength,
        halfStrength: halfStrength,
        movement: 4,
        isHalved: false,
      );

  Unit makeGermanPanzer(
          String id, String name, int fullStrength, int halfStrength) =>
      Unit(
        id: id,
        name: name,
        unitType: UnitType.Panzer,
        size: UnitSize.Corps,
        faction: Faction.German,
        fullStrength: fullStrength,
        halfStrength: halfStrength,
        movement: 6,
        isHalved: false,
      );
}
