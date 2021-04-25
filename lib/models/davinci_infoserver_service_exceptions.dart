class WrongLoginDataException implements Exception {
  final String _message = 'The username or password is not correct!';
  @override
  String toString() {
    return this._message;
  }
}

class UserIsOfflineException implements Exception {
  final String _message = 'The user is offline!';
  @override
  String toString() {
    return this._message;
  }
}

class NoOfflineDataExeption implements Exception {
  final String _message = 'No offline data was found!';
  @override
  String toString() {
    return this._message;
  }
}