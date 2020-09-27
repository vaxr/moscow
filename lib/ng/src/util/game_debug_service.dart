class GameDebugService {
  final game;

  GameDebugService(this.game);

  void setup() {
    game.ctrl.quickDeploy();
  }
}
