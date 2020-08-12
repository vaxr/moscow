import 'dart:async';

import 'package:moscow/core/game/factory/game.dart';
import 'package:moscow/core/game/ui.dart';
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

  Stream<UIModel> get onRedraw => _onRedraw.stream;
  final _onRedraw = StreamController<UIModel>.broadcast();

  void redraw(UIModel model) {
    _onRedraw.add(model);
  }
}
