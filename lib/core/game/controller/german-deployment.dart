import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/ui.dart';
import 'package:moscow/core/model/units.dart';

import 'controller.dart';

class GermanDeploymentController extends GameController {
  GermanDeploymentController(UIModel model) : super(model);

  final move = Move();
  Set<Hex> startingPositions;

  @override
  void init() {
    model.highlightedHexes = board.germanStartingPositions;
    model.instructions = [
      'Click highlighted hex to deploy unit',
      'Click deployed unit to withdraw',
      'Click reserve to select a different unit',
    ];
    startingPositions = board.germanStartingPositions;
    _selectBest();
  }

  @override
  void selectHex(Hex hex) {
    if (!startingPositions.contains(hex)) return;
    final displaced = units.byHex[hex];
    if (displaced != null) {
      units.toReserve(displaced);
      selectReserve(displaced);
      move.positions.remove(displaced);
    } else {
      move.positions[model.selectedGermanReserve] = hex;
      units.toHex(model.selectedGermanReserve, hex);
      _selectBest();
    }
    model.canEndMove = units.germanReserve.isEmpty;
    model.updateUnits();
  }

  @override
  void hoverHex(Hex hex) {
    // TODO
  }

  @override
  void hoverReserve(Unit unit) {
    // TODO
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

  void quickDeploy() {
    selectHex(Hex(3, 5));
    selectHex(Hex(4, 6));
    selectHex(Hex(2, 3));
    selectHex(Hex(4, 7));
    selectHex(Hex(2, 2));
    selectHex(Hex(4, 8));
    selectHex(Hex(2, 1));
    selectHex(Hex(4, 9));
    selectHex(Hex(2, 4));
    selectHex(Hex(3, 6));
    selectHex(Hex(4, 10));
    selectHex(Hex(3, 7));
    selectHex(Hex(2, 5));
    selectHex(Hex(3, 9));
    selectHex(Hex(3, 10));
    selectHex(Hex(1, 3));
    selectHex(Hex(1, 4));
    selectHex(Hex(2, 6));
    selectHex(Hex(2, 9));
    selectHex(Hex(1, 6));
    selectHex(Hex(1, 7));
    selectHex(Hex(2, 10));
  }

  @override
  Move endMove() {
    return move;
  }
}
