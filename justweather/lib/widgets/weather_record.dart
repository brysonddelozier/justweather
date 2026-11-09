import 'package:flutter/material.dart';
import 'package:justweather/objects/weather_data.dart';
import 'package:justweather/objects/locations.dart';
import 'package:justweather/api/weather_service.dart';

class WeatherRecord extends StatefulWidget {
  const WeatherRecord({super.key, required this.location});

  final Location location;

  @override
  State<WeatherRecord> createState() => _WeatherRecordState();
}

class _WeatherRecordState extends State<WeatherRecord> {

  late Future<WeatherData> weatherData;
  @override
  void initState() {
    super.initState();
    weatherData = getWeather(latitude: widget.location.latitude, longitude: widget.location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<WeatherData>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListTile(
              title: Text(widget.location.name),
              subtitle: Text('Region: ${data.region}, Temp: ${data.temperature}°, High: ${data.high}°, Low: ${data.low}°'),
            );
          } else {
            return const Text('No data available');
          }
        },
      )
    );
  }
}