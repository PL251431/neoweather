import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_repository.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherRepository()),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoWeather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Cor principal
        scaffoldBackgroundColor: Colors.blue[50], // Cor de fundo da tela
        textTheme: GoogleFonts.robotoTextTheme(
          // Definindo a tipografia
          Theme.of(context).textTheme,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent, // Cor do botão
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue[800], // Cor da AppBar
          titleTextStyle:
              GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
