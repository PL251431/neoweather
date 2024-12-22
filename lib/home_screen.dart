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
    final forecast = weatherRepository.hourlyForecast;

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
              if (forecast != null) _buildHourlyForecast(context, forecast),
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
              weatherData['condition'],
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

  Widget _buildHourlyForecast(BuildContext context, List<dynamic> forecast) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final hourData = forecast[index];
          return Container(
            width: screenWidth * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      hourData['iconUrl'],
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      hourData['time'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      hourData['temperature'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      hourData['condition'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}