import 'dart:html';

import 'package:moscow/core/data/board.dart';
import 'package:moscow/core/model/game.dart';

import 'board/map.dart';

void main() {
  final table = Table()
  ..board = makeDefaultBoard()
  ..units = UnitStore();

  final canvas = querySelector('#map') as CanvasElement;
  final mapComponent = MapComponent(canvas, table);
//  mapComponent.highlights = table.board.sovietStartingPositions;
//  mapComponent.highlights = table.board.germanStartingPositions;
  mapComponent.highlights = {};
  mapComponent.render();
}
