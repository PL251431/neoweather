import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyForecast extends StatelessWidget {
  final List<dynamic> forecast;

  const DailyForecast({required this.forecast, super.key});

  @override
  Widget build(BuildContext context) {
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
