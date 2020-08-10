import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';

import '../../../core/map/grid.dart';
import '../../../core/model/game.dart';
import '../../../core/model/player.dart';

@Component(
  selector: 'app-board',
  styleUrls: [],
  template: '<canvas #canvas width="800" height="600"></canvas>',
  directives: [],
  providers: [],
)
class BoardComponent implements AfterViewInit, AfterChanges {
  @ViewChild('canvas')
  CanvasElement canvas;

  @Input()
  Board board;

  @Input()
  Units units;

  final UnitRenderer _unitRenderer;

  BoardComponent(this._unitRenderer);

  // TODO implement change logic

  @override
  Future<Null> ngAfterViewInit() async {
    canvas.onClick.listen(onClick);
    canvas.onMouseMove.listen(onMouseMove);
    onCursorMoved.listen((_) => render());
    render();
  }

  static const hexSize = 64.0;
  static const double boardW = 1600;
  static const double boardH = 1200;

  double offsetX = 0;
  double offsetY = 0;
  double zoom = 1.0;

  @Input()
  set highlightedHexes(Set<Hex> hexes) {
    _highlightedHexes = hexes;
    _redrawHighlights = true;
  }

  Set<Hex> _highlightedHexes = {};

  bool hexIsDark(Hex hex) =>
      _highlightedHexes != null &&
      _highlightedHexes.isNotEmpty &&
      !_highlightedHexes.contains(hex);

  @Input()
  set highlightedUnits(Set<Unit> units) {
    _highlightedUnits = units;
    _redrawUnits = true;
  }

  Set<Unit> _highlightedUnits = {};

  @Input()
  set unitCursor(Unit unit) {
    _unitCursor = unit;
    _redrawCursor = true;
  }

  Unit _unitCursor;

  @Output()
  Stream<Hex> get onCursorMoved => _onCursorMoved.stream;
  final StreamController<Hex> _onCursorMoved =
      StreamController<Hex>.broadcast();

  @Output()
  Stream<Hex> get onHexClicked => _onHexClicked.stream;
  final StreamController<Hex> _onHexClicked = StreamController<Hex>.broadcast();

  CanvasElement _boardCanvas;
  CanvasElement _unitsCanvas;
  CanvasElement _highlightCanvas;
  CanvasElement _cursorCanvas;
  bool redrawBoard = true;
  bool _redrawUnits = true;
  bool _redrawHighlights = true;
  bool _redrawCursor = true;
  Hex _cursorHex;

  void redrawUnits() {
    _redrawUnits = true;
    _redrawCursor = true;
    render();
  }

  CanvasElement _makeCanvas() {
    final c = canvas.ownerDocument.createElement('canvas') as CanvasElement;
    c.width = boardW.floor();
    c.height = boardH.floor();
    return c;
  }

  Point _gridToLayer(GridXY g) =>
      Point((g.x - 0.25) * hexSize, (g.y + 0.25) * hexSize);

  GridXY _layerToGrid(Point p) =>
      GridXY(p.x / hexSize + 0.25, p.y / hexSize - 0.25);

  Point _canvasToLayer(Point p) => Point(
        (p.x + offsetX) * boardW / canvas.width / zoom,
        (p.y + offsetY) * boardW / canvas.width / zoom,
      );

  GridXY _canvasToGrid(Point p) => _layerToGrid(_canvasToLayer(p));

  Path2D _hexPath(Hex hex) {
    final path = Path2D();
    final pos1 = _gridToLayer(hex.cornersXY[0]);
    path.moveTo(pos1.x, pos1.y);
    for (final corner in hex.cornersXY.skip(1)) {
      final pos = _gridToLayer(corner);
      path.lineTo(pos.x, pos.y);
    }
    path.closePath();
    return path;
  }

  Path2D _hexesPath(Iterable<Hex> hexes) {
    final path = Path2D();
    for (final island in Hexes.connectedGroups(hexes)) {
      final borders = Hexes.borders(island);
      if (borders.isNotEmpty) {
        path.addPath(_borderPath(borders[0], reverse: false));
      }
      for (final border in borders.skip(1)) {
        path.addPath(_borderPath(border, reverse: true));
      }
    }
    return path;
  }

  Path2D _borderPath(List<Edge> border, {bool reverse: false}) {
    var points = <Point>[];
    var lastPoint;
    for (final edge in border) {
      var from = _gridToLayer(edge.cornersXY[0]);
      var to = _gridToLayer(edge.cornersXY[1]);
      if (lastPoint == null) {
        points.add(from);
      }
      points.add(to);
    }
    if (reverse) {
      points = points.reversed.toList();
    }

    final path = Path2D();
    path.moveTo(points[0].x, points[0].y);
    for (final point in points) {
      path.lineTo(point.x, point.y);
    }
    return path;
  }

