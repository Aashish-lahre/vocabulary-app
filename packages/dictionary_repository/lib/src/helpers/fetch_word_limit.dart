

class FetchWordLimit {
  FetchWordLimit._();

  // fetching more than 15 words is prohibited.
  static const upperLimit = 15;

  // default limit for fetching word when app starts.
  static int _initialFetchWordLimit = 10;
  // default limit for fetching word for later fetching.
  static int _laterFetchWordLimit = 5;

  static set initialFetchWordLimit(int count) {
    // count is the no. of words to fetch from Api.

    if(count <= 0 ) {
      throw ArgumentError("initialFetchWordLimit must be more than 0");
    }

    if(count <= _laterFetchWordLimit) {
      throw ArgumentError("initialFetchWordLimit must be more than laterFetchWordLimit");
    }

    if (count > upperLimit) {
      throw ArgumentError("initialFetchWordLimit must not exceed $upperLimit");
    }

    if(count > 0 && count > _laterFetchWordLimit && count < 15) {
      _initialFetchWordLimit = count;
    }

}

  static set laterFetchWordLimit(int count) {
    // count is the no. of words to fetch from Api.

    if(count <= 0 ) {
      throw ArgumentError("laterFetchWordLimit must be more than 0");
    }

    if(count >= _initialFetchWordLimit) {
      throw ArgumentError("laterFetchWordLimit must be less than initialFetchWordLimit");
    }

    if(count > 0 && count < _initialFetchWordLimit) {
      _laterFetchWordLimit = count;
    }

  }


 static int get initialFetchWordLimit => _initialFetchWordLimit;
  static int get laterFetchWordLimit => _laterFetchWordLimit;
}