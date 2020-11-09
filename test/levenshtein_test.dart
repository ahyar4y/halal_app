import 'package:test/test.dart';
import 'package:stringmatcher/stringmatcher.dart';

void main() {
  test('match string', () {
    final lev = StringMatcher(term: Term.char, algorithm: Levenshtein());
    List<String> strtomatch = ['Adenosine 5′ Monophosphate'];
    String str = 'Monosodium Glutamate';

    expect(
        lev.partialSimilarOne(
            str, strtomatch, (a, b) => a.ratio.compareTo(b.ratio),
            selector: (x) => x.percent).item2,
        '');
  });
}
