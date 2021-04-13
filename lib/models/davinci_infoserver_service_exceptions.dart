class WrongLoginDataException implements Exception {
  final String _message = 'The username or password is not correct!';
  @override
  String toString() {
    return this._message;
  }
}

class UserIsOfflineException {
  final String _message = 'The user is offline!';
  @override
  String toString() {
    return this._message;
  }
}
