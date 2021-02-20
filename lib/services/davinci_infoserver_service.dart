import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:DAVINKI/secret.dart' as secret;

class DavinciInfoserverService {
  final String infoserverUrl = 'https://stundenplan.bwshofheim.de/daVinciIS.dll?username=${secret.username}&password=${secret.password}&content=json';

  Future<Map<String, dynamic>> getData() async {
    http.Response response = await http.get(infoserverUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return {};
    }
  }
}
