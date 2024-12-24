import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_repository.dart';
import 'package:google_fonts/google_fonts.dart';

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
              _buildCityInputField(),
              const SizedBox(height: 16.0),
              _buildSearchButton(weatherRepository),
              const SizedBox(height: 16.0),
              if (isLoading) _buildLoadingIndicator(),
              if (errorMessage != null) _buildErrorMessage(errorMessage),
              if (currentWeather != null && !isLoading)
                _buildWeatherCard(context, currentWeather),
              const SizedBox(height: 16.0),
              if (forecast != null && !isLoading)
                _buildDailyForecast(context, forecast),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityInputField() {
    return TextField(
      controller: cityController,
      decoration: InputDecoration(
        labelText: "Digite o nome da cidade",
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        prefixIcon: Icon(Icons.location_city, color: Colors.blueAccent),
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

  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      strokeWidth: 5.0,
    );
  }

  Widget _buildErrorMessage(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red, fontSize: 16),
    );
  }

  Widget _buildWeatherCard(
      BuildContext context, Map<String, dynamic> weatherData) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              weatherData['cityName'],
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Image.network(weatherData['iconUrl'],
                width: screenWidth * 0.2, height: screenWidth * 0.2),
            const SizedBox(height: 8.0),
            Text(
              weatherData['temperature'],
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              weatherData['condition'],
              style: GoogleFonts.roboto(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: forecast.map((day) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: ListTile(
            leading: Image.network(day['iconUrl'], width: 50, height: 50),
            title: Text(
              "${day['date']}: ${day['temperature']}",
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(day['condition']),
          ),
        );
      }).toList(),
    );
  }
}
