import 'dart:html';

import 'package:moscow/core/model/game.dart';

class MapComponent {

  final CanvasElement canvas;

  double offsetX = 0;
  double offsetY = 0;
  double zoom = 1.0;

  MapComponent(this.canvas);

  void renderBoard(Board board) {
    final ctx = canvas.context2D;
    ctx.setFillColorRgb(128, 128, 128);
    ctx.fillRect(0, 0, canvas.width, canvas.height);
  }
}
