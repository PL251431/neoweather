import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();

  String? cityName;
  String? temperature;
  String? condition;
  String? iconUrl;
  List<dynamic>? hourlyForecast;

  void fetchWeather() async {
    final String city = cityController.text;

    try {
      final weatherData = await weatherService.getWeather(city);

      setState(() {
        cityName = weatherData['location']['name'];
        temperature = "${weatherData['current']['temp_c']}°C";
        condition = weatherData['current']['condition']['text'];
        iconUrl = "https:${weatherData['current']['condition']['icon']}";
        hourlyForecast = weatherData['forecast']['forecastday'][0]['hour'];
      });
    } catch (_) {
      setState(() {
        cityName = null;
        temperature = null;
        condition = "Erro ao buscar dados";
        iconUrl = null;
        hourlyForecast = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildSearchButton(),
              const SizedBox(height: 16.0),
              if (cityName != null) _buildWeatherCard(context),
              const SizedBox(height: 16.0),
              if (hourlyForecast != null) _buildHourlyForecast(context),
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

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: fetchWeather,
      child: const Text("Buscar Clima"),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
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
              cityName!,
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Image.network(iconUrl!, width: screenWidth * 0.2, height: screenWidth * 0.2),
            const SizedBox(height: 8.0),
            Text(
              temperature!,
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              condition!,
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

  Widget _buildHourlyForecast(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast!.length,
        itemBuilder: (context, index) {
          final hourData = hourlyForecast![index];
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
                      "https:${hourData['condition']['icon']}",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "${hourData['time'].split(' ')[1]}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "${hourData['temp_c']}°C",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      hourData['condition']['text'],
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
