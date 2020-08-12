import 'package:moscow/core/game/factory/game.dart';
import 'package:moscow/core/model/game.dart';

import 'controller/controller.dart';
import 'controller/german-deployment.dart';

class Game {
  final GameState state;
  GameController ctrl;

  Game(this.state) {
    ctrl = GermanDeploymentController(this);
  }

  factory Game.newDefaultGame() {
    return Game(makeNewGame());
  }
}
