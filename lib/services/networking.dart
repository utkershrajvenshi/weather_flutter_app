import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

      //
      // print(
      //     'Temperature: $temperature\nID: $conditionId\nCity Name: $cityName');
    } else
      print('Error loading response');
  }
}
