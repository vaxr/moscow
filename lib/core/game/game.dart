import 'package:moscow/core/game/factory/game.dart';
import 'package:moscow/core/model/game.dart';

class Game {
  final GameState state;

  Game(this.state);

  factory Game.newDefaultGame() {
    return Game(makeNewGame());
  }
}
