import 'package:moscow/core/game/factory/game.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/ui.dart';

import 'controller/controller.dart';
import 'controller/german-deployment.dart';

class Game {
  final GameState state;
  GameController ctrl;
  UIModel model;

  Game(this.state) {
    model = UIModel(state);
    ctrl = GermanDeploymentController(model);
  }

  factory Game.newDefaultGame() {
    return Game(makeNewGame());
  }

  void endMove() {
    print(ctrl.endMove());
  }
}
