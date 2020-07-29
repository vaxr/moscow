
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';

@Component(
  selector: 'app-unit',
  styleUrls: [],
  template: '<canvas #canvas width="{{ size }}" height="{{ size }}"></canvas>',
  directives: [],
  providers: [],
)
class UnitComponent implements AfterViewInit, AfterChanges {

  @ViewChild('canvas')
  CanvasElement canvas;
  
  @Input()
  int size = 46;

  @Input()
  Unit unit;

  UnitRenderer _unitRenderer;

  UnitComponent(this._unitRenderer);

  @override
  void ngAfterViewInit() {
    _render();
  }
  
  void _render() {
    final ctx = canvas.context2D;
    ctx.setFillColorRgb(255, 0, 0);
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    final center = Point(canvas.width / 2.0, canvas.height / 2.0);
    _unitRenderer.draw(ctx, unit, center, size.toDouble());
  }

  @override
  void ngAfterChanges() {
    _render();
  }
}
