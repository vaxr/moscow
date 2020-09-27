import 'package:moscow/core/model/game.dart';
import 'package:moscow/core/model/serializer.dart';
import 'package:moscow/core/model/units.dart';
import 'package:test/test.dart';

void main() {
  void testSerialize(Serializer serializer, Object item) {
    test('Serializes and deserializes correctly for $item', () {
      final raw = serializer.serialize(item);
      final cloned = serializer.deserialize(raw);
      expect(cloned, item);
    });
  }

  group(Faction, () {
    testSerialize(FactionSerializer(), Faction.German);
    testSerialize(FactionSerializer(), Faction.Soviet);
  });

  group(Phase, () {
    for (var i = 0; i < Phase.nr.length; i++) {
      testSerialize(PhaseSerializer(), Phase.nr[i]);
    }
  });
}
