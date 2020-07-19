import 'dart:html';
import 'dart:math';

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

  MapComponent(this.canvas, this.table);

  Table table;
  Set<Hex> _highlightedHexes;
  set highlights(Set<Hex> hexes) {
    _highlightedHexes = hexes;
    _redrawHighlights = true;
  }

  CanvasElement _boardCanvas;
  CanvasElement _highlightCanvas;
  bool redrawBoard = true;
  bool _redrawHighlights = true;

  CanvasElement _makeCanvas() {
    final c = canvas.ownerDocument.createElement('canvas') as CanvasElement;
    c.width = boardW.floor();
    c.height = boardH.floor();
    return c;
  }

  XY _transformXY(XY xy) =>
      XY((xy.x - 0.25) * hexSize, (xy.y + 0.25) * hexSize);

  Path2D _hexPath(Hex hex) {
    final path = Path2D();
    final outline = hex.cornersXY;
    final lastXy = _transformXY(outline.last);
    path.moveTo(lastXy.x, lastXy.y);
    for (final corner in hex.cornersXY) {
      final xy = _transformXY(corner);
      path.lineTo(xy.x, xy.y);
    }
    return path;
  }

  void _renderBoard() {
    _boardCanvas ??= _makeCanvas();
    if (redrawBoard) {
      redrawBoard = false;
      final ctx = _boardCanvas.context2D;
      final data = table.board;

      // base terrain
      ctx.setFillColorRgb(204, 255, 102);
      for (final hex in Board.allHexes) {
        ctx.fill(_hexPath(hex));
      }

      // forest
      ctx.setFillColorRgb(51, 102, 0);
      for (final hex in data.forest) {
        ctx.fill(_hexPath(hex));
      }

      // fortifications
      ctx.setFillColorRgb(160, 160, 160);
      for (final hex in data.fortifications) {
        ctx.fill(_hexPath(hex));
      }

      // rivers
      ctx.setStrokeColorRgb(0, 51, 224);
      ctx.lineWidth = hexSize / 8;
      for (final river in data.rivers) {
        final corners = river.cornersXY.map((xy) => _transformXY(xy)).toList();
        ctx.moveTo(corners[0].x, corners[0].y);
        ctx.lineTo(corners[1].x, corners[1].y);
        ctx.stroke();
      }

      // railroads
      ctx.beginPath();
      ctx.setStrokeColorRgb(255, 0, 0);
      ctx.lineWidth = hexSize / 16;
      const long = hexSize / 3;
      const short = hexSize / 12;
      ctx.setLineDash([long, short, short, short, short, short]);
      for (final hex in data.railroads.keys) {
        if (!Board.allHexes.contains(hex)) continue;
        final edges = data.railroads[hex].toList();
        if (edges.length != 2 || data.cities.containsKey(hex)) {
          final hexCenter = _transformXY(hex.centerXY);
          for (final edge in edges) {
            final edgeCenter = _transformXY(edge.centerXY);
            ctx.moveTo(hexCenter.x, hexCenter.y);
            ctx.lineTo(edgeCenter.x, edgeCenter.y);
            ctx.stroke();
          }
        } else {
          final fromCenter = _transformXY(edges[0].centerXY);
          final toCenter = _transformXY(edges[1].centerXY);
          ctx.moveTo(fromCenter.x, fromCenter.y);
          ctx.lineTo(toCenter.x, toCenter.y);
          ctx.stroke();
        }
      }
      ctx.setLineDash([]);

      // cities
      ctx.setStrokeColorRgb(0, 0, 0);
      ctx.lineWidth = hexSize / 16;
      ctx.setFillColorRgb(255, 0, 0);
      for (final hex in data.cities.keys) {
        final city = data.cities[hex];
        final center = _transformXY(hex.centerXY);
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
        ctx.stroke(_hexPath(hex));
      }
    }
  }

  void _renderHighlights() {
    _highlightCanvas ??= _makeCanvas();
    if (_redrawHighlights) {
      _redrawHighlights = false;
      final ctx = _highlightCanvas.context2D;

      ctx.clearRect(0, 0, _highlightCanvas.width, _highlightCanvas.height);
      if (_highlightedHexes.isEmpty) return;

      final darkHexes =
          Board.allHexes.where((h) => !_highlightedHexes.contains(h));
      ctx.setFillColorRgb(0, 0, 0, 0.4);
      for (final hex in darkHexes) {
        ctx.fill(_hexPath(hex));
      }

      ctx.lineWidth = hexSize / 16;
      ctx.setStrokeColorRgb(255, 255, 255, 0.6);
      for (final hex in _highlightedHexes) {
        final north = _transformXY(hex.cornerXY(Direction.NorthWest)).y;
        final south = _transformXY(hex.cornerXY(Direction.SouthWest)).y;
        final west = _transformXY(hex.cornerXY(Direction.NorthWest)).x;
        final east = _transformXY(Edge.fromHex(hex, Direction.South).centerXY).x;
        ctx.fillStyle = ctx.createLinearGradient(west, north, east, south)
          ..addColorStop(0.00, '#ffffff00')
          ..addColorStop(0.80, '#ffffff30')
          ..addColorStop(1.00, '#ffffffb0');
        final path = _hexPath(hex);
        ctx.fill(path);
        ctx.stroke(path);
      }
    }
  }

  void render() {
    _renderBoard();
    _renderHighlights();
    final ctx = canvas.context2D;
    for (final src in [_boardCanvas, _highlightCanvas]) {
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
