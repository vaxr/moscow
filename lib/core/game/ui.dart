import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/units.dart';

class UIModel {
  GameState gameState;
  Unit selectedGermanReserve;
  bool germanReserveDisabled = false;
  Unit selectedSovietReserve;
  bool sovietReserveDisabled = false;
  Set<Unit> highlightedUnits = {};
  Set<Hex> highlightedHexes = {};
  Unit unitCursor;
  List<String> instructions;
}
