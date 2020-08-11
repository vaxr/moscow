import 'package:angular/angular.dart';
import 'package:moscow/core/game/game.dart';
import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/reserve/reserve.component.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';
import 'package:moscow/ng/src/unit/unit.component.dart';
import 'package:moscow/ng/src/util/game_service.dart';

import 'src/board/board.component.dart';

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  providers: [
    UnitRenderer,
    GameService,
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

  final Game game;

  Unit selectedGermanReserve;
  Unit selectedSovietReserve;
  Set<Unit> highlightedUnits = {};
  Set<Hex> highlightedHexes = {};
  Unit unitCursor;

  AppComponent(GameService gameService) : game = gameService.game;

  @override
  void ngOnInit() {
    selectBest();
    highlightedHexes = game.state.board.germanStartingPositions;
  }

  void selectBest() {
    selectReserve(Units.best(game.state.units.germanReserve));
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
    if (!game.state.board.germanStartingPositions.contains(hex)) return;
    final displaced = game.state.units.byHex[hex];
    if (displaced != null) {
      game.state.units.toReserve(displaced);
      selectReserve(displaced);
    } else {
      game.state.units.toHex(selectedGermanReserve, hex);
      selectBest();
    }
    board.redrawUnits();
  }
}
