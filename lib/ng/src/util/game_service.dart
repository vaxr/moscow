import 'package:angular/core.dart';
import 'package:moscow/core/game/game.dart';

@Injectable()
class GameService {

  final game = Game.newDefaultGame();
}
