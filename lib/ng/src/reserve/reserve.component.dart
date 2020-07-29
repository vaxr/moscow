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

  List<Unit> get unitsByStrength => units.toList()
      ..sort((a, b) {
        var order = b.fullStrength - a.fullStrength;
        if (order == 0) {
          order = b.movement - a.movement;
        }
        if (order == 0) {
          order = a.id.compareTo(b.id);
        }
        return order;
      });
}
