class UtilFunction {
  static String centsToDollarsRepresentation(int cents) {
    int _dollars = (cents / 100).truncate();
    int _onlyCents = cents - (_dollars * 100);

    String _centsString = _onlyCents.toString();

    if (_centsString.length == 1 && _onlyCents == 0) {
      _centsString += "0";
    } else if (_centsString.length == 1) {
      _centsString = "0" + _centsString;
    }

    if (_onlyCents == 0) {
      return "\$$_dollars";
    } else {
      return "\$$_dollars.$_centsString";
    }
  }
}