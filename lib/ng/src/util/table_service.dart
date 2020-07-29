import 'package:angular/core.dart';
import 'package:moscow/core/data/board.dart';
import 'package:moscow/core/data/units.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

@Injectable()
class TableService {
  Table makeTable() {
    void _populateUnits(Table table) {
      final germans = UnitsFactory().makeGermanForces();
      final soviets = UnitsFactory().makeSovietForces();
      final all = <Unit>{}..addAll(germans)..addAll(soviets);

      table.units.byId = {for (var u in all) u.id: u};

      table.units.sovietReserve.addAll(soviets);
      table.units.sovietReserve.removeWhere((u) => u.id == 's1');
      final remainingSoviets = table.units.sovietReserve.toList()..shuffle();
      for (final hex in table.board.sovietStartingPositions) {
        final unit = remainingSoviets.removeLast();
        table.board.units[hex] = unit;
        table.units.sovietReserve.remove(unit);
        table.units.sovietActive.add(unit);
      }

      table.units.germanReserve.addAll(germans);
//      final remainingGermans = table.units.germanReserve.toList()..shuffle();
//      for (final hex in table.board.germanStartingPositions) {
//        final unit = remainingGermans.removeLast();
//        table.board.units[hex] = unit;
//        table.units.germanReserve.remove(unit);
//        table.units.germanActive.add(unit);
//      }
    }

    final table = Table()
      ..board = makeDefaultBoard()
      ..units = UnitStore();
    _populateUnits(table);
    return table;
  }
}
