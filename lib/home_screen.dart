import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../weather_repository.dart';
import 'widgets/input_field.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/weather_card.dart';
import 'widgets/daily_forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherRepository = Provider.of<WeatherRepository>(context);
    final currentWeather = weatherRepository.currentWeather;
    final forecast = weatherRepository.dailyForecast;
    final errorMessage = weatherRepository.errorMessage;
    final isLoading = weatherRepository.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("NeoWeather"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputField(controller: cityController),
              const SizedBox(height: 16.0),
              _buildSearchButton(weatherRepository),
              const SizedBox(height: 16.0),
              if (isLoading) const LoadingIndicator(),
              if (errorMessage != null) _buildErrorMessage(errorMessage),
              if (currentWeather != null && !isLoading)
                WeatherCard(weatherData: currentWeather),
              const SizedBox(height: 16.0),
              if (forecast != null && !isLoading)
                DailyForecast(forecast: forecast),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(WeatherRepository repository) {
    return ElevatedButton(
      onPressed: () {
        if (cityController.text.isNotEmpty) {
          repository.fetchWeather(cityController.text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        elevation: 5,
      ),
      child: Text(
        "Buscar Clima",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red, fontSize: 16),
    );
  }
}
