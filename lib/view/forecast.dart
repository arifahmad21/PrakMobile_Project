import 'package:flutter/material.dart';
import 'package:projek_akhir/model/weather_forecast.dart';
import 'package:projek_akhir/services/load_data2.dart';

class WeatherForecastScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherForecastScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<List<WeatherForecast>> forecast;

  @override
  void initState() {
    super.initState();
    forecast = WeatherService.loadForecast(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5-Day Weather Forecast'),
      ),
      body: FutureBuilder<List<WeatherForecast>>(
        future: forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final List<WeatherForecast> forecastList = snapshot.data!;
            return ListView.builder(
              itemCount: forecastList.length,
              itemBuilder: (context, index) {
                final weather = forecastList[index];
                return ListTile(
                  leading: Image.network('https:${weather.conditionIcon}'),
                  title: Text('${weather.date} - ${weather.conditionText}'),
                  subtitle: Text('Max Temp: ${weather.maxTempC}°C, Min Temp: ${weather.minTempC}°C'),
                  trailing: Text(weather.willItRain ? 'Bad' : 'Good'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