  void _renderBoard() {
    _boardCanvas ??= _makeCanvas();
    if (redrawBoard) {
      redrawBoard = false;
      final ctx = _boardCanvas.context2D;

      // background
      ctx.setFillColorRgb(0, 32, 64);
      ctx.fillRect(0, 0, _boardCanvas.width, _boardCanvas.height);

      // base terrain
      ctx.setFillColorRgb(204, 255, 102);
      for (final hex in Board.allHexes) {
        ctx.fill(_hexPath(hex));
      }

      // forest
      ctx.setFillColorRgb(51, 102, 0);
      for (final hex in board.forest) {
        ctx.fill(_hexPath(hex));
      }

      // fortifications
      ctx.setFillColorRgb(160, 160, 160);
      for (final hex in board.fortifications) {
        ctx.fill(_hexPath(hex));
      }

      // rivers
      ctx.setStrokeColorRgb(0, 51, 224);
      ctx.lineWidth = hexSize / 8;
      for (final river in board.rivers) {
        final corners = river.cornersXY.map((xy) => _gridToLayer(xy)).toList();
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
      for (final hex in board.railroads.keys) {
        if (!Board.allHexes.contains(hex)) continue;
        final edges = board.railroads[hex].toList();
        if (edges.length != 2 || board.cities.containsKey(hex)) {
          final hexCenter = _gridToLayer(hex.centerXY);
          for (final edge in edges) {
            final edgeCenter = _gridToLayer(edge.centerXY);
            ctx.moveTo(hexCenter.x, hexCenter.y);
            ctx.lineTo(edgeCenter.x, edgeCenter.y);
            ctx.stroke();
          }
        } else {
          final fromCenter = _gridToLayer(edges[0].centerXY);
          final toCenter = _gridToLayer(edges[1].centerXY);
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
      for (final hex in board.cities.keys) {
        ctx.lineWidth = hexSize / 16;
        final city = board.cities[hex];
        final center = _gridToLayer(hex.centerXY);
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
        final captionCenter = center + Point(0, radius * 3);
        ctx.fillText(city.name, captionCenter.x, captionCenter.y);
        ctx.shadowColor = 'transparent';
      }
    }
  }

  void _renderUnits() {
    _unitsCanvas ??= _makeCanvas();
    if (_redrawUnits) {
      _redrawUnits = false;
      final ctx = _unitsCanvas.context2D;
      ctx.clearRect(0, 0, _unitsCanvas.width, _unitsCanvas.height);

      for (final hex in units.byHex.keys) {
        final unit = units.byHex[hex];
        var backColor = UnitRenderer.colorBack;
        var frameColor = UnitRenderer.colorFrame;
        if (_highlightedUnits?.contains(unit) ?? false) {
          backColor = UnitRenderer.colorBackHighlight;
        } else if (!(_highlightedHexes?.contains(hex) ?? false)) {
          backColor = UnitRenderer.colorBackDark;
          frameColor = UnitRenderer.colorFrameDark;
        }
        _unitRenderer.draw(
          ctx,
          unit,
          _gridToLayer(hex.centerXY),
          hexSize * 1.4,
          backColor: backColor,
          frameColor: frameColor,
        );
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
      ctx.setFillColorRgb(64, 64, 64, 0.7);
      ctx.fill(_hexesPath(darkHexes));

      ctx.lineWidth = hexSize / 12;
      ctx.setStrokeColorRgb(255, 255, 255, 1.0);
      final path = _hexesPath(_highlightedHexes);
      ctx.stroke(path);
    }
  }

  void _renderCursor() {
    _cursorCanvas ??= _makeCanvas();
    if (_redrawCursor) {
      _redrawCursor = false;
      final ctx = _cursorCanvas.context2D;
      ctx.clearRect(0, 0, _cursorCanvas.width, _cursorCanvas.height);

      // hover or unit cursor
      if (!hexIsDark(_cursorHex)) {
        final unit = units.byHex[_cursorHex] ?? _unitCursor;
        if (unit != null) {
          var backColor = UnitRenderer.colorBack;
          var frameColor = UnitRenderer.colorFrame;
          if (unit != _unitCursor) {
            backColor = _highlightedUnits.contains(unit)
                ? UnitRenderer.colorBackHighlight
                : UnitRenderer.colorBack;
            frameColor = UnitRenderer.colorFrameHighlight;
          }
          _unitRenderer.draw(
            ctx,
            unit,
            _gridToLayer(_cursorHex.centerXY),
            hexSize * 1.4,
            backColor: backColor,
            frameColor: frameColor,
            alpha: unit == _unitCursor ? 0.7 : 1.0,
          );
        }
      }
    }
  }

  void render() {
    _renderBoard();
    _renderUnits();
    _renderHighlights();
    _renderCursor();
    final ctx = canvas.context2D;
    for (final src in [
      _boardCanvas,
      _highlightCanvas,
      _unitsCanvas,
      _cursorCanvas,
    ]) {
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

  Hex _canvasToHex(Point p) {
    final gridXY = _canvasToGrid(p);
    final hex = Hex.fromCube(CubeCoords.fromXY(gridXY).rounded);
    if (!Board.allHexes.contains(hex)) {
      return null;
    }
    return hex;
  }

  void _updateCursor(Hex hex) {
    if (hex != _cursorHex) {
      _cursorHex = hex;
      _redrawCursor = true;
      _onCursorMoved.add(hex);
    }
  }

  void onClick(MouseEvent event) {
    final hex = _canvasToHex(event.offset);
    if (hex != null) {
      _onHexClicked.add(hex);
    }
  }

  void onMouseMove(MouseEvent event) =>
      _updateCursor(_canvasToHex(event.offset));

  @override
  void ngAfterChanges() {
    render();
  }
}
