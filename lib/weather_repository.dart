import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherRepository extends ChangeNotifier {
  Map<String, dynamic>? currentWeather;
  List<dynamic>? dailyForecast;
  String? errorMessage;
  bool isLoading = false;

  String _translateCondition(String condition) {
    switch (condition.toLowerCase().trim()) {
      case 'sunny':
        return 'Ensolarado';
      case 'partly cloudy':
        return 'Parcialmente Nublado';
      case 'cloudy':
        return 'Nublado';
      case 'overcast':
        return 'Encoberto';
      case 'light rain':
        return 'Chuva Leve';
      case 'moderate rain':
        return 'Chuva Moderada';
      case 'heavy rain':
        return 'Chuva Forte';
      case 'rainy':
        return 'Chuvoso';
      case 'stormy':
        return 'Tempestuoso';
      case 'snowy':
        return 'Nevando';
      case 'clear':
        return 'Limpo';
      case 'patchy rain nearby':
        return 'Chuva Irregular Próxima';
      case 'patchy light drizzle':
        return 'Garoa Leve e Irregular';
      case 'thunderstorms':
        return 'Trovoadas';
      case 'light rain shower':
        return 'Chuva Leve';
      case 'thundery outbreaks in nearby':
        return 'Trovoadas nas proximidades';
      default:
        return condition;
    }
  }

  Future<void> fetchWeather(String city) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final weatherService = WeatherService();
      final weatherData = await weatherService.getWeather(city);

      currentWeather = {
        'cityName': weatherData['location']['name'],
        'temperature': "${weatherData['current']['temp_c']}°C",
        'condition':
            _translateCondition(weatherData['current']['condition']['text']),
        'iconUrl': "https:${weatherData['current']['condition']['icon']}",
      };

      dailyForecast = weatherData['forecast']['forecastday']
          .map((day) => {
                'date': day['date'],
                'temperature': "${day['day']['avgtemp_c']}°C",
                'condition':
                    _translateCondition(day['day']['condition']['text']),
                'iconUrl': "https:${day['day']['condition']['icon']}",
              })
          .toList();
    } catch (e) {
      errorMessage = "Erro na conexão: $e";
      currentWeather = null;
      dailyForecast = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
