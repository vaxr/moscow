import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

import '../../model/ui.dart';

abstract class GameController {
  final UIModel model;

  GameController(this.model) {
    init();
  }

  Units get units => model.gameState.units;

  Board get board => model.gameState.board;

  void init();

  Move endMove();

  void selectReserve(Unit unit);

  void hoverReserve(Unit unit);

  void selectHex(Hex hex);

  void hoverHex(Hex hex);
}
