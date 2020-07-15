import 'package:moscow/core/util/quiver/bimap.dart';
import 'package:test/test.dart';

void main() {
  group(BiMap, () {
    test('smoke test', () {
      var m = BiMap<String, int>();
      m['three'] = 3;
      m['five'] = 5;
      m.inverse[7] = 'seven';
      expect(m['three'], 3);
      expect(m['five'], 5);
      expect(m.inverse[5], 'five');
      expect(m['seven'], 7);
    });
  });
}
