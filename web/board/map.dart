import 'dart:html';
import 'dart:math';
import 'dart:web_gl';

import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';

class MapComponent {
  final CanvasElement canvas;

  static const hexSize = 64.0;
  static const double boardW = 1600;
  static const double boardH = 1200;

  double offsetX = 0;
  double offsetY = 0;
  double zoom = 1.0;

  MapComponent(this.canvas);

  CanvasElement _board;

  CanvasElement _makeCanvas() {
    final c = canvas.ownerDocument.createElement('canvas') as CanvasElement;
    c.width = boardW.floor();
    c.height = boardH.floor();
    return c;
  }

  XY transformXY(XY xy) => XY((xy.x - 0.25) * hexSize, (xy.y + 0.25) * hexSize);

  Path2D hexPath(Hex hex) {
    final path = Path2D();
    final outline = hex.outlineXY;
    final lastXy = transformXY(outline.last);
    path.moveTo(lastXy.x, lastXy.y);
    for (final corner in hex.outlineXY) {
      final xy = transformXY(corner);
      path.lineTo(xy.x, xy.y);
    }
    return path;
  }

  void renderBoard(Board data) {
    if (_board == null) {
      _board = _makeCanvas();
      final ctx = _board.context2D;

      // base terrain
      ctx.setFillColorRgb(204, 255, 102);
      for (final hex in Board.allHexes) {
        ctx.fill(hexPath(hex));
      }

      // forest
      ctx.setFillColorRgb(51, 102, 0);
      for (final hex in data.forest) {
        ctx.fill(hexPath(hex));
      }

      // fortifications
      ctx.setFillColorRgb(160, 160, 160);
      for (final hex in data.fortifications) {
        ctx.fill(hexPath(hex));
      }

      // cities
      ctx.setStrokeColorRgb(0, 0, 0);
      ctx.lineWidth = hexSize / 16;
      ctx.setFillColorRgb(255, 0, 0);
      for (final hex in data.cities.keys) {
        final city = data.cities[hex];
        print(city);
        final center = transformXY(hex.centerXY);
        final radius = hexSize / (city.isMoscow ? 3 : 5);
        ctx.beginPath();
        ctx.arc(center.x, center.y, radius, 0, 2 * pi);
        ctx.fill();
        ctx.stroke();
      }

      // grid
      ctx.lineWidth = hexSize / 16;
      ctx.setStrokeColorRgb(0, 0, 0, 0.25);
      for (final hex in Board.allHexes) {
        ctx.stroke(hexPath(hex));
      }
    }
  }

  void render(Table table) {
    renderBoard(table.board);
    final ctx = canvas.context2D;
    for (final src in [_board]) {
      ctx.drawImageScaledFromSource(
        src,
        0,
        0,
        src.width,
        src.height,
        offsetX,
        offsetY,
        canvas.width * zoom,
        canvas.height * zoom,
      );
    }
  }
}
