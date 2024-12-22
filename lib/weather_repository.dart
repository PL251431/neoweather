import 'package:flutter/material.dart';
import 'weather_service.dart';


class WeatherRepository extends ChangeNotifier {
  Map<String, dynamic>? currentWeather;
  List<dynamic>? dailyForecast;

  Future<void> fetchWeather(String city) async {
    try {
      final weatherService = WeatherService();
      final weatherData = await weatherService.getWeather(city);

      currentWeather = {
        'cityName': weatherData['location']['name'],
        'temperature': "${weatherData['current']['temp_c']}°C",
        'condition': weatherData['current']['condition']['text'],
        'iconUrl': "https:${weatherData['current']['condition']['icon']}",
      };

      dailyForecast = weatherData['forecast']['forecastday']
          .map((day) => {
                'date': day['date'],
                'temperature': "${day['day']['avgtemp_c']}°C",
                'condition': day['day']['condition']['text'],
                'iconUrl': "https:${day['day']['condition']['icon']}",
              })
          .toList();

      notifyListeners();
    } catch (_) {
      currentWeather = null;
      dailyForecast = null;
      notifyListeners();
    }
  }
}
