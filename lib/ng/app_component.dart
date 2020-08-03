import 'package:angular/angular.dart';
import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/reserve/reserve.component.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';
import 'package:moscow/ng/src/unit/unit.component.dart';
import 'package:moscow/ng/src/util/table_service.dart';

import 'src/board/board.component.dart';

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  providers: [
    UnitRenderer,
  ],
  directives: [
    BoardComponent,
    UnitComponent,
    ReserveComponent,
  ],
)
class AppComponent implements OnInit {
  @ViewChild('board')
  BoardComponent board;

  Table table;

  Unit selectedGermanReserve;
  Unit selectedSovietReserve;
  Set<Unit> highlightedUnits = {};
  Unit unitCursor;

  @override
  void ngOnInit() {
    table = TableService().makeTable();
    selectBest();

//    final unitList = table.units.byId.values.toList();
//    for (var i = 0; i < unitList.length; i++) {
//      if (i % 3 == 0) {
//        highlightedUnits.add(unitList[i]);
//      }
//    }
  }

  void selectBest() {
    selectReserve(Units.best(table.units.germanReserve));
  }

  void selectReserve(Unit unit) {
    if (unit.faction == Faction.Soviet) {
      selectedSovietReserve = unit;
    } else {
      selectedGermanReserve = unit;
    }
    unitCursor = unit;
  }

  void hoverReserve(Unit unit) {
    print('$unit hovered');
  }

  void clickHex(Hex hex) {
    if (!table.board.germanStartingPositions.contains(hex)) return;
    final displaced = table.units.byHex[hex];
    if (displaced != null) {
      table.units.toReserve(displaced);
      selectReserve(displaced);
    } else {
      table.units.toHex(selectedGermanReserve, hex);
      selectBest();
    }
    board.redrawUnits();
  }
}
