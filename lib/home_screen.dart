import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherRepository = Provider.of<WeatherRepository>(context);
    final currentWeather = weatherRepository.currentWeather;
    final forecast = weatherRepository.dailyForecast;

    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCityInputField(),
              const SizedBox(height: 16.0),
              _buildSearchButton(weatherRepository),
              const SizedBox(height: 16.0),
              if (currentWeather != null) _buildWeatherCard(context, currentWeather),
              const SizedBox(height: 16.0),
              if (forecast != null) _buildDailyForecast(context, forecast),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityInputField() {
    return TextField(
      controller: cityController,
      decoration: const InputDecoration(
        labelText: "Digite o nome da cidade",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSearchButton(WeatherRepository repository) {
    return ElevatedButton(
      onPressed: () => repository.fetchWeather(cityController.text),
      child: const Text("Buscar Clima"),
    );
  }

  Widget _buildWeatherCard(BuildContext context, Map<String, dynamic> weatherData) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              weatherData['cityName'],
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Image.network(weatherData['iconUrl'], width: screenWidth * 0.2, height: screenWidth * 0.2),
            const SizedBox(height: 8.0),
            Text(
              weatherData['temperature'],
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _translateCondition(weatherData['condition']),
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecast(BuildContext context, List<dynamic> forecast) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: forecast.map((day) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ListTile(
            leading: Image.network(day['iconUrl'], width: 50, height: 50),
            title: Text("${day['date']}: ${day['temperature']}°C"),
            subtitle: Text(_translateCondition(day['condition'])),
          ),
        );
      }).toList(),
    );
  }

  String _translateCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return 'Ensolarado';
      case 'partly cloudy':
        return 'Parcialmente Nublado';
      case 'cloudy':
        return 'Nublado';
      case 'rainy':
        return 'Chuvoso';
      case 'stormy':
        return 'Tempestuoso';
      case 'snowy':
        return 'Nevando';
      case 'clear':
        return 'Limpo';
      default:
        return condition;
    }
  }
}