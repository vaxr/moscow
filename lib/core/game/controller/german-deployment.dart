import 'package:moscow/core/game/game.dart';
import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';

import 'controller.dart';

class GermanDeploymentController extends GameController {
  GermanDeploymentController(Game game) : super(game);

  Set<Hex> startingPositions;

  @override
  void init() {
    model.highlightedHexes = game.state.board.germanStartingPositions;
    model.instructions = [
      'Click highlighted hex to deploy unit',
      'Click deployed unit to withdraw',
      'Click reserve to select a different unit',
    ];
    startingPositions = game.state.board.germanStartingPositions;
    _selectBest();
  }

  @override
  void selectHex(Hex hex) {
    if (!startingPositions.contains(hex)) return;
    final displaced = units.byHex[hex];
    if (displaced != null) {
      units.toReserve(displaced);
      selectReserve(displaced);
    } else {
      units.toHex(model.selectedGermanReserve, hex);
      _selectBest();
    }
    model.updateUnits();
  }

  @override
  void hoverHex(Hex hex) {
    // TODO: implement hoverHex
    print('$hex hovered');
  }

  @override
  void hoverReserve(Unit unit) {
    // TODO
    print('$unit hovered');
  }

  @override
  void selectReserve(Unit unit) {
    if (unit?.faction != Faction.German) {
      unit = null;
    }
    model.unitCursor = unit;
    model.selectedGermanReserve = unit;
  }

  void _selectBest() {
    selectReserve(Units.best(units.germanReserve));
  }
}
