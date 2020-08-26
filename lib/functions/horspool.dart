class Horspool {
  String _text, _pattern;
  int _n, _m;
  List<int> _occ;

  Horspool(String text, String pattern) {
    _text = text;
    _pattern = pattern;
    _n = text.length;
    _m = pattern.length;
    _occ = [];

    for (var i = 0; i < 256; i++) {
      _occ.add(-1);
    }

    for (var i = 0; i < _m; i++) {
      _occ[_pattern.codeUnitAt(i)] = i;
    }
  }

  bool search() {
    int i = 0, j;

    while (i <= _n - _m) {
      j = _m - 1;

      while (j >= 0 && _pattern[j] == _text[i + j]) j--;

      if (j < 0) return true;

      i += _m - 1;
      i -= _occ[_text.codeUnitAt(i)];
    }
    return false;
  }
}