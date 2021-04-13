class WrongLoginDataException implements Exception {
  final String _message = 'Wrong username or password';
  @override
  String toString() {
    return this._message;
  }
}
