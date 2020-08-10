import 'package:collection/collection.dart';
import 'package:moscow/core/data/board.dart';
import 'package:moscow/core/map/grid.dart';
import 'package:test/test.dart';

void main() {
  group(Hex, () {
    group('get neighbors', () {
      void exp(Hex item, Set<Hex> expected) {
        test(item, () {
          expect(item.neighbors, expected);
        });
      }

      exp(Hex(2, 3),
          {Hex(2, 2), Hex(3, 3), Hex(3, 4), Hex(2, 4), Hex(1, 4), Hex(1, 3)});
      exp(Hex(3, 4),
          {Hex(3, 3), Hex(4, 3), Hex(4, 4), Hex(3, 5), Hex(2, 4), Hex(2, 3)});
    });

    group('isNeighbor()', () {
      void exp(Hex item, Set<Hex> neighbors, Set<Hex> notNeighbors) {
        test(item, () {
          for (var hex in neighbors) {
            expect(item.isNeighbor(hex), true,
                reason: '$hex should be neighbor of $item');
          }
          for (var hex in notNeighbors) {
            expect(item.isNeighbor(hex), false,
                reason: '$hex should NOT be neighbor of $item');
          }
        });
      }

      exp(Hex(2, 3), {
        Hex(2, 2),
        Hex(3, 3),
        Hex(3, 4),
        Hex(2, 4),
        Hex(1, 4),
        Hex(1, 3),
      }, {
        Hex(2, 1),
        Hex(3, 2),
        Hex(4, 2),
        Hex(4, 3),
        Hex(4, 4),
        Hex(3, 5),
        Hex(2, 5),
        Hex(1, 5),
        Hex(0, 4),
        Hex(0, 3),
        Hex(0, 2),
        Hex(1, 2),
      });

      exp(Hex(11, 5), {
        Hex(11, 4),
        Hex(12, 4),
        Hex(12, 5),
        Hex(11, 6),
        Hex(10, 5),
        Hex(10, 4),
      }, {
        Hex(11, 3),
        Hex(12, 3),
        Hex(13, 4),
        Hex(13, 5),
        Hex(13, 6),
        Hex(12, 6),
        Hex(11, 7),
        Hex(10, 6),
        Hex(9, 6),
        Hex(9, 5),
        Hex(9, 4),
        Hex(10, 3),
      });
    });

    group('neighbor', () {
      void tt(Hex hex, Direction direction, Hex expected) {
        test('${hex}\'s $direction neighbor is $expected', () {
          expect(hex.neighbor(direction), expected);
        });
      }

      tt(Hex(7, 8), Direction.North, Hex(7, 7));
      tt(Hex(7, 8), Direction.NorthEast, Hex(8, 7));
      tt(Hex(7, 8), Direction.SouthEast, Hex(8, 8));
      tt(Hex(7, 8), Direction.South, Hex(7, 9));
      tt(Hex(7, 8), Direction.SouthWest, Hex(6, 8));
      tt(Hex(7, 8), Direction.NorthWest, Hex(6, 7));
    });

    group('distanceTo()', () {
      void exp(Hex item, Hex other, int expected) {
        test('$item to $other', () {
          expect(item.distanceTo(other), expected);
        });
      }

      exp(Hex(11, 3), Hex(11, 3), 0);
      exp(Hex(11, 3), Hex(11, 4), 1);
      exp(Hex(11, 3), Hex(12, 2), 1);
      exp(Hex(11, 3), Hex(13, 2), 2);
      exp(Hex(11, 3), Hex(3, 7), 8);
      exp(Hex(11, 3), Hex(16, 7), 7);
      exp(Hex(11, 3), Hex(13, 1), 3);
    });

    group('borderDirection()', () {
      void exp(Hex item, Hex other, Direction expected) {
        test('$item and $other', () {
          expect(item.borderDirection(other), expected);
        });
      }

      exp(Hex(6, 6), Hex(6, 5), Direction.North);
      exp(Hex(6, 6), Hex(7, 6), Direction.NorthEast);
      exp(Hex(6, 6), Hex(7, 7), Direction.SouthEast);
      exp(Hex(6, 6), Hex(6, 7), Direction.South);
      exp(Hex(6, 6), Hex(5, 7), Direction.SouthWest);
      exp(Hex(6, 6), Hex(5, 6), Direction.NorthWest);
      exp(Hex(6, 6), Hex(4, 6), null);
      exp(Hex(6, 6), Hex(6, 9), null);
    });
  });

  group(Edge, () {
    group('between', () {
      void exp(Hex a, Hex b, Edge expected) {
        test('$a and $b', () {
          expect(Edge.between(a, b), expected);
        });
      }

      exp(Hex(6, 6), Hex(6, 5), Edge(6, 6, Direction.North));
      exp(Hex(6, 6), Hex(7, 6), Edge(6, 6, Direction.NorthEast));
      exp(Hex(6, 6), Hex(7, 7), Edge(7, 7, Direction.NorthWest));
      exp(Hex(6, 6), Hex(6, 7), Edge(6, 7, Direction.North));
      exp(Hex(6, 6), Hex(5, 7), Edge(5, 7, Direction.NorthEast));
      exp(Hex(6, 6), Hex(5, 6), Edge(6, 6, Direction.NorthWest));
      exp(Hex(6, 6), Hex(4, 6), null);
    });

    group('canonical', () {
      void exp(Edge item, Edge expected) {
        test(item, () {
          expect(item.canonical.hex, expected.hex);
          expect(item.canonical.direction, expected.direction);
        });
      }

      exp(Edge(6, 6, Direction.North), Edge(6, 6, Direction.North));
      exp(Edge(6, 6, Direction.NorthEast), Edge(6, 6, Direction.NorthEast));
      exp(Edge(6, 6, Direction.SouthEast), Edge(7, 7, Direction.NorthWest));
      exp(Edge(6, 6, Direction.South), Edge(6, 7, Direction.North));
      exp(Edge(6, 6, Direction.SouthWest), Edge(5, 7, Direction.NorthEast));
      exp(Edge(6, 6, Direction.NorthWest), Edge(6, 6, Direction.NorthWest));
      exp(Edge(7, 8, Direction.North), Edge(7, 8, Direction.North));
      exp(Edge(7, 8, Direction.NorthEast), Edge(7, 8, Direction.NorthEast));
      exp(Edge(7, 8, Direction.SouthEast), Edge(8, 8, Direction.NorthWest));
      exp(Edge(7, 8, Direction.South), Edge(7, 9, Direction.North));
      exp(Edge(7, 8, Direction.SouthWest), Edge(6, 8, Direction.NorthEast));
      exp(Edge(7, 8, Direction.NorthWest), Edge(7, 8, Direction.NorthWest));
    });

    group('neighborsClockwise', () {
      void tt(Edge input, Iterable<Edge> expected) {
        test(input, () {
          final result = input.clockwiseNeighbors;
          if (!result.containsAll(expected)) {
            fail('Mismatch for $input\n  Exp: $expected\n  Got: $result');
          }
        });
      }

      tt(Edge(7, 8, Direction.North), {
        Edge(7, 8, Direction.NorthEast),
        Edge(8, 7, Direction.NorthWest),
      });
      tt(Edge(7, 8, Direction.NorthEast), {
        Edge(7, 8, Direction.SouthEast),
        Edge(8, 8, Direction.North),
      });
      tt(Edge(7, 8, Direction.SouthEast), {
        Edge(7, 8, Direction.South),
        Edge(7, 9, Direction.NorthEast),
      });
      tt(Edge(7, 8, Direction.South), {
        Edge(7, 8, Direction.SouthWest),
        Edge(6, 8, Direction.SouthEast),
      });
      tt(Edge(7, 8, Direction.SouthWest), {
        Edge(7, 8, Direction.NorthWest),
        Edge(6, 7, Direction.South),
      });
      tt(Edge(7, 8, Direction.NorthWest), {
        Edge(7, 8, Direction.North),
        Edge(7, 7, Direction.SouthWest),
      });
    });
  });

  group(Hexes, () {
    group('connectedGroups()', () {
      void tt(String caption, Set<Hex> input, Set<Set<Hex>> expected) {
        test(caption, () {
          final result = Hexes.connectedGroups(input);
          if (!DeepCollectionEquality.unordered().equals(result, expected)) {
            fail('Unequal:\n  Expected $expected\n  Got      $result');
          }
        });
      }

      tt('Soviet starting positions', SovietSetupHexes, {
        {Hex(3, 1), Hex(3, 2), Hex(3, 3), Hex(3, 4)},
        {
          Hex(4, 5),
          Hex(5, 4),
          Hex(5, 5),
          Hex(5, 6),
          Hex(5, 7),
          Hex(5, 8),
          Hex(5, 9),
          Hex(5, 10)
        },
        {Hex(8, 3)},
      });
      tt('German starting positions', GermanSetupHexes, {GermanSetupHexes});
    });

    group('borders', () {
      void tt(String caption, Set<Hex> input, List<List<Edge>> expected) {
        test(caption, () {
          final result = Hexes.borders(input);
          if (!DeepCollectionEquality().equals(result, expected)) {
            fail('Unequal:\n  Expected $expected\n  Got      $result');
          }
        });
      }

      tt('empty', {}, []);
      tt('simple ring', {
        Hex(7, 7),
        Hex(8, 7),
        Hex(8, 8),
        Hex(7, 9),
        Hex(6, 8),
        Hex(6, 7)
      }, [
        [
          Edge(7, 7, Direction.North),
          Edge(7, 7, Direction.NorthEast),
          Edge(8, 7, Direction.North),
          Edge(8, 7, Direction.NorthEast),
          Edge(8, 7, Direction.SouthEast),
          Edge(8, 8, Direction.NorthEast),
          Edge(8, 8, Direction.SouthEast),
          Edge(8, 8, Direction.South),
          Edge(7, 9, Direction.SouthEast),
          Edge(7, 9, Direction.South),
          Edge(7, 9, Direction.SouthWest),
          Edge(6, 8, Direction.South),
          Edge(6, 8, Direction.SouthWest),
          Edge(6, 8, Direction.NorthWest),
          Edge(6, 7, Direction.SouthWest),
          Edge(6, 7, Direction.NorthWest),
          Edge(6, 7, Direction.North),
          Edge(7, 7, Direction.NorthWest),
        ],
        [
          Edge(7, 8, Direction.North),
          Edge(7, 8, Direction.NorthEast),
          Edge(7, 8, Direction.SouthEast),
          Edge(7, 8, Direction.South),
          Edge(7, 8, Direction.SouthWest),
          Edge(7, 8, Direction.NorthWest),
        ],
      ]);
    });
  });
}
