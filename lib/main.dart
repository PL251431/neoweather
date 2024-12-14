import 'package:flutter/material.dart';
import 'weather_service.dart'; // Importa o serviço que criamos

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Clima',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService(); 
  final TextEditingController cityController = TextEditingController(); 
  String? weatherInfo; 

  void fetchWeather() async {
    final String city = cityController.text; 

    try {
      final weatherData = await weatherService.getWeather(city);

      setState(() {
        weatherInfo =
            "Cidade: ${weatherData['location']['name']}\n" "Temperatura: ${weatherData['current']['temp_c']}°C\n" "Clima: ${weatherData['current']['condition']['text']}";
      });
    } catch (e) {
      setState(() {
        weatherInfo = "Erro ao buscar dados: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NeoWeather")),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "Digite o nome da cidade",
                border: OutlineInputBorder(),
              ),
            ),
           
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text("Buscar Clima"),
            ),
           
            weatherInfo != null
                ? Text(weatherInfo!, textAlign: TextAlign.center)
                : const Text("Nenhuma informação disponível"),
          ],
        ),
      ),
    );
  }
}
