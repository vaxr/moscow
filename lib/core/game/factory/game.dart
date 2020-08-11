import 'package:moscow/core/game/factory/units.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

import 'board.dart';

void deploySoviets(Board board, Units units) {
  final remainingSoviets = units.sovietReserve.toList()..shuffle();
  for (final hex in board.sovietStartingPositions) {
    final unit = remainingSoviets.removeLast();
    units.toHex(unit, hex);
  }
}

GameState makeNewGame() {
  final game = GameState()
    ..turn = 1
    ..phase = Phase.GermanDeployment
    ..board = makeDefaultBoard()
    ..units = UnitsFactory().makeStartingUnits();
  deploySoviets(game.board, game.units);
  return game;
}
