import 'dart:convert';
import 'dart:io';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DavinciInfoserverService {
  final Uri _infoserverUrl;
  final String _infoserverDataFileName = 'infoserver_data.json';

  DavinciInfoserverService(String username, String encryptedPassword)
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
    return File('$path/$_infoserverDataFileName');
  }

  Future<void> writeDate(String data) async {
    final File file = await _infoserverDateFile;
    file.writeAsString(data);
  }

  Future<Map<String, dynamic>> getOfflineData() async {
    try {
      final File file = await _infoserverDateFile;
      final String infoserverData = await file.readAsString();
      return jsonDecode(infoserverData) as Map<String, dynamic>;
    } catch (e) {
      throw NoOfflineDataExeption();
    }
  }

  Future<Map<String, dynamic>> getOnlineData() async {
    http.Response response;
    try {
      response = await http.get(_infoserverUrl);
    } on SocketException {
      throw UserIsOfflineException();
    }
    if (response.statusCode == 200) {
      writeDate(response.body);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 900) {
      throw WrongLoginDataException();
    }
    throw UnknownErrorException();
  }
}
