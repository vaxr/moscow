import 'dart:async';

import 'package:angular/angular.dart';
import 'package:moscow/core/model/units.dart';
import 'package:moscow/ng/src/unit/unit.component.dart';

@Component(
  selector: 'app-reserve',
  styleUrls: ['reserve.component.css'],
  templateUrl: 'reserve.component.html',
  directives: [NgFor, UnitComponent],
  providers: [],
)
class ReserveComponent {
  @Input()
  Set<Unit> units;
  
  @Input()
  set disabled(bool value) {
    _disabled = value;
    if (_disabled) {
      selected = null;
    }
  }
  bool _disabled = false;

  @Input()
  Unit selected;

  @Output()
  Stream<Unit> get selectedChange => _onSelect.stream;
  final _onSelect = StreamController<Unit>();

  @Output()
  Stream<Unit> get onHover => _onHover.stream;
  final _onHover = StreamController<Unit>();

  List<Unit> get unitsByBest => Units.byBest(units);

  void click(Unit unit) {
    if (!_disabled && unit != selected) {
      selected = unit;
      _onSelect.add(unit);
    }
  }

  void hover(Unit unit) {
    if (unit != null) {
      _onHover.add(unit);
    }
  }
}
