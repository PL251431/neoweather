import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherRepository extends ChangeNotifier {
  Map<String, dynamic>? currentWeather;
  List<dynamic>? hourlyForecast;

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

      hourlyForecast = weatherData['forecast']['forecastday'][0]['hour']
          .map((hour) => {
                'time': hour['time'].split(' ')[1],
                'temperature': "${hour['temp_c']}°C",
                'condition': hour['condition']['text'],
                'iconUrl': "https:${hour['condition']['icon']}",
              })
          .toList();

      notifyListeners();
    } catch (_) {
      currentWeather = null;
      hourlyForecast = null;
      notifyListeners();
    }
  }
}
