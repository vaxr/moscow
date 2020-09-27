import 'package:moscow/core/model/units.dart';

import 'game.dart';

class SerializationException implements Exception {}

abstract class Serializer<T> {
  String serialize(T obj);

  T deserialize(String raw);
}

class FactionSerializer implements Serializer<Faction> {
  @override
  Faction deserialize(String raw) {
    switch (raw) {
      case 'g':
        return Faction.German;
      case 's':
        return Faction.Soviet;
      default:
        throw SerializationException();
    }
  }

  @override
  String serialize(Faction obj) {
    switch (obj) {
      case Faction.German:
        return 'g';
      case Faction.Soviet:
        return 's';
      default:
        throw SerializationException();
    }
  }
}

class PhaseSerializer implements Serializer<Phase> {
  @override
  Phase deserialize(String raw) {
    try {
      return Phase.nr[int.parse(raw)];
    } catch (e) {
      throw SerializationException();
    }
  }

  @override
  String serialize(Phase obj) => '${obj.order}';
}
