import 'package:angular/angular.dart';
import 'package:moscow/core/model/game.dart';
import 'package:moscow/ng/src/unit/unit-renderer.service.dart';
import 'package:moscow/ng/src/util/table_service.dart';

import 'src/board/board_component.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  providers: [
    UnitRenderer,
  ],
  directives: [
    BoardComponent,
  ],
)
class AppComponent {
  Table get table => TableService().makeTable();
}
