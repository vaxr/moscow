import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/color/color.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';

@Component(
  selector: 'app-unit',
  styleUrls: [],
  template: '<canvas #canvas width="{{ size }}" height="{{ size }}"></canvas>',
  directives: [],
  providers: [],
)
class UnitComponent implements OnInit, AfterViewInit, AfterChanges {
  @ViewChild('canvas')
  CanvasElement canvas;

  @Input()
  int size = 46;

  @Input()
  Unit unit;

  @Input()
  set selected(bool value) {
    if (value != _selected) {
      _selected = value;
      _render();
    }
  }

  @Output()
  Stream<Unit> get onClick => _onClick.stream;
  final _onClick = StreamController<Unit>();

  @Output()
  Stream<Unit> get onHover => _onHover.stream;
  final _onHover = StreamController<Unit>();

  final UnitRenderer _unitRenderer;

  UnitComponent(this._unitRenderer);

  bool _hover = false;
  bool _selected = false;

  Color get _backColor => _selected ? UnitRenderer.colorBackHighlight : null;

  Color get _frameColor => _hover ? UnitRenderer.colorFrameHighlight : null;

  @override
  void ngOnInit() {
    canvas.onMouseOver.listen((event) {
      if (!_hover) {
        _hover = true;
        _onHover.add(unit);
        _render();
      }
    });
    canvas.onMouseOut.listen((event) {
      if (_hover) {
        _hover = false;
        _onHover.add(null);
        _render();
      }
    });
    canvas.onClick.listen((_) => _onClick.add(unit));
  }

  @override
  void ngAfterViewInit() {
    _render();
  }

  void _render() {
    final ctx = canvas.context2D;
    ctx.setFillColorRgb(255, 0, 0);
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    final center = Point(canvas.width / 2.0, canvas.height / 2.0);
    _unitRenderer.draw(
      ctx,
      unit,
      center,
      size.toDouble(),
      backColor: _backColor,
      frameColor: _frameColor,
    );
  }

  @override
  void ngAfterChanges() {
    _render();
  }
}
