import 'package:angular/core.dart';
import 'package:moscow/core/data/board.dart';
import 'package:moscow/core/data/units.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

@Injectable()
class TableService {
  Table makeTable() {
    void _deploySoviets(Board board, Units units) {
      final remainingSoviets = units.sovietReserve.toList()..shuffle();
      for (final hex in board.sovietStartingPositions) {
        final unit = remainingSoviets.removeLast();
        units.toHex(unit, hex);
      }
    }

    final table = Table()
      ..board = makeDefaultBoard()
      ..units = UnitsFactory().makeStartingUnits();
    _deploySoviets(table.board, table.units);
    return table;
  }
}
