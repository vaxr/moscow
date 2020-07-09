import 'package:moscow_rules/model/player.dart';
import 'package:moscow_rules/model/units.dart';

class UnitsFactory {
  String ordinal(int number) {
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  List<Unit> makeSovietForces() {
    return <Unit>[
      makeSovietInfantry('si3', '3rd Army'),
      makeSovietInfantry('si5', '5th Army'),
      makeSovietInfantry('si10', '10th Army'),
      makeSovietInfantry('si13', '13th Army'),
      makeSovietInfantry('si16', '16th Army'),
      makeSovietInfantry('si19', '19th Army'),
      makeSovietInfantry('si20', '20th Army'),
      makeSovietInfantry('si24', '24th Army'),
      makeSovietInfantry('si29', '29th Army'),
      makeSovietInfantry('si30', '30th Army'),
      makeSovietInfantry('si32', '32nd Army'),
      makeSovietInfantry('si33', '33rd Army'),
      makeSovietInfantry('si40', '40th Army'),
      makeSovietInfantry('si43', '43rd Army'),
      makeSovietInfantry('si49', '49th Army'),
      makeSovietInfantry('si50', '50th Army'),
      makeSovietShock('ss', '1st Shock Army'),
    ];
  }

  List<Unit> makeGermanForces() {
    return <Unit>[
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
    ];
  }

  Unit  makeSovietInfantry(String id, String name) {
    var item = Unit();
    item.id = id;
    item.name = name;
    item.unitType = UnitType.Infantry;
    item.size = UnitSize.Army;
    item.faction = Faction.Soviet;
    item.fullStrength = 8;
    item.halfStrength = 4;
    item.movement = 4;
    item.status = UnitStatus.HalfStrength;
    return item;
  }

  Unit makeSovietShock(String id, String name) {
    var item = Unit();
    item.id = id;
    item.name = name;
    item.unitType = UnitType.Infantry;
    item.size = UnitSize.Army;
    item.faction = Faction.Soviet;
    item.fullStrength = 10;
    item.halfStrength = 5;
    item.movement = 4;
    item.status = UnitStatus.Postponed;
    return item;
  }

  Unit makeGermanInfantry(String id, String name, int halfStrength,
      int fullStrength) {
    var item = Unit();
    item.id = id;
    item.name = name;
    item.unitType = UnitType.Infantry;
    item.size = UnitSize.Corps;
    item.faction = Faction.German;
    item.fullStrength = fullStrength;
    item.halfStrength = halfStrength;
    item.movement = 4;
    item.status = UnitStatus.FullStrength;
    return item;
  }

  Unit makeGermanPanzer(String id, String name, int halfStrength,
      int fullStrength) {
    var item = Unit();
    item.id = id;
    item.name = name;
    item.unitType = UnitType.Panzer;
    item.size = UnitSize.Corps;
    item.faction = Faction.German;
    item.fullStrength = fullStrength;
    item.halfStrength = halfStrength;
    item.movement = 6;
    item.status = UnitStatus.FullStrength;
    return item;
  }
}
