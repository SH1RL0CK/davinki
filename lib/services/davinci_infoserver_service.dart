import 'dart:convert';
import 'dart:io';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DavinciInfoserverService {
  Uri _infoserverUrl;
  final String _infoserverDataFileName = 'infoserver_data.json';

  DavinciInfoserverService(username, encryptedPassword)
      : _infoserverUrl = Uri.https(
          'stundenplan.bwshofheim.de',
          '/daVinciIS.dll',
          <String, String>{
            'username': username,
            'key': encryptedPassword,
            'content': 'json',
          },
        );

  Future<File> get _infoserverDateFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    return File('$path/${this._infoserverDataFileName}');
  }

  void writeDate(String data) async {
    File file = await _infoserverDateFile;
    file.writeAsString(data);
  }

  Future<Map<String, dynamic>> getOfflineData() async {
    try {
      File file = await _infoserverDateFile;
      String infoserverData = await file.readAsString();
      return jsonDecode(infoserverData);
    } catch (e) {
      throw NoOfflineDataExeption();
    }
  }

  Future<Map<String, dynamic>> getOnlineData() async {
    http.Response response;
    try {
      response = await http.get(this._infoserverUrl);
    } on SocketException {
      throw UserIsOfflineException();
    }
    if (response.statusCode == 200) {
      writeDate(response.body);
      return jsonDecode(response.body);
    } else if (<int>[900, 910].contains(response.statusCode)) {
      throw WrongLoginDataException();
    }
    throw UnknownErrorException();
  }
}
