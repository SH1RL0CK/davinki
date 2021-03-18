import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:davinki/secret.dart' as secret;

class DavinciInfoserverService {
  final Uri infoserverUrl =
      Uri.https('stundenplan.bwshofheim.de', '/daVinciIS.dll', {'username': secret.username, 'password': secret.password, 'content': 'json'});

  Future<File> get _infoserverDateFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    return File('$path/infoserver_data.dart');
  }

  void writeDate(String data) async {
    File file = await _infoserverDateFile;
    file.writeAsString(data);
  }

  Future<Map<String, dynamic>?> getOfflineData() async {
    File file = await _infoserverDateFile;
    String infoserverData = await file.readAsString();
    return jsonDecode(infoserverData);
  }

  Future<Map<String, dynamic>?> getData() async {
    try {
      http.Response response = await http.get(infoserverUrl);
      if (response.statusCode == 200) {
        writeDate(response.body);
        return jsonDecode(response.body);
      }
    } on SocketException {
      return getOfflineData();
    }
    return {};
  }
}
