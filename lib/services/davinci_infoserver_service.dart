import 'dart:convert';
import 'dart:io';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DavinciInfoserverService {
  final String _username;
  final String _password;

  Uri _infoserverUrl;
  DavinciInfoserverService(this._username, this._password)
      : _infoserverUrl = Uri.https(
          'stundenplan.bwshofheim.de',
          '/daVinciIS.dll',
          <String, String>{
            'username': _username,
            'password': _password,
            'content': 'json',
          },
        );

  Future<File> get _infoserverDateFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    return File('$path/infoserver_data.json');
  }

  void writeDate(String data) async {
    File file = await _infoserverDateFile;
    file.writeAsString(data);
  }

  Future<Map<String, dynamic>> getOfflineData() async {
    File file = await _infoserverDateFile;
    String infoserverData = await file.readAsString();
    return jsonDecode(infoserverData);
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
    } else if (response.statusCode == 910) {
      throw WrongLoginDataException();
    }
    return <String, dynamic>{};
  }
}
