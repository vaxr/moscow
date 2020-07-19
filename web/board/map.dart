import 'dart:html';
import 'dart:math';

import 'package:moscow/core/map/grid.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';

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
  CanvasElement _unitsCanvas;
  CanvasElement _highlightCanvas;
  bool redrawBoard = true;
  bool redrawUnits = true;
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

      // grid
      ctx.lineWidth = hexSize / 16;
      ctx.setStrokeColorRgb(0, 0, 0, 0.25);
      for (final hex in Board.allHexes) {
        ctx.stroke(_hexPath(hex));
      }

      // cities
      ctx.setStrokeColorRgb(0, 0, 0);
      for (final hex in data.cities.keys) {
        ctx.lineWidth = hexSize / 16;
        final city = data.cities[hex];
        final center = _transformXY(hex.centerXY);
        final radius = hexSize / (city.isMoscow ? 3 : 5);
        if (city.holder == Faction.German) {
          ctx.setFillColorRgb(102, 153, 153);
        } else {
          ctx.setFillColorRgb(255, 0, 0);
        }
        ctx.beginPath();
        ctx.arc(center.x, center.y, radius, 0, 2 * pi);
        ctx.fill();
        ctx.stroke();

        ctx.setFillColorRgb(255, 255, 255);
        ctx.textAlign = 'center';
        ctx.font = 'normal ${(radius * 2).round()}px sans-serif';
        ctx.shadowColor = 'black';
        ctx.shadowBlur = hexSize / 4;
        final captionCenter = center + XY(0, radius * 3);
        ctx.fillText(city.name, captionCenter.x, captionCenter.y);
        ctx.shadowColor = 'transparent';
      }
    }
  }

  void _drawUnit(
      CanvasRenderingContext2D ctx, Unit unit, XY center, double size) {
    // square
    ctx.setStrokeColorRgb(64, 64, 64);
    ctx.setFillColorRgb(224, 224, 224);
    ctx.lineWidth = hexSize / 32;
    final squareTopLeft = center + XY(-size / 2, -size / 2);
    ctx.beginPath();
    ctx.rect(squareTopLeft.x, squareTopLeft.y, size, size);
    ctx.fill();
    ctx.stroke();

    // unit symbol
    ctx.setStrokeColorRgb(0, 0, 0);
    if (unit.faction == Faction.German) {
      ctx.setFillColorRgb(102, 153, 153);
    } else {
      ctx.setFillColorRgb(204, 153, 0);
    }
    ctx.lineWidth = hexSize / 16;
    final symbolW = 0.7 * size;
    final symbolH = symbolW / 1.5;
    final symbolTopLeft = center + XY(-symbolW / 2, -symbolH * 0.6);
    ctx.beginPath();
    ctx.rect(symbolTopLeft.x, symbolTopLeft.y, symbolW, symbolH);
    ctx.fill();
    ctx.stroke();
    switch (unit.unitType) {
      case UnitType.Infantry:
        ctx.moveTo(symbolTopLeft.x, symbolTopLeft.y);
        ctx.lineTo(symbolTopLeft.x + symbolW, symbolTopLeft.y + symbolH);
        ctx.moveTo(symbolTopLeft.x, symbolTopLeft.y + symbolH);
        ctx.lineTo(symbolTopLeft.x + symbolW, symbolTopLeft.y);
        ctx.stroke();
        break;
      case UnitType.Panzer:
        final padding = symbolH * 0.25;
        final radius = symbolH / 2 - padding;
        final left = symbolTopLeft.x + padding + radius;
        final right = symbolTopLeft.x + symbolW - padding - radius;
        final top = symbolTopLeft.y + padding;
        final bottom = symbolTopLeft.y + symbolH - padding;
        final middle = symbolTopLeft.y + symbolH / 2;
        ctx.moveTo(left, top);
        ctx.lineTo(right, top);
        ctx.moveTo(left, bottom);
        ctx.lineTo(right, bottom);
        ctx.arc(left, middle, radius, 0.5 * pi, 1.5 * pi);
        ctx.arc(right, middle, radius, 1.5 * pi, 0.5 * pi);
        ctx.stroke();
        break;
      default:
        break;
    }

    // text
    ctx.setFillColorRgb(0, 0, 0);
    ctx.textAlign = 'center';
    // header
    final headerText = UnitSizeSymbols[unit.size];
    final headerCenter = center + XY(0, -size * 0.32);
    ctx.font = 'normal bold ${(size * 0.15).round()}px sans-serif';
    ctx.fillText(headerText, headerCenter.x, headerCenter.y);
    // footer
    final footerText =
        '${unit.strength}${unit.isHalved ? '/${unit.fullStrength}' : ''} - ${unit.speed}';
    final footerCenter = center + XY(0, size * 0.44);
    ctx.font = 'normal bold ${(size * 0.26).round()}px sans-serif';
    ctx.fillText(footerText, footerCenter.x, footerCenter.y);
  }

  void _renderUnits() {
    _unitsCanvas ??= _makeCanvas();
    if (redrawUnits) {
      redrawUnits = false;
      final ctx = _unitsCanvas.context2D;
      final data = table.units;

      for (final hex in data.positions.inverse.keys) {
        final unit = data.positions.inverse[hex];
        _drawUnit(ctx, unit, _transformXY(hex.centerXY), hexSize * 1.4);
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
        final east =
            _transformXY(Edge.fromHex(hex, Direction.South).centerXY).x;
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
    _renderUnits();
    _renderHighlights();
    final ctx = canvas.context2D;
    for (final src in [_boardCanvas, _unitsCanvas, _highlightCanvas]) {
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
