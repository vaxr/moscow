import 'package:moscow/core/game/controller/german-deployment.dart';
import 'package:moscow/core/game/game.dart';
import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/ui.dart';
import 'package:test/test.dart';

void main() {
  group(GermanDeploymentController, () {
    Game game;
    GermanDeploymentController ctrl;

    setUp(() {
      game = Game.newDefaultGame();
      ctrl = GermanDeploymentController(UIModel(game.state));
      game.ctrl = ctrl;
    });

    test('can happily deploy a real game in order and end move', () {
      expect(game.state.units.germanReserve.length, 22);

      final positions = game.state.board.germanStartingPositions.toList();
      final startingUnits = game.state.units.germanReserve.length;
      for (var i = 0; i < startingUnits; i++) {
        expect(ctrl.model.canEndMove, false);
        ctrl.selectHex(positions[i]);
      }

      expect(game.state.units.germanReserve.length, 0);
      expect(ctrl.model.canEndMove, true);
    });

    test('can use quick deployment and end move', () {
      expect(game.state.units.germanReserve.length, 22);
      ctrl.quickDeploy();
      expect(game.state.units.germanReserve.length, 0);
      expect(ctrl.model.canEndMove, true);
    });

    test('Removing a unit from full deployment blocks end move', () {
      ctrl.quickDeploy();
      expect(ctrl.model.canEndMove, true);

      ctrl.selectHex(game.state.board.germanStartingPositions.first);
      expect(ctrl.model.canEndMove, false);
    });

    test('clicking an empty starting position places selected unit there', () {
      final reservesBefore = game.state.units.germanReserve.length;
      final selectedReserveBefore = ctrl.model.selectedGermanReserve;
      final hex = game.state.board.germanStartingPositions.first;

      ctrl.selectHex(hex);

      expect(game.state.units.byHex[hex], selectedReserveBefore);
      expect(ctrl.model.selectedGermanReserve != selectedReserveBefore, true,
          reason: 'a different reserve should be selected now');
      expect(game.state.units.germanReserve.length, reservesBefore - 1);
    });

    test('clicking an occupied starting position recalls unit to reserve', () {
      final hex = game.state.board.germanStartingPositions.first;
      ctrl.selectHex(hex);
      final reservesBefore = game.state.units.germanReserve.length;
      final placedUnit = game.state.units.byHex[hex];

      ctrl.selectHex(hex);

      expect(game.state.units.byHex[hex], null);
      expect(ctrl.model.selectedGermanReserve == placedUnit, true,
          reason: 'a different reserve should be selected now');
      expect(game.state.units.germanReserve.length, reservesBefore + 1);
    });

    test('clicking outside starting positions doesn\'t do anything', () {
      final reservesBefore = game.state.units.germanReserve.length;
      ctrl.selectHex(Hex(8, 1));
      expect(game.state.units.germanReserve.length, reservesBefore);
    });

    test('clicking a reserve selects it', () {
      final selectedBefore = ctrl.model.selectedGermanReserve;
      final toSelect =
          game.state.units.germanReserve.firstWhere((u) => u != selectedBefore);

      ctrl.selectReserve(toSelect);

      expect(ctrl.model.selectedGermanReserve, toSelect);
    });

    test('endMove generates correct Move', () {
      ctrl.quickDeploy();
      final move = ctrl.endMove();
      for (final unit in game.state.units.germanActive) {
        expect(move.positions[unit], game.state.units.byHex.inverse[unit]);
      }
    });
  });
}
