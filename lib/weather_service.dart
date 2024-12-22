import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherService {
  final String apiKey = "8aad7eb31eae46718f405111241412";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final String url = "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=3&aqi=no&alerts=no";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Erro: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro na conexão: $e");
    }
  }
}
