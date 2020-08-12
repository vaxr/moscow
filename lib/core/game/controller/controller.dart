import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

import '../game.dart';
import '../ui.dart';

abstract class GameController {
  final Game game;
  UIModel model;

  GameController(this.game) {
    model = UIModel();
    model.gameState = game.state;
    init();
  }

  Units get units => model.gameState.units;

  Board get board => model.gameState.board;

  void init();

  void selectReserve(Unit unit);

  void hoverReserve(Unit unit);

  void selectHex(Hex hex);

  void hoverHex(Hex hex);
}
