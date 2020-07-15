import 'dart:html';

import 'package:moscow/core/data/board.dart';

import 'board/map.dart';

void main() {
  final canvas = querySelector('#map') as CanvasElement;
  print(canvas);
  final board = makeDefaultBoard();
  final mapComponent = MapComponent(canvas);
  mapComponent.renderBoard(board);
}
