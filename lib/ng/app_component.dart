import 'package:angular/angular.dart';
import 'package:moscow/core/game/game.dart';
import 'package:moscow/core/game/ui.dart';
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
    NgFor,
    BoardComponent,
    UnitComponent,
    ReserveComponent,
  ],
)
class AppComponent implements OnInit {
  @ViewChild('board')
  BoardComponent board;

  final Game game;

  UIModel get model => game.ctrl.model;

  AppComponent(GameService gameService) : game = gameService.game;

  @override
  void ngOnInit() {
    game.onRedraw.listen((_) => board.redrawUnits());
  }
}
